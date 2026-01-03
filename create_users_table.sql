-- 1. users 테이블 생성
create table public.users (
  id uuid references auth.users on delete cascade primary key,
  mid text unique not null,
  nickname text not null,
  phone text,
  birth_date date,
  address text,
  profile_image_url text,
  church_id uuid references public.churches(id) on delete set null,
  position text,
  departments text[],
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 2. 인덱스 생성
create index users_mid_idx on public.users(mid);
create index users_nickname_idx on public.users(nickname);
create index users_church_id_idx on public.users(church_id);

-- 3. RLS 활성화
alter table public.users enable row level security;

-- 4. 정책 설정
-- 본인 데이터는 읽기 가능
create policy "Users can view own data"
  on public.users for select
  using (auth.uid() = id);

-- 모든 사용자는 다른 사용자의 기본 정보 조회 가능
create policy "Users can view other users basic info"
  on public.users for select
  using (true);

-- 본인 데이터는 업데이트 가능
create policy "Users can update own data"
  on public.users for update
  using (auth.uid() = id);

-- 5. mid 자동 생성 함수
create or replace function public.generate_mid()
returns text as $$
declare
  new_mid text;
  mid_exists boolean;
begin
  loop
    -- U + 8자리 랜덤 숫자 생성
    new_mid := 'U' || lpad(floor(random() * 100000000)::text, 8, '0');

    -- 중복 체크
    select exists(select 1 from public.users where mid = new_mid) into mid_exists;

    -- 중복이 없으면 반환
    if not mid_exists then
      return new_mid;
    end if;
  end loop;
end;
$$ language plpgsql;

-- 6. 회원가입 시 자동으로 users 테이블에 레코드 생성
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.users (
    id,
    mid,
    nickname,
    phone,
    birth_date,
    profile_image_url
  )
  values (
    new.id,
    generate_mid(),
    coalesce(new.raw_user_meta_data->>'nickname', '사용자'),
    new.raw_user_meta_data->>'phone',
    (new.raw_user_meta_data->>'birth_date')::date,
    new.raw_user_meta_data->>'avatar_url'
  );
  return new;
end;
$$ language plpgsql security definer;

-- 7. Trigger 연결
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- 8. updated_at 자동 업데이트 Trigger (handle_updated_at 함수는 churches 테이블 생성 시 이미 만들어짐)
create trigger on_users_updated
  before update on public.users
  for each row execute procedure public.handle_updated_at();

-- 9. 테이블 확인
select * from public.users;
