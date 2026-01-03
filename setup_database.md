# WAC 데이터베이스 설정 가이드

## 📋 목차
1. [Supabase 프로젝트 설정](#1-supabase-프로젝트-설정)
2. [Flutter 프로젝트에 Supabase 패키지 추가](#2-flutter-프로젝트에-supabase-패키지-추가)
3. [Supabase 초기화 설정](#3-supabase-초기화-설정)
4. [Churches 테이블 생성](#4-churches-테이블-생성)
5. [Users 테이블 생성](#5-users-테이블-생성)
6. [테스트 데이터 입력](#6-테스트-데이터-입력)
7. [Flutter에서 사용하기](#7-flutter에서-사용하기)

---

## 1. Supabase 프로젝트 설정

### 1-1. Supabase 계정 생성 및 프로젝트 생성
1. https://supabase.com 접속
2. 계정 생성 또는 로그인
3. "New Project" 클릭
4. 프로젝트 정보 입력:
   - **Name**: WAC (또는 원하는 이름)
   - **Database Password**: 안전한 비밀번호 설정 (꼭 기록해두세요!)
   - **Region**: Northeast Asia (Seoul) 선택
   - **Pricing Plan**: Free 선택
5. "Create new project" 클릭 (약 2분 소요)

### 1-2. API 정보 확인
1. 프로젝트 대시보드에서 **Settings** (톱니바퀴 아이콘) 클릭
2. **API** 메뉴 클릭
3. 다음 정보 복사해서 저장:
   - **Project URL**: `https://xxxxxxxxxxxxx.supabase.co`
   - **anon public API Key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6...`

---

## 2. Flutter 프로젝트에 Supabase 패키지 추가

터미널에서 프로젝트 루트로 이동 후 실행:

```bash
cd /Users/kimjunghwan/Workspace/test/WAC/wac
flutter pub add supabase_flutter
flutter pub get
```

---

## 3. Supabase 초기화 설정

### 3-1. main.dart 수정

`lib/main.dart` 파일을 다음과 같이 수정:

```dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/church_page.dart';
import 'pages/bible_page.dart';
import 'pages/home_page.dart';
import 'pages/faith_page.dart';
import 'pages/profile_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',  // 1-2에서 복사한 URL
    anonKey: 'YOUR_SUPABASE_ANON_KEY',  // 1-2에서 복사한 Key
  );

  runApp(const MyApp());
}

// 전역에서 사용할 Supabase 클라이언트
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WAC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainScreen(),
    );
  }
}

// ... 나머지 코드는 동일
```

### 3-2. 환경변수로 관리 (권장 - 보안)

더 안전한 방법으로 환경변수 사용:

```bash
# 패키지 설치
flutter pub add flutter_dotenv
```

프로젝트 루트에 `.env` 파일 생성:

```env
SUPABASE_URL=https://xxxxxxxxxxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6...
```

`.gitignore`에 추가:

```gitignore
.env
```

`pubspec.yaml`에 추가:

```yaml
flutter:
  assets:
    - .env
```

`main.dart` 수정:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MyApp());
}
```

---

## 4. Churches 테이블 생성

Supabase Dashboard → **SQL Editor** → **New Query**에서 실행:

```sql
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

-- 7. 검색 기능을 위한 Full Text Search 설정
alter table public.churches
  add column search_vector tsvector
  generated always as (
    setweight(to_tsvector('simple', coalesce(name, '')), 'A') ||
    setweight(to_tsvector('simple', coalesce(address, '')), 'B') ||
    setweight(to_tsvector('simple', coalesce(denomination, '')), 'C')
  ) stored;

create index churches_search_idx on public.churches using gin(search_vector);
```

**"Run"** 버튼 클릭하여 실행

---

## 5. Users 테이블 생성

같은 SQL Editor에서 새로운 쿼리로 실행:

```sql
-- 1. users 테이블 생성
create table public.users (
  id uuid references auth.users on delete cascade primary key,
  mid text unique not null,
  nickname text not null,
  phone text,
  birth_date date,
  region text,
  sub_region text,
  profile_image_url text,
  church_id uuid references public.churches(id) on delete set null,
  membership_status text default '새신자' check (membership_status in ('새신자', '정회원')),
  position text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 2. 인덱스 생성
create index users_mid_idx on public.users(mid);
create index users_nickname_idx on public.users(nickname);
create index users_church_id_idx on public.users(church_id);
create index users_region_idx on public.users(region, sub_region);

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

-- 6. 회원가입 시 자동으로 users 테��블에 레코드 생성
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

-- 8. updated_at 자동 업데이트 Trigger
create trigger on_users_updated
  before update on public.users
  for each row execute procedure public.handle_updated_at();
```

**"Run"** 버튼 클릭하여 실행

---

## 6. 테스트 데이터 입력

### 6-1. 교회 데이터 입력

```sql
insert into public.churches (name, denomination, address, pastor_name, description, status, phone, region, sub_region)
values
  ('분당우리교회', '대한예수교장로회(합동)', '경기도 성남시 분당구 미애동 378', '김성수', '은혜가 넘치는 교회입니다', '활성', '031-1234-5678', '경기도', '성남시'),
  ('서현교회', '대한예수교장로회(합동)', '서울특별시 마포구 잔다리로7길 31', '이철수', '청년들이 많은 교회', '활성', '02-1234-5678', '서울시', '마포구'),
  ('행복교회', '대한예수교장로회(합동)', '경기도 성남시 분당구 미애동 378', '박영희', '가족같은 따뜻한 교회', '활성', '031-2234-5678', '경기도', '성남시'),
  ('마음사랑교회', '대한예수교장로회(합동)', '서울특별시 강남구 논현로 123', '최민수', '말씀 중심의 교회', '활성', '02-3234-5678', '서울시', '강남구'),
  ('소망교회', '대한예수교장로회(합동)', '경기도 성남시 중원구 상대원동 123', '정대호', '소망이 있는 교회', '활성', '031-3234-5678', '경기도', '성남시'),
  ('평안교회', '대한예수교장로회(통합)', '서울특별시 서초구 서초동 456', '강민지', '평안함이 있는 교회', '활성', '02-4234-5678', '서울시', '서초구'),
  ('빛과소금교회', '기독교대한감리회', '인천광역시 부평구 부평동 789', '황준호', '세상의 빛과 소금이 되는 교회', '활성', '032-1234-5678', '인천시', '부평구'),
  ('샘물교회', '대한예수교장로회(합동)', '서울특별시 서초구 반포동 321', '윤서연', '생명의 샘물이 흐르는 교회', '활성', '02-5234-5678', '서울시', '서초구');
```

### 6-2. 테이블 확인

```sql
-- churches 테이블 확인
select * from public.churches;

-- users 테이블 확인 (아직 비어있음)
select * from public.users;
```

---

## 7. Flutter에서 사용하기

### 7-1. 회원가입

```dart
try {
  final response = await supabase.auth.signUp(
    email: 'sunny@example.com',
    password: 'password123',
    data: {
      'nickname': '써니',
      'phone': '010-1234-5678',
      'birth_date': '1995-03-15',
    },
  );

  if (response.user != null) {
    print('회원가입 성공!');
    print('User ID: ${response.user!.id}');
  }
} catch (e) {
  print('회원가입 실패: $e');
}
```

### 7-2. 로그인

```dart
try {
  final response = await supabase.auth.signInWithPassword(
    email: 'sunny@example.com',
    password: 'password123',
  );

  if (response.user != null) {
    print('로그인 성공!');
  }
} catch (e) {
  print('로그인 실패: $e');
}
```

### 7-3. 현재 사용자 정보 가져오기

```dart
final user = supabase.auth.currentUser;

if (user != null) {
  // users 테이블에서 프로필 정보 가져오기
  final userData = await supabase
    .from('users')
    .select('*, churches(*)')  // 교회 정보도 함께 가져오기
    .eq('id', user.id)
    .single();

  print('닉네임: ${userData['nickname']}');
  print('MID: ${userData['mid']}');

  if (userData['churches'] != null) {
    print('교회: ${userData['churches']['name']}');
  }
}
```

### 7-4. 프로필 업데이트

```dart
try {
  await supabase
    .from('users')
    .update({
      'nickname': '새로운닉네임',
      'region': '서울시',
      'sub_region': '강남구',
    })
    .eq('id', supabase.auth.currentUser!.id);

  print('프로필 업데이트 성공!');
} catch (e) {
  print('업데이트 실패: $e');
}
```

### 7-5. 교회 목록 조회

```dart
// 모든 활성 교회 조회
final churches = await supabase
  .from('churches')
  .select()
  .eq('status', '활성')
  .order('name');

for (var church in churches) {
  print('${church['name']} - ${church['address']}');
}

// 지역별 교회 검색
final seoulChurches = await supabase
  .from('churches')
  .select()
  .eq('region', '서울시')
  .eq('status', '활성');
```

### 7-6. 로그아웃

```dart
await supabase.auth.signOut();
print('로그아웃 완료');
```

---

## 🎯 체크리스트

설정이 완료되면 다음 사항을 확인하세요:

- [ ] Supabase 프로젝트 생성 완료
- [ ] API 키 복사 및 저장 완료
- [ ] Flutter 프로젝트에 supabase_flutter 패키지 추가 완료
- [ ] main.dart에 Supabase 초기화 코드 추가 완료
- [ ] Churches 테이블 생성 완료
- [ ] Users 테이블 생성 완료
- [ ] 테스트 데이터 입력 완료
- [ ] Flutter에서 회원가입/로그인 테스트 완료

---

## ⚠️ 주의사항

1. **API 키 보안**: `.env` 파일은 절대 Git에 커밋하지 마세요!
2. **Database Password**: Supabase 프로젝트 생성 시 설정한 비밀번호를 안전하게 보관하세요.
3. **RLS 정책**: 프로덕션 환경에서는 더 세밀한 RLS 정책 설정이 필요합니다.
4. **이메일 인증**: Supabase는 기본적으로 이메일 인증을 요구합니다. 테스트 시에는 Dashboard → Authentication → Settings에서 비활성화할 수 있습니다.

---

## 🔗 유용한 링크

- [Supabase 공식 문서](https://supabase.com/docs)
- [Supabase Flutter 패키지](https://pub.dev/packages/supabase_flutter)
- [Supabase Auth 가이드](https://supabase.com/docs/guides/auth)
- [PostgreSQL 문서](https://www.postgresql.org/docs/)

---

## 다음 단계

1. 로그인/회원가입 UI 페이지 구현
2. 프로필 페이지 구현
3. 교회 검색 기능 구현
4. Posts 테이블 생성 및 게시글 기능 구현
5. 댓글, 좋아요 기능 구현

---

작성일: 2025-10-07
버전: 1.0
