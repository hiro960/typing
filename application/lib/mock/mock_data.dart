import 'package:flutter/material.dart';

class LessonInfo {
  const LessonInfo({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.level,
    required this.progress,
    required this.durationMinutes,
    required this.xp,
    required this.description,
    required this.sampleWord,
    required this.sampleMeaning,
  });

  final String id;
  final String title;
  final String subtitle;
  final String level;
  final double progress;
  final int durationMinutes;
  final int xp;
  final String description;
  final String sampleWord;
  final String sampleMeaning;
}

class LessonOutline {
  const LessonOutline({
    required this.id,
    required this.level,
    required this.title,
    required this.summary,
  });

  final String id;
  final String level;
  final String title;
  final String summary;
}

class StatTileData {
  const StatTileData({
    required this.label,
    required this.value,
    required this.caption,
    required this.icon,
  });

  final String label;
  final String value;
  final String caption;
  final IconData icon;
}

class DiaryPost {
  const DiaryPost({
    required this.username,
    required this.handle,
    required this.timeAgo,
    required this.level,
    required this.content,
    required this.translationHint,
    required this.hashtags,
    required this.likes,
    required this.comments,
    required this.reposts,
    this.imageUrl,
  });

  final String username;
  final String handle;
  final String timeAgo;
  final String level;
  final String content;
  final String translationHint;
  final List<String> hashtags;
  final int likes;
  final int comments;
  final int reposts;
  final String? imageUrl;
}

class NotificationItem {
  const NotificationItem({
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    required this.icon,
    required this.color,
    this.isUnread = false,
  });

  final String title;
  final String subtitle;
  final String timeAgo;
  final IconData icon;
  final Color color;
  final bool isUnread;
}

const mockLessons = <LessonInfo>[
  LessonInfo(
    id: 'intro',
    title: 'レッスン1: 기본 자음',
    subtitle: '子音・母音の基礎',
    level: '初級',
    progress: 0.72,
    durationMinutes: 8,
    xp: 120,
    description: '最初の10文字を覚えて、指のフォームを整えましょう。',
    sampleWord: '안녕',
    sampleMeaning: 'こんにちは',
  ),
  LessonInfo(
    id: 'vowel-flow',
    title: 'レッスン5: 모음 플로우',
    subtitle: '母音のリズム練習',
    level: '初級',
    progress: 0.34,
    durationMinutes: 12,
    xp: 160,
    description: 'ㅑ, ㅕ, ㅛ など似た形の母音をセットで覚える。',
    sampleWord: '여행',
    sampleMeaning: '旅行',
  ),
  LessonInfo(
    id: 'daily-words',
    title: 'レッスン9: 생활 단어',
    subtitle: '頻出単語300語',
    level: '中級',
    progress: 0.12,
    durationMinutes: 15,
    xp: 250,
    description: '会話でよく使う単語をテンポよく入力します。',
    sampleWord: '약속',
    sampleMeaning: '約束',
  ),
  LessonInfo(
    id: 'idol-messages',
    title: 'レッスン14: 응원 메시지',
    subtitle: '推し活フレーズ',
    level: '上級',
    progress: 0.48,
    durationMinutes: 18,
    xp: 320,
    description: 'SNSで使える応援フレーズを長文で練習。',
    sampleWord: '최고예요',
    sampleMeaning: '最高です',
  ),
];

const statTiles = <StatTileData>[
  StatTileData(
    label: '正解率',
    value: '92%',
    caption: '先週 +4%',
    icon: Icons.verified_outlined,
  ),
  StatTileData(label: 'WPM', value: '48', caption: 'ベスト 52', icon: Icons.speed),
  StatTileData(
    label: '継続日数',
    value: '24日',
    caption: 'ストリーク継続中',
    icon: Icons.local_fire_department_outlined,
  ),
];

const beginnerLessonOutlines = <LessonOutline>[
  LessonOutline(
    id: 'beginner-1',
    level: '初級',
    title: 'レッスン1: ㅜ, ㅇ, ㅁ + 単語',
    summary: 'ㅜ, ㅇ, ㅁ + 単語（문, 안, 눈, 나무, 아마, 누나, 만, 바나나）',
  ),
  LessonOutline(
    id: 'beginner-2',
    level: '初級',
    title: 'レッスン2: ㅂ, ㅣ + 単語',
    summary: 'ㅂ, ㅣ + 単語（입, 밥, 비빔밥, 분, 비누, 방, 위, 반, 아이）',
  ),
  LessonOutline(
    id: 'beginner-3',
    level: '初級',
    title: 'レッスン3: ㄱ, ㅣ + 単語',
    summary: 'ㄱ, ㅣ + 単語（김밥, 이, 가위, 위, 귀, 입, 누구, 비누, 아기）',
  ),
  LessonOutline(
    id: 'beginner-4',
    level: '初級',
    title: 'レッスン4: ㄴ, ㄷ + 単語',
    summary: 'ㄴ, ㄷ + 単語（다, 도, 두, 나, 노, 누나, 다리, 도시, 두부, 나무）',
  ),
  LessonOutline(
    id: 'beginner-5',
    level: '初級',
    title: 'レッスン5: ㄹ, ㅅ + 単語',
    summary: 'ㄹ, ㅅ + 単語（사, 소, 수, 라, 로, 수도, 사다, 소리, 사람, 수박）',
  ),
  LessonOutline(
    id: 'beginner-6',
    level: '初級',
    title: 'レッスン6: ㅈ, ㅓ + 単語',
    summary: 'ㅈ, ㅓ + 単語（저, 조, 주, 자, 지도, 저기, 주소, 자리, 저녁, 조금）',
  ),
  LessonOutline(
    id: 'beginner-7',
    level: '初級',
    title: 'レッスン7: ㅎ, ㅗ + 単語',
    summary: 'ㅎ, ㅗ + 単語（하, 호, 히, 오, 하나, 호수, 오다, 하루, 호랑이, 오이）',
  ),
  LessonOutline(
    id: 'beginner-8',
    level: '初級',
    title: 'レッスン8: ㅋ, ㅌ, ㅍ + 単語',
    summary: 'ㅋ, ㅌ, ㅍ + 単語（카, 타, 파, 코, 토, 포도, 커피, 타다, 파다, 토끼）',
  ),
  LessonOutline(
    id: 'beginner-9',
    level: '初級',
    title: 'レッスン9: ㅊ + 単語',
    summary: 'ㅊ + 単語（차, 처, 초, 추, 치다, 차다, 처음, 초등학생, 추다, 치킨）',
  ),
  LessonOutline(
    id: 'beginner-10',
    level: '初級',
    title: 'レッスン10: ㅐ, ㅔ + 単語',
    summary: 'ㅐ, ㅔ + 単語（개, 게, 배, 베, 새, 세, 애기, 개미, 배추, 세수）',
  ),
  LessonOutline(
    id: 'beginner-11',
    level: '初級',
    title: 'レッスン11: ㅡ + 単語',
    summary: 'ㅡ + 単語（느, 드, 르, 스, 그, 크다, 슬프다, 그림, 스키, 쓰다）',
  ),
  LessonOutline(
    id: 'beginner-12',
    level: '初級',
    title: 'レッスン12: 濃音 ㄲ, ㄸ, ㅃ + 単語',
    summary: '濃音 ㄲ, ㄸ, ㅃ + 単語（까, 빠, 따, 꼬리, 뿌리, 딸기, 까치, 빠르다, 또）',
  ),
  LessonOutline(
    id: 'beginner-13',
    level: '初級',
    title: 'レッスン13: 濃音 ㅆ, ㅉ + 単語',
    summary: '濃音 ㅆ, ㅉ + 単語（싸, 짜, 쓰다, 씨, 짜다, 쌀, 찌다, 쏘다, 짜증）',
  ),
  LessonOutline(
    id: 'beginner-14',
    level: '初級',
    title: 'レッスン14: 複合母音 ㅑ, ㅕ, ㅛ, ㅠ + 単語',
    summary: '複合母音 ㅑ, ㅕ, ㅛ, ㅠ + 単語（야, 여, 요, 유, 야구, 여기, 요리, 유리, 약, 연필）',
  ),
  LessonOutline(
    id: 'beginner-15',
    level: '初級',
    title: 'レッスン15: 複合母音 ㅘ, ㅝ, ㅢ, ㅚ, ㅟ + 単語',
    summary: '複合母音 ㅘ, ㅝ, ㅢ, ㅚ, ㅟ + 単語（와, 왜, 워, 의, 외국, 왜냐하면, 귀, 취미, 웨딩）',
  ),
  LessonOutline(
    id: 'beginner-16',
    level: '初級',
    title: 'レッスン16: パッチム基礎',
    summary: 'パッチム基礎（終声）+ 単語（밥, 집, 책, 옷, 밖, 꽃, 산, 달, 물, 불）',
  ),
  LessonOutline(
    id: 'beginner-17',
    level: '初級',
    title: 'レッスン17: パッチム応用 + 単語',
    summary: 'パッチム応用 + 単語（말, 얼굴, 일, 발, 날씨, 잘, 밤, 공, 강, 맛）',
  ),
  LessonOutline(
    id: 'beginner-18',
    level: '初級',
    title: 'レッスン18: 二重パッチム ㄳ, ㄺ, ㄻ + 単語',
    summary: '二重パッチム ㄳ, ㄺ, ㄻ + 単語（값, 넓다, 삶, 읽다, 닭, 흙, 앉다, 옳다）',
  ),
  LessonOutline(
    id: 'beginner-19',
    level: '初級',
    title: 'レッスン19: 二重パッチム ㄼ, ㄽ, ㄾ, ㄿ, ㅀ, ㅄ + 単語',
    summary: '二重パッチム ㄼ, ㄽ, ㄾ, ㄿ, ㅀ, ㅄ + 単語（넓다, 밟다, 핥다, 읊다, 없다, 값다, 짧다, 많다）',
  ),
  LessonOutline(
    id: 'beginner-20',
    level: '初級',
    title: 'レッスン20: 総復習 - 簡単な文章',
    summary: '総復習 - 簡単な文章（안녕하세요, 감사합니다, 저는 학생입니다, 만나서 반갑습니다, 잘 부탁합니다）',
  ),
];

const intermediateLessonOutlines = <LessonOutline>[
  LessonOutline(
    id: 'intermediate-1',
    level: '中級',
    title: 'レッスン1: 数字①（基本数字）',
    summary: '基本的な数字（漢数詞）',
  ),
  LessonOutline(
    id: 'intermediate-2',
    level: '中級',
    title: 'レッスン2: 数字②（固有数詞・時間）',
    summary: '固有数詞と時間表現',
  ),
  LessonOutline(
    id: 'intermediate-3',
    level: '中級',
    title: 'レッスン3: 家族・人間関係①',
    summary: '家族の呼び方',
  ),
  LessonOutline(
    id: 'intermediate-4',
    level: '中級',
    title: 'レッスン4: 家族・人間関係②',
    summary: 'その他の人間関係',
  ),
  LessonOutline(
    id: 'intermediate-5',
    level: '中級',
    title: 'レッスン5: 食べ物①（主食・料理）',
    summary: '基本的な食べ物',
  ),
  LessonOutline(
    id: 'intermediate-6',
    level: '中級',
    title: 'レッスン6: 食べ物②（飲み物・その他）',
    summary: '飲み物と食事関連',
  ),
  LessonOutline(
    id: 'intermediate-7',
    level: '中級',
    title: 'レッスン7: 場所①（基本的な場所）',
    summary: '日常でよく行く場所',
  ),
  LessonOutline(
    id: 'intermediate-8',
    level: '中級',
    title: 'レッスン8: 場所②（施設・位置）',
    summary: 'その他の場所と位置表現',
  ),
  LessonOutline(
    id: 'intermediate-9',
    level: '中級',
    title: 'レッスン9: 日常動詞①（基本動作）',
    summary: 'よく使う基本動詞',
  ),
  LessonOutline(
    id: 'intermediate-10',
    level: '中級',
    title: 'レッスン10: 日常動詞②（生活動作）',
    summary: '日常生活の動詞',
  ),
  LessonOutline(
    id: 'intermediate-11',
    level: '中級',
    title: 'レッスン11: 日常動詞③（コミュニケーション）',
    summary: 'コミュニケーション関連動詞',
  ),
  LessonOutline(
    id: 'intermediate-12',
    level: '中級',
    title: 'レッスン12: 日常動詞④（感情・状態）',
    summary: '感情や状態を表す動詞',
  ),
  LessonOutline(
    id: 'intermediate-13',
    level: '中級',
    title: 'レッスン13: 形容詞①（性格・性質）',
    summary: '性格や性質を表す形容詞',
  ),
  LessonOutline(
    id: 'intermediate-14',
    level: '中級',
    title: 'レッスン14: 形容詞②（状態・様子）',
    summary: '状態を表す形容詞',
  ),
  LessonOutline(
    id: 'intermediate-15',
    level: '中級',
    title: 'レッスン15: 形容詞③（感情①）',
    summary: '感情を表す形容詞',
  ),
  LessonOutline(
    id: 'intermediate-16',
    level: '中級',
    title: 'レッスン16: 形容詞④（感覚・体調）',
    summary: '感覚や体調を表す形容詞',
  ),
  LessonOutline(
    id: 'intermediate-17',
    level: '中級',
    title: 'レッスン17: 時間・頻度表現',
    summary: '時間と頻度に関する言葉',
  ),
  LessonOutline(
    id: 'intermediate-18',
    level: '中級',
    title: 'レッスン18: 日常名詞（物・事）',
    summary: '日常でよく使う名詞',
  ),
  LessonOutline(
    id: 'intermediate-19',
    level: '中級',
    title: 'レッスン19: 接続詞・副詞・疑問詞',
    summary: '文を繋ぐ言葉や疑問詞',
  ),
  LessonOutline(
    id: 'intermediate-20',
    level: '中級',
    title: 'レッスン20: 総復習 - 日常会話フレーズ',
    summary: 'これまでの単語を使った実用フレーズ',
  ),
];

const advancedLessonOutlines = <LessonOutline>[
  LessonOutline(
    id: 'advanced-1',
    level: '上級',
    title: 'レッスン1: 日常会話文①（挨拶・自己紹介）',
    summary: '基本的な挨拶と自己紹介',
  ),
  LessonOutline(
    id: 'advanced-2',
    level: '上級',
    title: 'レッスン2: 日常会話文②（日常生活）',
    summary: '日常生活の会話',
  ),
  LessonOutline(
    id: 'advanced-3',
    level: '上級',
    title: 'レッスン3: 短いエッセイ①（私の一日）',
    summary: 'エッセイ形式の文章',
  ),
  LessonOutline(
    id: 'advanced-4',
    level: '上級',
    title: 'レッスン4: 短いエッセイ②（私の趣味）',
    summary: '趣味について述べる',
  ),
  LessonOutline(
    id: 'advanced-5',
    level: '上級',
    title: 'レッスン5: ニュース記事①（天気・季節）',
    summary: 'ニュース風の文章',
  ),
  LessonOutline(
    id: 'advanced-6',
    level: '上級',
    title: 'レッスン6: ニュース記事②（イベント・お知らせ）',
    summary: 'イベント告知',
  ),
  LessonOutline(
    id: 'advanced-7',
    level: '上級',
    title: 'レッスン7: 会話文（レストランでの注文）',
    summary: '実用的な会話',
  ),
  LessonOutline(
    id: 'advanced-8',
    level: '上級',
    title: 'レッスン8: SNSフレーズ①（応援メッセージ）',
    summary: 'SNSでよく使う応援メッセージ',
  ),
  LessonOutline(
    id: 'advanced-9',
    level: '上級',
    title: 'レッスン9: SNSフレーズ②（感想・コメント）',
    summary: '感想を述べるフレーズ',
  ),
  LessonOutline(
    id: 'advanced-10',
    level: '上級',
    title: 'レッスン10: ファンレター①（基本形式）',
    summary: 'ファンレター定型文',
  ),
  LessonOutline(
    id: 'advanced-11',
    level: '上級',
    title: 'レッスン11: ファンレター②（感謝の気持ち）',
    summary: '感謝を伝える手紙',
  ),
  LessonOutline(
    id: 'advanced-12',
    level: '上級',
    title: 'レッスン12: ファンミーティング感想',
    summary: 'イベント後の感想',
  ),
  LessonOutline(
    id: 'advanced-13',
    level: '上級',
    title: 'レッスン13: 応援メッセージ（長文）',
    summary: '心のこもった応援文',
  ),
  LessonOutline(
    id: 'advanced-14',
    level: '上級',
    title: 'レッスン14: 投票・支援呼びかけ',
    summary: 'ファン活動のための呼びかけ',
  ),
  LessonOutline(
    id: 'advanced-15',
    level: '上級',
    title: 'レッスン15: ことわざ①（努力・成功）',
    summary: '努力と成功に関することわざ',
  ),
  LessonOutline(
    id: 'advanced-16',
    level: '上級',
    title: 'レッスン16: ことわざ②（人間関係）',
    summary: '人間関係に関することわざ',
  ),
  LessonOutline(
    id: 'advanced-17',
    level: '上級',
    title: 'レッスン17: ことわざ③（人生の教訓）',
    summary: '人生の教訓を含むことわざ',
  ),
  LessonOutline(
    id: 'advanced-18',
    level: '上級',
    title: 'レッスン18: 慣用句①（感情表現）',
    summary: '感情を表す慣用句',
  ),
  LessonOutline(
    id: 'advanced-19',
    level: '上級',
    title: 'レッスン19: 慣用句②（日常表現）',
    summary: '日常でよく使う慣用句',
  ),
  LessonOutline(
    id: 'advanced-20',
    level: '上級',
    title: 'レッスン20: 総復習 - 実践文章',
    summary: 'これまでの総まとめ',
  ),
];

const diaryPosts = <DiaryPost>[
  DiaryPost(
    username: 'Hana',
    handle: '@hana_typing',
    timeAgo: '2時間前',
    level: '중급자',
    content: '오늘은 한국 드라마를 봤어요. 감정 표현이 너무 자연스러웠어요!',
    translationHint: '今日は韓国ドラマを見て、感情表現が自然で感動。',
    hashtags: ['#한국어공부', '#드라마', '#일상'],
    likes: 24,
    comments: 5,
    reposts: 3,
    imageUrl: null,
  ),
  DiaryPost(
    username: 'Yuto',
    handle: '@yuto_kr',
    timeAgo: '5時間前',
    level: '초급자',
    content: '카페에서 혼자 공부했어요. 라떼가 맛있어서 집중 잘 됐어요 ☕️',
    translationHint: 'カフェで勉強。おいしいラテで集中できた！',
    hashtags: ['#카공족', '#韓国語', '#studylog'],
    likes: 18,
    comments: 2,
    reposts: 1,
    imageUrl:
        'https://images.unsplash.com/photo-1507133750040-4a8f57021571?auto=format&fit=crop&w=600&q=80',
  ),
  DiaryPost(
    username: 'Mina',
    handle: '@mina_wpm',
    timeAgo: '1日前',
    level: '상급자',
    content: '새 레슨에서 "완벽" 배지를 받았어요! 타이핑이 점점 재밌어져요.',
    translationHint: '新しいレッスンで「完璧」バッジ獲得！',
    hashtags: ['#완벽', '#타이핑', '#성장'],
    likes: 56,
    comments: 9,
    reposts: 4,
    imageUrl: null,
  ),
];

const notificationItems = <NotificationItem>[
  NotificationItem(
    title: '완벽! を獲得しました',
    subtitle: 'レッスン1でミス0。ボーナス+50XP',
    timeAgo: '5分前',
    icon: Icons.emoji_events_outlined,
    color: Color(0xFF7ED321),
    isUnread: true,
  ),
  NotificationItem(
    title: '@hana_typing さんがあなたをフォロー',
    subtitle: 'プロフィールをのぞいてみましょう',
    timeAgo: '1時間前',
    icon: Icons.person_add_alt_1_outlined,
    color: Color(0xFF4A90E2),
  ),
  NotificationItem(
    title: 'コメントが届きました',
    subtitle: '「좋은 팁 고마워요!」',
    timeAgo: '3時間前',
    icon: Icons.chat_bubble_outline,
    color: Color(0xFFF5A623),
  ),
  NotificationItem(
    title: '日記が注目されています',
    subtitle: 'いいね 120件 / コメント 12件',
    timeAgo: '昨日',
    icon: Icons.favorite_outline,
    color: Color(0xFFFF5A8D),
  ),
];

const timelineFilters = ['おすすめ', 'フォロー中'];

const trendingTags = ['#한국어공부', '#타이핑', '#드라마', '#推し活', '#오늘의한문장'];

const streakDays = ['月', '火', '水', '木', '金', '土', '日'];
