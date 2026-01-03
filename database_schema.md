# WAC 데이터베이스 스키마 문서

## 📚 목차
1. [Users 테이블](#users-테이블)
2. [Churches 테이블](#churches-테이블)
3. [Posts 테이블](#posts-테이블)
4. [Polls 테이블](#polls-테이블)
5. [Poll Options 테이블](#poll_options-테이블)
6. [Poll Votes 테이블](#poll_votes-테이블)
7. [Comments 테이블](#comments-테이블)
8. [Likes 테이블](#likes-테이블)
9. [Draft Posts 테이블](#draft_posts-테이블)
10. [Notifications 테이블](#notifications-테이블)

---

## Users 테이블

### 설명
사용자 정보를 저장하는 테이블. Supabase Auth의 `auth.users`와 연동됩니다.

### 스키마

| 컬럼명 | 타입 | 제약조건 | 설명 |
|--------|------|----------|------|
| id | uuid | PK, FK → auth.users | 사용자 고유 ID |
| mid | text | UNIQUE, NOT NULL | 사용자 고유 아이디 (자동생성) |
| nickname | text | NOT NULL | 이름/닉네임 |
| phone | text | - | 전화번호 |
| birth_date | date | - | 생년월일 |
| region | text | - | 거주지(시) |
| sub_region | text | - | 거주지(구/동) |
| profile_image_url | text | - | 프로필 이미지 URL |
| church_id | uuid | FK → churches | 섬기는 교회 |
| membership_status | text | DEFAULT '새신자' | 소속 부서 (새신자/정회원) |
| position | text | - | 직분 (집사, 권사, 장로 등) |
| created_at | timestamptz | NOT NULL, DEFAULT now() | 생성일시 |
| updated_at | timestamptz | NOT NULL, DEFAULT now() | 수정일시 |

### 인덱스
- `users_mid_idx` on `mid`
- `users_nickname_idx` on `nickname`
- `users_church_id_idx` on `church_id`
- `users_region_idx` on `(region, sub_region)`

### RLS 정책
- `Users can view own data`: 본인 데이터 조회 가능
- `Users can view other users basic info`: 모든 사용자의 기본 정보 조회 가능
- `Users can update own data`: 본인 데이터 수정 가능

---

## Churches 테이블

### 설명
교회 정보를 저장하는 테이블

### 스키마

| 컬럼명 | 타입 | 제약조건 | 설명 |
|--------|------|----------|------|
| id | uuid | PK, DEFAULT gen_random_uuid() | 교회 고유 ID |
| name | text | NOT NULL | 교회명 |
| profile_image_url | text | - | 프로필 이미지 URL |
| denomination | text | - | 교단 |
| address | text | - | 교회 주소 |
| pastor_name | text | - | 담임목사 |
| description | text | - | 교회 정보/소개글 |
| status | text | DEFAULT '활성' | 상태 (활성/비활성/대기) |
| phone | text | - | 전화번호 |
| region | text | - | 지역(시/도) |
| sub_region | text | - | 지역(구/군) |
| website | text | - | 홈페이지 URL |
| created_at | timestamptz | NOT NULL, DEFAULT now() | 생성일시 |
| updated_at | timestamptz | NOT NULL, DEFAULT now() | 수정일시 |
| search_vector | tsvector | GENERATED | 검색 인덱스 (자동생성) |

### 인덱스
- `churches_name_idx` on `name`
- `churches_region_idx` on `(region, sub_region)`
- `churches_denomination_idx` on `denomination`
- `churches_status_idx` on `status`
- `churches_search_idx` on `search_vector` (GIN)

### RLS 정책
- `Anyone can view active churches`: 모든 사용자가 활성 교회 조회 가능
- `Authenticated users can view all churches`: 인증된 사용자는 모든 교회 조회 가능

---

## Posts 테이블

### 설명
사용자가 작성한 게시글을 저장하는 테이블

### 스키마

| 컬럼명 | 타입 | 제약조건 | 설명 |
|--------|------|----------|------|
| id | uuid | PK, DEFAULT gen_random_uuid() | 게시글 고유 ID |
| user_id | uuid | FK → users, NOT NULL | 작성자 ID |
| church_id | uuid | FK → churches | 교회 ID (선택) |
| category | text | NOT NULL | 카테고리 (우리교회/간증/고민상담/자유주제/성경말씀/이벤트) |
| title | text | NOT NULL | 제목 |
| content | text | NOT NULL | 내용 |
| region | text | - | 지역(시) - 지역별 필터용 |
| sub_region | text | - | 지역(구/군) |
| view_count | integer | DEFAULT 0 | 조회수 |
| created_at | timestamptz | NOT NULL, DEFAULT now() | 생성일시 |
| updated_at | timestamptz | NOT NULL, DEFAULT now() | 수정일시 |

---

## Polls 테이블

### 설명
설문조사 정보를 저장하는 테이블

### 스키마

| 컬럼명 | 타입 | 제약조건 | 설명 |
|--------|------|----------|------|
| id | uuid | PK, DEFAULT gen_random_uuid() | 설문 고유 ID |
| user_id | uuid | FK → users, NOT NULL | 작성자 ID |
| question | text | NOT NULL | 설문 제목/질문 |
| allow_multiple_answers | boolean | DEFAULT false | 복수응답 허용 여부 |
| created_at | timestamptz | NOT NULL, DEFAULT now() | 생성일시 |
| updated_at | timestamptz | NOT NULL, DEFAULT now() | 수정일시 |

---

## Poll_Options 테이블

### 설명
설문조사의 선택지를 저장하는 테이블

### 스키마

| 컬럼명 | 타입 | 제약조건 | 설명 |
|--------|------|----------|------|
| id | uuid | PK, DEFAULT gen_random_uuid() | 선택지 고유 ID |
| poll_id | uuid | FK → polls, NOT NULL | 설문 ID |
| option_text | text | NOT NULL | 선택지 텍스트 |
| order_index | integer | NOT NULL | 표시 순서 |
| vote_count | integer | DEFAULT 0 | 투표 수 |

---

## Poll_Votes 테이블

### 설명
설문조사 투표 기록을 저장하는 테이블

### 스키마

| 컬럼명 | 타입 | 제약조건 | 설명 |
|--------|------|----------|------|
| id | uuid | PK, DEFAULT gen_random_uuid() | 투표 기록 ID |
| poll_id | uuid | FK → polls, NOT NULL | 설문 ID |
| option_id | uuid | FK → poll_options, NOT NULL | 선택지 ID |
| user_id | uuid | FK → users, NOT NULL | 투표자 ID |
| created_at | timestamptz | NOT NULL, DEFAULT now() | 투표일시 |

### 제약조건
- UNIQUE(poll_id, user_id, option_id): 중복 투표 방지

---

## Comments 테이블

### 설명
게시글에 달린 댓글을 저장하는 테이블

### 스키마

| 컬럼명 | 타입 | 제약조건 | 설명 |
|--------|------|----------|------|
| id | uuid | PK, DEFAULT gen_random_uuid() | 댓글 고유 ID |
| post_id | uuid | FK → posts, NOT NULL | 게시글 ID |
| user_id | uuid | FK → users, NOT NULL | 작성자 ID |
| content | text | NOT NULL | 댓글 내용 |
| created_at | timestamptz | NOT NULL, DEFAULT now() | 생성일시 |
| updated_at | timestamptz | NOT NULL, DEFAULT now() | 수정일시 |

---

## Likes 테이블

### 설명
게시글 좋아요 정보를 저장하는 테이블

### 스키마

| 컬럼명 | 타입 | 제약조건 | 설명 |
|--------|------|----------|------|
| id | uuid | PK, DEFAULT gen_random_uuid() | 좋아요 고유 ID |
| post_id | uuid | FK → posts, NOT NULL | 게시글 ID |
| user_id | uuid | FK → users, NOT NULL | 사용자 ID |
| created_at | timestamptz | NOT NULL, DEFAULT now() | 생성일시 |

### 제약조건
- UNIQUE(post_id, user_id): 중복 좋아요 방지

---

## Draft_Posts 테이블

### 설명
임시저장된 게시글을 저장하는 테이블

### 스키마

| 컬럼명 | 타입 | 제약조건 | 설명 |
|--------|------|----------|------|
| id | uuid | PK, DEFAULT gen_random_uuid() | 임시저장 ID |
| user_id | uuid | FK → users, NOT NULL | 작성자 ID |
| type | text | NOT NULL | 타입 (게시글/설문) |
| title | text | - | 제목 |
| content | text | - | 내용 |
| category | text | - | 카테고리 |
| poll_data | jsonb | - | 설문 데이터 (JSON) |
| created_at | timestamptz | NOT NULL, DEFAULT now() | 생성일시 |
| updated_at | timestamptz | NOT NULL, DEFAULT now() | 수정일시 |

---

## Notifications 테이블

### 설명
사용자 알림을 저장하는 테이블

### 스키마

| 컬럼명 | 타입 | 제약조건 | 설명 |
|--------|------|----------|------|
| id | uuid | PK, DEFAULT gen_random_uuid() | 알림 ID |
| user_id | uuid | FK → users, NOT NULL | 수신자 ID |
| type | text | NOT NULL | 알림 타입 (댓글/좋아요/공지 등) |
| related_post_id | uuid | FK → posts | 관련 게시글 ID |
| message | text | NOT NULL | 알림 메시지 |
| is_read | boolean | DEFAULT false | 읽음 여부 |
| created_at | timestamptz | NOT NULL, DEFAULT now() | 생성일시 |

---

## ERD (Entity Relationship Diagram)

```
users (1) ──< (N) posts
users (1) ──< (N) polls
users (1) ──< (N) comments
users (1) ──< (N) likes
users (1) ──< (N) poll_votes
users (1) ──< (N) draft_posts
users (1) ──< (N) notifications
users (N) ──> (1) churches

churches (1) ──< (N) users
churches (1) ──< (N) posts

posts (1) ──< (N) comments
posts (1) ──< (N) likes
posts (1) ──< (N) notifications

polls (1) ──< (N) poll_options
polls (1) ──< (N) poll_votes

poll_options (1) ──< (N) poll_votes
```

---

## 주요 기능별 쿼리 예시

### 1. 사용자 프로필 조회
```sql
SELECT u.*, c.name as church_name
FROM users u
LEFT JOIN churches c ON u.church_id = c.id
WHERE u.id = 'user-uuid';
```

### 2. 게시글 목록 (좋아요, 댓글 수 포함)
```sql
SELECT
  p.*,
  u.nickname,
  u.profile_image_url,
  c.name as church_name,
  COUNT(DISTINCT l.id) as like_count,
  COUNT(DISTINCT cm.id) as comment_count
FROM posts p
JOIN users u ON p.user_id = u.id
LEFT JOIN churches c ON u.church_id = c.id
LEFT JOIN likes l ON p.id = l.post_id
LEFT JOIN comments cm ON p.id = cm.post_id
GROUP BY p.id, u.nickname, u.profile_image_url, c.name
ORDER BY p.created_at DESC;
```

### 3. 설문 결과 조회
```sql
SELECT
  po.option_text,
  po.vote_count,
  ROUND(po.vote_count::numeric / NULLIF(SUM(po.vote_count) OVER(), 0) * 100, 1) as percentage
FROM poll_options po
WHERE po.poll_id = 'poll-uuid'
ORDER BY po.order_index;
```

---

## 버전 정보
- 작성일: 2025-10-07
- 데이터베이스: PostgreSQL (Supabase)
- 버전: 1.0
