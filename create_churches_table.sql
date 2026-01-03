-- 1. churches 테이블 생성
create table public.churches (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  profile_image_url text,
  denomination text,
  address text,
  pastor_name text,
  description text,
  status text default '활성' check (status in ('활성', '비활성', '대기')),
  phone text,
  region text,
  sub_region text,
  website text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 2. 인덱스 생성
create index churches_name_idx on public.churches(name);
create index churches_region_idx on public.churches(region, sub_region);
create index churches_denomination_idx on public.churches(denomination);
create index churches_status_idx on public.churches(status);

-- 3. RLS 활성화
alter table public.churches enable row level security;

-- 4. 정책 설정
create policy "Anyone can view active churches"
  on public.churches for select
  using (status = '활성');

create policy "Authenticated users can view all churches"
  on public.churches for select
  using (auth.role() = 'authenticated');

-- 5. updated_at 자동 업데이트 함수
create or replace function public.handle_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

-- 6. Trigger 연결
create trigger on_churches_updated
  before update on public.churches
  for each row execute procedure public.handle_updated_at();

-- 7. 검색 기능을 위한 Full Text Search 설정 (선택사항)
alter table public.churches
  add column search_vector tsvector
  generated always as (
    setweight(to_tsvector('simple', coalesce(name, '')), 'A') ||
    setweight(to_tsvector('simple', coalesce(address, '')), 'B') ||
    setweight(to_tsvector('simple', coalesce(denomination, '')), 'C')
  ) stored;

create index churches_search_idx on public.churches using gin(search_vector);

-- 8. 사랑의교회 샘플 데이터 입력
insert into public.churches (
  name,
  denomination,
  address,
  pastor_name,
  description,
  status,
  phone,
  region,
  sub_region,
  website
)
values (
  '사랑의교회',
  '대한예수교장로회(합동)',
  '서울특별시 서초구 반포대로 28길 18-17',
  '오정현',
  '하나님을 사랑하고 이웃을 섬기는 교회',
  '활성',
  '02-3489-1000',
  '서울시',
  '서초구',
  'https://www.sarang.org'
);

-- 9. 테이블 확인
select * from public.churches;
