# 文法辞典JSONファイル作成指示書

> この指示書はClaude（AI）が文法辞典のJSONファイルを効率的に作成するために最適化されています。

---

## 実行前の確認事項

```
出力先: application/assets/grammar/
参照仕様: docs/21_文法辞典機能の詳細.md
```

---

## カテゴリ別文法項目一覧

### 1. particle（助詞）- 25項目

| ID | title | subtitle | level | tags |
|----|-------|----------|-------|------|
| grm_particle_001 | 이/가 | 主格助詞（〜が） | beginner | 主格, 基本 |
| grm_particle_002 | 은/는 | 主題助詞（〜は） | beginner | 主題, 基本 |
| grm_particle_003 | 을/를 | 目的格助詞（〜を） | beginner | 目的格, 基本 |
| grm_particle_004 | 에 | 場所・時間助詞（〜に） | beginner | 場所, 時間 |
| grm_particle_005 | 에서 | 場所助詞（〜で） | beginner | 場所, 動作 |
| grm_particle_006 | 의 | 所有格助詞（〜の） | beginner | 所有格 |
| grm_particle_007 | 와/과 | 並列助詞（〜と） | beginner | 並列, フォーマル |
| grm_particle_008 | 하고 | 並列助詞（〜と） | beginner | 並列, カジュアル |
| grm_particle_009 | (이)랑 | 並列助詞（〜と） | beginner | 並列, 口語 |
| grm_particle_010 | 도 | 添加助詞（〜も） | beginner | 添加 |
| grm_particle_011 | 만 | 限定助詞（〜だけ） | beginner | 限定 |
| grm_particle_012 | 부터 | 起点助詞（〜から） | beginner | 起点, 時間 |
| grm_particle_013 | 까지 | 到達点助詞（〜まで） | beginner | 到達点 |
| grm_particle_014 | 에게/한테 | 与格助詞（〜に） | beginner | 与格, 人 |
| grm_particle_015 | 에게서/한테서 | 奪格助詞（〜から） | intermediate | 奪格, 人 |
| grm_particle_016 | (으)로 | 方向・手段助詞（〜で/へ） | intermediate | 方向, 手段 |
| grm_particle_017 | 보다 | 比較助詞（〜より） | intermediate | 比較 |
| grm_particle_018 | 처럼/같이 | 比況助詞（〜のように） | intermediate | 比況 |
| grm_particle_019 | 마다 | 毎〜助詞（〜ごとに） | intermediate | 頻度 |
| grm_particle_020 | 밖에 | 限定助詞（〜しか） | intermediate | 限定, 否定 |
| grm_particle_021 | (이)나 | 選択助詞（〜か/〜でも） | intermediate | 選択 |
| grm_particle_022 | 께/께서 | 尊敬与格・主格助詞 | intermediate | 敬語 |
| grm_particle_023 | (이)야말로 | 強調助詞（〜こそ） | advanced | 強調 |
| grm_particle_024 | 조차 | 極端助詞（〜さえ） | advanced | 極端 |
| grm_particle_025 | 커녕 | 否定強調助詞（〜どころか） | advanced | 否定, 強調 |

---

### 2. ending（語尾）- 35項目

| ID | title | subtitle | level | tags |
|----|-------|----------|-------|------|
| grm_ending_001 | -아/어요 | 丁寧形語尾（〜です/ます） | beginner | 丁寧, 基本 |
| grm_ending_002 | -습니다/ㅂ니다 | 格式体語尾（〜です/ます） | beginner | フォーマル, 基本 |
| grm_ending_003 | -아/어 | パンマル語尾（〜だ/する） | beginner | カジュアル |
| grm_ending_004 | -(으)세요 | 尊敬命令・勧誘語尾 | beginner | 敬語, 命令 |
| grm_ending_005 | -지 마세요 | 禁止語尾（〜しないでください） | beginner | 禁止 |
| grm_ending_006 | -(으)ㄹ게요 | 意志語尾（〜しますね） | beginner | 意志, 約束 |
| grm_ending_007 | -(으)ㄹ까요? | 提案・推量語尾（〜しましょうか） | beginner | 提案, 疑問 |
| grm_ending_008 | -고 싶다 | 願望語尾（〜したい） | beginner | 願望 |
| grm_ending_009 | -(으)ㄹ 수 있다/없다 | 可能・不可能語尾 | beginner | 可能 |
| grm_ending_010 | -아/어야 하다 | 義務語尾（〜しなければならない） | beginner | 義務 |
| grm_ending_011 | -(으)면 되다 | 許容語尾（〜すればいい） | intermediate | 許容 |
| grm_ending_012 | -지 않다 | 否定語尾（〜しない） | beginner | 否定 |
| grm_ending_013 | -못하다 | 不可能語尾（〜できない） | beginner | 不可能 |
| grm_ending_014 | -(으)ㄴ/는 것 같다 | 推測語尾（〜ようだ） | intermediate | 推測 |
| grm_ending_015 | -나 보다 | 推測語尾（〜みたいだ） | intermediate | 推測, 観察 |
| grm_ending_016 | -(으)ㄹ 것이다 | 未来推量語尾（〜だろう） | intermediate | 未来, 推量 |
| grm_ending_017 | -게 되다 | 変化語尾（〜ようになる） | intermediate | 変化 |
| grm_ending_018 | -아/어 보다 | 試行語尾（〜してみる） | intermediate | 試行 |
| grm_ending_019 | -아/어 주다 | 授受語尾（〜してあげる/くれる） | intermediate | 授受 |
| grm_ending_020 | -아/어 있다 | 状態継続語尾（〜している） | intermediate | 状態 |
| grm_ending_021 | -고 있다 | 進行語尾（〜している） | beginner | 進行 |
| grm_ending_022 | -(으)ㄴ 적이 있다/없다 | 経験語尾（〜したことがある） | intermediate | 経験 |
| grm_ending_023 | -(으)려고 하다 | 意図語尾（〜しようとする） | intermediate | 意図 |
| grm_ending_024 | -기로 하다 | 決定語尾（〜することにする） | intermediate | 決定 |
| grm_ending_025 | -(으)ㄹ 뻔하다 | 危機一髪語尾（〜するところだった） | advanced | 危機 |
| grm_ending_026 | -던 | 回想連体形語尾 | advanced | 回想, 連体形 |
| grm_ending_027 | -(으)ㄹ수록 | 比例語尾（〜すればするほど） | advanced | 比例 |
| grm_ending_028 | -는 바람에 | 原因語尾（〜したせいで） | advanced | 原因, 否定的 |
| grm_ending_029 | -더라고요 | 回想報告語尾（〜でしたよ） | advanced | 回想, 報告 |
| grm_ending_030 | -(으)ㄹ 텐데 | 推量・心配語尾 | advanced | 推量, 心配 |
| grm_ending_031 | -네요 | 感嘆・発見語尾（〜ですね） | beginner | 感嘆, 発見 |
| grm_ending_032 | -군요/구나 | 感嘆語尾（〜だなあ） | intermediate | 感嘆, 発見 |
| grm_ending_033 | -거든요 | 理由説明語尾（〜なんですよ） | intermediate | 理由, 説明 |
| grm_ending_034 | -잖아요 | 確認語尾（〜じゃないですか） | intermediate | 確認, 会話 |
| grm_ending_035 | -(으)ㄹ래요 | 意志・勧誘語尾（〜します/しますか） | beginner | 意志, 勧誘 |

---

### 3. connective（接続表現）- 22項目

| ID | title | subtitle | level | tags |
|----|-------|----------|-------|------|
| grm_connective_001 | -고 | 並列接続（〜して/〜で） | beginner | 並列 |
| grm_connective_002 | -아/어서 | 理由・順序接続（〜して/〜ので） | beginner | 理由, 順序 |
| grm_connective_003 | -(으)니까 | 理由接続（〜から/〜ので） | beginner | 理由 |
| grm_connective_004 | -(으)면 | 条件接続（〜すれば/〜なら） | beginner | 条件 |
| grm_connective_005 | -지만 | 逆接（〜けれど） | beginner | 逆接 |
| grm_connective_006 | -(으)ㄴ/는데 | 背景説明接続（〜が/〜けど） | intermediate | 背景, 対比 |
| grm_connective_007 | -거나 | 選択接続（〜か） | intermediate | 選択 |
| grm_connective_008 | -(으)면서 | 同時進行接続（〜しながら） | intermediate | 同時 |
| grm_connective_009 | -다가 | 中断・転換接続（〜していて） | intermediate | 中断, 転換 |
| grm_connective_010 | -(으)려면 | 目的条件接続（〜するには） | intermediate | 目的, 条件 |
| grm_connective_011 | -기 때문에 | 理由接続（〜ため） | intermediate | 理由, フォーマル |
| grm_connective_012 | -(으)ㄴ/는 대신에 | 代替接続（〜代わりに） | intermediate | 代替 |
| grm_connective_013 | -아/어도 | 譲歩接続（〜しても） | intermediate | 譲歩 |
| grm_connective_014 | -(으)ㄹ 테니까 | 意志・推量理由（〜するから） | advanced | 意志, 理由 |
| grm_connective_015 | -더니 | 回想・結果接続（〜したら） | advanced | 回想, 結果 |
| grm_connective_016 | -(으)ㄴ/는 반면에 | 対比接続（〜一方で） | advanced | 対比 |
| grm_connective_017 | -느라고 | 理由接続（〜するのに忙しくて） | advanced | 理由, 否定的結果 |
| grm_connective_018 | -(으)ㄹ지라도 | 強い譲歩（〜としても） | advanced | 譲歩, 強調 |
| grm_connective_019 | -기는커녕 | 否定強調接続（〜どころか） | advanced | 否定, 強調 |
| grm_connective_020 | -(으)ㄴ/는 이상 | 前提接続（〜以上は） | advanced | 前提 |
| grm_connective_021 | -(으)ㄹ 때 | 時間接続（〜する時） | beginner | 時間 |
| grm_connective_022 | -자마자 | 即時接続（〜するやいなや） | intermediate | 即時, 時間 |

---

### 4. honorific（敬語表現）- 15項目

| ID | title | subtitle | level | tags |
|----|-------|----------|-------|------|
| grm_honorific_001 | -(으)시- | 尊敬接尾辞 | beginner | 尊敬, 基本 |
| grm_honorific_002 | 계시다 | 있다の尊敬語（いらっしゃる） | beginner | 尊敬, 存在 |
| grm_honorific_003 | 드시다 | 먹다の尊敬語（召し上がる） | beginner | 尊敬, 飲食 |
| grm_honorific_004 | 주무시다 | 자다の尊敬語（お休みになる） | intermediate | 尊敬, 睡眠 |
| grm_honorific_005 | 돌아가시다 | 죽다の尊敬語（お亡くなりになる） | intermediate | 尊敬, 婉曲 |
| grm_honorific_006 | 말씀하시다 | 말하다の尊敬語（おっしゃる） | intermediate | 尊敬, 発言 |
| grm_honorific_007 | 드리다 | 주다の謙譲語（差し上げる） | beginner | 謙譲 |
| grm_honorific_008 | 여쭙다/여쭤보다 | 묻다の謙譲語（お伺いする） | intermediate | 謙譲, 質問 |
| grm_honorific_009 | 뵙다 | 보다の謙譲語（お目にかかる） | intermediate | 謙譲, 面会 |
| grm_honorific_010 | 모시다 | 데리다の謙譲語（お連れする） | intermediate | 謙譲, 同行 |
| grm_honorific_011 | -아/어 드리다 | 謙譲補助動詞（〜して差し上げる） | intermediate | 謙譲, 補助 |
| grm_honorific_012 | 저/제 | 나の謙譲語（私） | beginner | 謙譲, 人称 |
| grm_honorific_013 | 저희 | 우리の謙譲語（私ども） | beginner | 謙譲, 複数 |
| grm_honorific_014 | -(으)십시오 | 格式体命令（〜してください） | advanced | 敬語, 命令 |
| grm_honorific_015 | -나이다/-사옵나이다 | 古語敬語表現 | advanced | 古語, 格式 |

---

### 5. tense（時制・相）- 12項目

| ID | title | subtitle | level | tags |
|----|-------|----------|-------|------|
| grm_tense_001 | -ㄴ/는다 | 現在時制（基本形） | beginner | 現在 |
| grm_tense_002 | -았/었- | 過去時制 | beginner | 過去 |
| grm_tense_003 | -(으)ㄹ 것이다 | 未来時制 | beginner | 未来 |
| grm_tense_004 | -겠- | 意志・推量時制 | intermediate | 意志, 推量 |
| grm_tense_005 | -고 있다 | 進行相（〜している） | beginner | 進行 |
| grm_tense_006 | -아/어 있다 | 結果状態相（〜している） | intermediate | 状態 |
| grm_tense_007 | -았/었었- | 大過去（〜していた） | intermediate | 大過去 |
| grm_tense_008 | -(으)ㄴ | 過去連体形（〜した〜） | beginner | 過去, 連体形 |
| grm_tense_009 | -는 | 現在連体形（〜する〜） | beginner | 現在, 連体形 |
| grm_tense_010 | -(으)ㄹ | 未来連体形（〜する〜） | beginner | 未来, 連体形 |
| grm_tense_011 | -던 | 回想連体形（〜していた〜） | advanced | 回想, 連体形 |
| grm_tense_012 | -았/었던 | 過去回想連体形 | advanced | 過去, 回想 |

---

### 6. expression（慣用表現）- 25項目

| ID | title | subtitle | level | tags |
|----|-------|----------|-------|------|
| grm_expression_001 | -기 쉽다/어렵다 | 難易表現（〜しやすい/にくい） | intermediate | 難易 |
| grm_expression_002 | -(으)ㄹ 만하다 | 価値表現（〜する価値がある） | intermediate | 価値 |
| grm_expression_003 | -는 편이다 | 傾向表現（〜する方だ） | intermediate | 傾向 |
| grm_expression_004 | -(으)ㄹ 정도로 | 程度表現（〜するほど） | intermediate | 程度 |
| grm_expression_005 | -다 보면 | 継続結果表現（〜していると） | intermediate | 継続, 結果 |
| grm_expression_006 | -기(가) 무섭게 | 即時表現（〜するやいなや） | advanced | 即時 |
| grm_expression_007 | -(으)ㄴ/는 셈이다 | みなし表現（〜したようなものだ） | advanced | みなし |
| grm_expression_008 | -(으)ㄹ 리가 없다 | 否定推量（〜するはずがない） | intermediate | 否定, 推量 |
| grm_expression_009 | -는 김에 | 機会表現（〜するついでに） | intermediate | 機会 |
| grm_expression_010 | -(으)ㄹ 겸 | 兼ねる表現（〜を兼ねて） | intermediate | 兼用 |
| grm_expression_011 | -는 척하다 | ふり表現（〜するふりをする） | intermediate | ふり |
| grm_expression_012 | -(으)ㄴ/는 대로 | 即時・方法表現（〜通りに） | intermediate | 方法, 即時 |
| grm_expression_013 | -아/어 버리다 | 完了強調（〜してしまう） | intermediate | 完了, 強調 |
| grm_expression_014 | -아/어 놓다/두다 | 準備・保持表現（〜しておく） | intermediate | 準備 |
| grm_expression_015 | -고 말다 | 結局表現（〜してしまう） | advanced | 結局 |
| grm_expression_016 | -(으)ㄹ 뿐만 아니라 | 追加表現（〜だけでなく） | advanced | 追加 |
| grm_expression_017 | -는 한 | 限定表現（〜する限り） | advanced | 限定 |
| grm_expression_018 | -(으)ㄴ/는 탓에 | 非難理由（〜のせいで） | advanced | 理由, 非難 |
| grm_expression_019 | -(으)ㄴ/는 덕분에 | 感謝理由（〜おかげで） | intermediate | 理由, 感謝 |
| grm_expression_020 | -는 수밖에 없다 | やむを得ない表現 | advanced | 必然 |
| grm_expression_021 | -(으)ㄹ 지경이다 | 極限表現（〜しそうだ） | advanced | 極限 |
| grm_expression_022 | -기 마련이다 | 必然表現（〜するものだ） | advanced | 必然 |
| grm_expression_023 | -(으)ㄹ락 말락 하다 | 曖昧表現（〜するかしないか） | advanced | 曖昧 |
| grm_expression_024 | -는 법이다 | 法則表現（〜するものだ） | advanced | 法則 |
| grm_expression_025 | -(으)ㄴ/는 만큼 | 程度・理由（〜だけに/〜ほど） | advanced | 程度, 理由 |

---

### 7. numeral（数詞・助数詞）- 22項目

| ID | title | subtitle | level | tags |
|----|-------|----------|-------|------|
| grm_numeral_001 | 하나, 둘, 셋... | 固有数詞（1〜10） | beginner | 固有数詞, 基本 |
| grm_numeral_002 | 열하나, 스물... | 固有数詞（11〜99） | beginner | 固有数詞 |
| grm_numeral_003 | 한, 두, 세, 네 | 固有数詞の連体形 | beginner | 固有数詞, 連体形 |
| grm_numeral_004 | 일, 이, 삼... | 漢数詞（1〜10） | beginner | 漢数詞, 基本 |
| grm_numeral_005 | 십, 백, 천, 만 | 漢数詞の位 | beginner | 漢数詞, 位 |
| grm_numeral_006 | 개 | 助数詞（個） | beginner | 助数詞, 物 |
| grm_numeral_007 | 명/사람 | 助数詞（人） | beginner | 助数詞, 人 |
| grm_numeral_008 | 마리 | 助数詞（匹/頭/羽） | beginner | 助数詞, 動物 |
| grm_numeral_009 | 권 | 助数詞（冊） | beginner | 助数詞, 本 |
| grm_numeral_010 | 잔/병/컵 | 助数詞（杯/本/カップ） | beginner | 助数詞, 飲料 |
| grm_numeral_011 | 대 | 助数詞（台） | intermediate | 助数詞, 機械 |
| grm_numeral_012 | 장 | 助数詞（枚） | intermediate | 助数詞, 紙 |
| grm_numeral_013 | 벌 | 助数詞（着） | intermediate | 助数詞, 服 |
| grm_numeral_014 | 켤레 | 助数詞（足） | intermediate | 助数詞, 靴 |
| grm_numeral_015 | 번 | 助数詞（回/番） | beginner | 助数詞, 回数 |
| grm_numeral_016 | 시, 분, 초 | 時間の数え方 | beginner | 時間 |
| grm_numeral_017 | 년, 월, 일 | 日付の数え方 | beginner | 日付 |
| grm_numeral_018 | 원 | 助数詞（ウォン） | beginner | 助数詞, 通貨 |
| grm_numeral_019 | 층/호 | 助数詞（階/号） | intermediate | 助数詞, 建物 |
| grm_numeral_020 | 第一/첫째 | 序数詞（第〜/〜番目） | intermediate | 序数詞 |
| grm_numeral_021 | 살 | 助数詞（〜歳） | beginner | 助数詞, 年齢 |
| grm_numeral_022 | 인분 | 助数詞（〜人前） | beginner | 助数詞, 食事 |

---

### 8. interrogative（疑問詞）- 12項目

| ID | title | subtitle | level | tags |
|----|-------|----------|-------|------|
| grm_interrogative_001 | 누구 | 疑問代名詞（誰） | beginner | 人 |
| grm_interrogative_002 | 무엇/뭐 | 疑問代名詞（何） | beginner | 物 |
| grm_interrogative_003 | 어디 | 疑問副詞（どこ） | beginner | 場所 |
| grm_interrogative_004 | 언제 | 疑問副詞（いつ） | beginner | 時間 |
| grm_interrogative_005 | 왜 | 疑問副詞（なぜ） | beginner | 理由 |
| grm_interrogative_006 | 어떻게 | 疑問副詞（どのように） | beginner | 方法 |
| grm_interrogative_007 | 얼마 | 疑問代名詞（いくら） | beginner | 値段, 量 |
| grm_interrogative_008 | 몇 | 疑問連体詞（いくつ/何） | beginner | 数量 |
| grm_interrogative_009 | 어느 | 疑問連体詞（どの） | intermediate | 選択 |
| grm_interrogative_010 | 어떤 | 疑問連体詞（どんな） | intermediate | 種類 |
| grm_interrogative_011 | 무슨 | 疑問連体詞（何の） | beginner | 種類 |
| grm_interrogative_012 | 어디서/어디로 | 疑問副詞（どこで/どこへ） | intermediate | 場所, 方向 |

---

### 9. pronoun（代名詞・指示詞）- 15項目

| ID | title | subtitle | level | tags |
|----|-------|----------|-------|------|
| grm_pronoun_001 | 나/저 | 一人称代名詞（私） | beginner | 人称, 一人称 |
| grm_pronoun_002 | 너/당신 | 二人称代名詞（あなた） | beginner | 人称, 二人称 |
| grm_pronoun_003 | 그/그녀 | 三人称代名詞（彼/彼女） | beginner | 人称, 三人称 |
| grm_pronoun_004 | 우리/저희 | 複数人称代名詞（私たち） | beginner | 人称, 複数 |
| grm_pronoun_005 | 이것/그것/저것 | 指示代名詞（これ/それ/あれ） | beginner | 指示, 物 |
| grm_pronoun_006 | 여기/거기/저기 | 指示代名詞（ここ/そこ/あそこ） | beginner | 指示, 場所 |
| grm_pronoun_007 | 이/그/저 | 指示連体詞（この/その/あの） | beginner | 指示, 連体詞 |
| grm_pronoun_008 | 이런/그런/저런 | 指示連体詞（こんな/そんな/あんな） | intermediate | 指示, 種類 |
| grm_pronoun_009 | 이렇게/그렇게/저렇게 | 指示副詞（こう/そう/ああ） | intermediate | 指示, 様態 |
| grm_pronoun_010 | 자기/자신 | 再帰代名詞（自分） | intermediate | 再帰 |
| grm_pronoun_011 | 서로 | 相互代名詞（お互い） | intermediate | 相互 |
| grm_pronoun_012 | 누구나/아무나 | 不定代名詞（誰でも） | intermediate | 不定, 人 |
| grm_pronoun_013 | 무엇이나/아무거나 | 不定代名詞（何でも） | intermediate | 不定, 物 |
| grm_pronoun_014 | 어디나/아무데나 | 不定代名詞（どこでも） | intermediate | 不定, 場所 |
| grm_pronoun_015 | 이쪽/그쪽/저쪽 | 指示代名詞（こちら/そちら/あちら） | beginner | 指示, 方向 |

---

### 10. irregular（不規則活用）- 10項目

| ID | title | subtitle | level | tags |
|----|-------|----------|-------|------|
| grm_irregular_001 | ㅂ不規則 | ㅂ→우/오 変化（덥다→더워요） | beginner | 形容詞, 動詞 |
| grm_irregular_002 | ㄷ不規則 | ㄷ→ㄹ 変化（듣다→들어요） | beginner | 動詞 |
| grm_irregular_003 | ㅎ不規則 | ㅎ脱落（빨갛다→빨개요） | intermediate | 形容詞 |
| grm_irregular_004 | ㅅ不規則 | ㅅ脱落（짓다→지어요） | intermediate | 動詞 |
| grm_irregular_005 | ㄹ不規則 | ㄹ脱落（살다→삽니다） | beginner | 動詞, 形容詞 |
| grm_irregular_006 | 르不規則 | 르→ㄹㄹ 変化（모르다→몰라요） | beginner | 動詞, 形容詞 |
| grm_irregular_007 | 으不規則 | 으脱落（쓰다→써요） | beginner | 動詞, 形容詞 |
| grm_irregular_008 | 러不規則 | 러語幹（푸르다→푸르러요） | advanced | 形容詞 |
| grm_irregular_009 | 여不規則 | 하다→해요 変化 | beginner | 動詞 |
| grm_irregular_010 | 우不規則 | 우→워 変化（푸다→퍼요） | advanced | 動詞 |

---

### 11. voice（態：受身・使役）- 12項目

| ID | title | subtitle | level | tags |
|----|-------|----------|-------|------|
| grm_voice_001 | -이- 受身 | 받다→받이다（受けられる） | intermediate | 受身, 接尾辞 |
| grm_voice_002 | -히- 受身 | 먹다→먹히다（食べられる） | intermediate | 受身, 接尾辞 |
| grm_voice_003 | -리- 受身 | 듣다→들리다（聞こえる） | intermediate | 受身, 接尾辞 |
| grm_voice_004 | -기- 受身 | 안다→안기다（抱かれる） | intermediate | 受身, 接尾辞 |
| grm_voice_005 | -아/어지다 | 受身的表現（〜される/〜くなる） | beginner | 受身, 補助動詞 |
| grm_voice_006 | -이- 使役 | 먹다→먹이다（食べさせる） | intermediate | 使役, 接尾辞 |
| grm_voice_007 | -히- 使役 | 읽다→읽히다（読ませる） | intermediate | 使役, 接尾辞 |
| grm_voice_008 | -리- 使役 | 알다→알리다（知らせる） | intermediate | 使役, 接尾辞 |
| grm_voice_009 | -기- 使役 | 웃다→웃기다（笑わせる） | intermediate | 使役, 接尾辞 |
| grm_voice_010 | -우/구/추- 使役 | 자다→재우다（寝かせる） | advanced | 使役, 接尾辞 |
| grm_voice_011 | -게 하다 | 使役的表現（〜させる） | beginner | 使役, 補助動詞 |
| grm_voice_012 | -도록 하다 | 使役的表現（〜するようにさせる） | intermediate | 使役, 補助動詞 |

---

### 12. quotation（引用表現）- 11項目

| ID | title | subtitle | level | tags |
|----|-------|----------|-------|------|
| grm_quotation_001 | -라고/이라고 하다 | 直接引用（〜と言う） | beginner | 直接引用 |
| grm_quotation_002 | -ㄴ/는다고 하다 | 間接引用・平叙文（〜と言う） | intermediate | 間接引用, 平叙 |
| grm_quotation_003 | -(으)라고 하다 | 間接引用・命令文（〜しろと言う） | intermediate | 間接引用, 命令 |
| grm_quotation_004 | -자고 하다 | 間接引用・勧誘文（〜しようと言う） | intermediate | 間接引用, 勧誘 |
| grm_quotation_005 | -(으)냐고 하다 | 間接引用・疑問文（〜かと聞く） | intermediate | 間接引用, 疑問 |
| grm_quotation_006 | -대요 | 伝聞縮約形（〜だそうです） | intermediate | 伝聞, 縮約 |
| grm_quotation_007 | -래요 | 伝聞縮約形（〜しろそうです） | intermediate | 伝聞, 縮約 |
| grm_quotation_008 | -냬요 | 伝聞縮約形（〜かと聞いています） | advanced | 伝聞, 縮約 |
| grm_quotation_009 | -다고/-라고 | 引用助詞（〜と） | beginner | 引用助詞 |
| grm_quotation_010 | -다면서요? | 確認引用（〜だそうですね？） | advanced | 確認, 伝聞 |
| grm_quotation_011 | -재요 | 伝聞縮約形・勧誘（〜しようって） | intermediate | 伝聞, 縮約, 勧誘 |

---

### 13. negation（否定表現）- 7項目

| ID | title | subtitle | level | tags |
|----|-------|----------|-------|------|
| grm_negation_001 | 안 + 動詞/形容詞 | 短形否定（〜しない） | beginner | 短形否定 |
| grm_negation_002 | -지 않다 | 長形否定（〜しない） | beginner | 長形否定 |
| grm_negation_003 | 못 + 動詞 | 短形不可能否定（〜できない） | beginner | 不可能 |
| grm_negation_004 | -지 못하다 | 長形不可能否定（〜できない） | beginner | 不可能 |
| grm_negation_005 | -지 말다 | 禁止の基本形（〜するな） | intermediate | 禁止 |
| grm_negation_006 | 아니다 | 否定指定詞（〜ではない） | beginner | 否定指定詞 |
| grm_negation_007 | 없다 | 非存在・非所有（〜がない） | beginner | 非存在 |

---

### 14. adverb（副詞）- 24項目

| ID | title | subtitle | level | tags |
|----|-------|----------|-------|------|
| grm_adverb_001 | 아주 | 程度副詞（とても） | beginner | 程度 |
| grm_adverb_002 | 매우 | 程度副詞（非常に） | beginner | 程度, フォーマル |
| grm_adverb_003 | 너무 | 程度副詞（あまりに/とても） | beginner | 程度 |
| grm_adverb_004 | 정말/진짜 | 程度副詞（本当に） | beginner | 程度, 強調 |
| grm_adverb_005 | 조금/좀 | 程度副詞（少し） | beginner | 程度, 軽減 |
| grm_adverb_006 | 항상/늘 | 頻度副詞（いつも） | beginner | 頻度 |
| grm_adverb_007 | 자주 | 頻度副詞（よく/しばしば） | beginner | 頻度 |
| grm_adverb_008 | 가끔 | 頻度副詞（たまに） | beginner | 頻度 |
| grm_adverb_009 | 별로 | 頻度副詞（あまり〜ない） | beginner | 頻度, 否定呼応 |
| grm_adverb_010 | 전혀 | 頻度副詞（全く〜ない） | intermediate | 頻度, 否定呼応 |
| grm_adverb_011 | 빨리 | 様態副詞（早く/速く） | beginner | 様態 |
| grm_adverb_012 | 천천히 | 様態副詞（ゆっくり） | beginner | 様態 |
| grm_adverb_013 | 잘 | 様態副詞（よく/上手に） | beginner | 様態 |
| grm_adverb_014 | 같이/함께 | 様態副詞（一緒に） | beginner | 様態, 共同 |
| grm_adverb_015 | 만약 〜(으)면 | 呼応副詞（もし〜なら） | intermediate | 呼応, 条件 |
| grm_adverb_016 | 비록 〜지만 | 呼応副詞（たとえ〜でも） | intermediate | 呼応, 譲歩 |
| grm_adverb_017 | 아무리 〜도 | 呼応副詞（いくら〜ても） | intermediate | 呼応, 譲歩 |
| grm_adverb_018 | 결코 〜않다 | 呼応副詞（決して〜ない） | advanced | 呼応, 否定 |
| grm_adverb_019 | 도저히 〜못하다 | 呼応副詞（とても〜できない） | advanced | 呼応, 不可能 |
| grm_adverb_020 | 거의 | 程度副詞（ほとんど） | intermediate | 程度 |
| grm_adverb_021 | 이미 | 時間副詞（すでに） | beginner | 時間 |
| grm_adverb_022 | 아직 | 時間副詞（まだ） | beginner | 時間, 継続 |
| grm_adverb_023 | 벌써 | 時間副詞（もう） | beginner | 時間, 驚き |
| grm_adverb_024 | 드디어 | 時間副詞（ついに） | intermediate | 時間, 達成 |

---

### 15. interjection（感嘆詞・間投詞）- 12項目

| ID | title | subtitle | level | tags |
|----|-------|----------|-------|------|
| grm_interjection_001 | 네/예 | 応答詞（はい） | beginner | 応答, 肯定 |
| grm_interjection_002 | 아니요 | 応答詞（いいえ） | beginner | 応答, 否定 |
| grm_interjection_003 | 글쎄요 | 応答詞（さあ/うーん） | beginner | 応答, 曖昧 |
| grm_interjection_004 | 저기요 | 呼びかけ詞（すみません） | beginner | 呼びかけ |
| grm_interjection_005 | 여보세요 | 呼びかけ詞（もしもし） | beginner | 呼びかけ, 電話 |
| grm_interjection_006 | 아이고 | 感嘆詞（あらまあ/ああ） | beginner | 感嘆, 驚き |
| grm_interjection_007 | 어머/어머나 | 感嘆詞（まあ/あら） | beginner | 感嘆, 驚き |
| grm_interjection_008 | 와/우와 | 感嘆詞（わあ） | beginner | 感嘆, 感動 |
| grm_interjection_009 | 아차 | 感嘆詞（しまった） | intermediate | 感嘆, 後悔 |
| grm_interjection_010 | 에이 | 感嘆詞（ちぇっ/もう） | intermediate | 感嘆, 不満 |
| grm_interjection_011 | 뭐 | 間投詞（まあ/なんというか） | intermediate | 間投, フィラー |
| grm_interjection_012 | 그러니까 | 間投詞（だから/つまり） | intermediate | 間投, 接続 |

---

## レベル別サマリー

| カテゴリ | beginner | intermediate | advanced | 合計 |
|---------|----------|--------------|----------|------|
| particle | 14 | 8 | 3 | 25 |
| ending | 15 | 14 | 6 | 35 |
| connective | 6 | 9 | 7 | 22 |
| honorific | 5 | 6 | 4 | 15 |
| tense | 7 | 3 | 2 | 12 |
| expression | 0 | 14 | 11 | 25 |
| numeral | 16 | 6 | 0 | 22 |
| interrogative | 9 | 3 | 0 | 12 |
| pronoun | 7 | 8 | 0 | 15 |
| irregular | 6 | 2 | 2 | 10 |
| voice | 2 | 9 | 1 | 12 |
| quotation | 2 | 7 | 2 | 11 |
| negation | 6 | 1 | 0 | 7 |
| adverb | 17 | 5 | 2 | 24 |
| interjection | 8 | 4 | 0 | 12 |
| **合計** | **120** | **99** | **40** | **259** |

---

## JSON作成指示

### Phase 1: マスターインデックス作成

```
ファイル: application/assets/grammar/grammar_index.json
```

**指示:**
1. 上記の15カテゴリ全てを含むインデックスを作成
2. 各カテゴリのitemsに上記テーブルの情報を反映
3. 仕様書の2.2節のフォーマットに厳密に従う

---

### Phase 2: 個別文法ファイル作成（レベル別）

#### Phase 2-1: beginner（初級）- 120項目

**優先度: 最高**

作成対象:
- particle: 001-014
- ending: 001-010, 012-013, 021, 031, 035
- connective: 001-005, 021
- honorific: 001-003, 007, 012-013
- tense: 001-003, 005, 008-010
- numeral: 001-010, 015-018, 021-022
- interrogative: 001-008, 011
- pronoun: 001-007, 015
- irregular: 001-002, 005-007, 009
- voice: 005, 011
- quotation: 001, 009
- negation: 001-004, 006-007
- adverb: 001-009, 011-014, 021-023
- interjection: 001-008

**各ファイルに含める要素:**
```json
{
  "id": "grm_{category}_{number}",
  "title": "文法タイトル",
  "subtitle": "日本語説明",
  "category": "カテゴリID",
  "level": "beginner",
  "tags": ["タグ1", "タグ2"],
  "content": {
    "summary": "1-2文の説明",
    "formationRules": [/* 2-3個の活用規則 */],
    "usageCases": [/* 2-3個の用法と例文 */],
    "comparison": {/* 類似文法との比較（該当する場合） */},
    "tips": ["ヒント1", "ヒント2"],
    "relatedGrammar": ["関連文法ID"]
  },
  "exercises": [
    /* fill_blank: 1問 */,
    /* choice: 1問 */,
    /* typing: 1問 */
  ]
}
```

---

#### Phase 2-2: intermediate（中級）- 99項目

**優先度: 高**

作成対象:
- particle: 015-022
- ending: 011, 014-020, 022-024, 032-034
- connective: 006-013, 022
- honorific: 004-006, 008-011
- tense: 004, 006-007
- expression: 001-005, 008-014, 019
- numeral: 011-014, 019-020
- interrogative: 009-010, 012
- pronoun: 008-014
- irregular: 003-004
- voice: 001-004, 006-009, 012
- quotation: 002-007, 011
- negation: 005
- adverb: 010, 015-017, 020, 024
- interjection: 009-012

**要件:**
- beginnerより詳細な説明
- formationRulesを3-4個に増加
- usageCasesを3-4個に増加
- exercisesを4問（fill_blank, choice, typing, translation各1問）

---

#### Phase 2-3: advanced（上級）- 40項目

**優先度: 中**

作成対象:
- particle: 023-025（3項目）
- ending: 025-030（6項目）
- connective: 014-020（7項目）
- honorific: 014-015（2項目）
- tense: 011-012（2項目）
- expression: 006-007, 015-018, 020-025（13項目）
- irregular: 008, 010（2項目）
- voice: 010（1項目）
- quotation: 008, 010（2項目）
- adverb: 018-019（2項目）

**要件:**
- 詳細な文法解説
- 微妙なニュアンスの違いを説明
- formationRulesを4-5個
- usageCasesを4-5個（複雑な文脈での使用例を含む）
- exercisesを5問（全タイプ網羅）

---

## ディレクトリ作成コマンド

```bash
mkdir -p application/assets/grammar/{particle,ending,connective,honorific,tense,expression,numeral,interrogative,pronoun,irregular,voice,quotation,negation,adverb,interjection}
```

---

## 品質チェックリスト

各JSONファイル作成後、以下を確認:

- [ ] JSONが有効（構文エラーなし）
- [ ] 仕様書のフォーマットに準拠
- [ ] 例文に韓国語・日本語・発音が含まれる
- [ ] exercisesに複数タイプの問題が含まれる
- [ ] relatedGrammarのIDが実在する（重複項目は相互参照）
- [ ] tagsが一貫している
- [ ] 統合済み重複項目が正しく処理されている（ending_005 ← negation削除分）

---

## 実行例: particle_001.json作成指示

```
タスク: application/assets/grammar/particle/particle_001.json を作成

参照情報:
- カテゴリ: particle（助詞）
- ID: grm_particle_001
- title: 이/가
- subtitle: 主格助詞（〜が）
- level: beginner
- tags: ["主格", "基本"]

作成要件:
1. summary: 主格助詞の基本説明（日本語の「が」に相当）
2. formationRules:
   - パッチムあり → 이（例: 책이）
   - パッチムなし → 가（例: 사과가）
   - 特殊形: 나 + 가 → 내가
3. usageCases:
   - 主語を示す基本用法
   - 新情報を示す用法
   - 疑問詞との組み合わせ
4. comparison: 은/는との違い
5. tips: 縮約形、省略について
6. exercises: fill_blank, choice, typing各1問
7. relatedGrammar: ["grm_particle_002"]

出力: 仕様書2.3節のフォーマットに準拠したJSON
```

---

## バッチ作成時の注意

複数ファイルを一度に作成する場合:

1. **同一カテゴリをまとめて作成**（一貫性確保）
2. **relatedGrammarの相互参照を確認**
3. **レベル内でtags用語を統一**
4. **例文が重複しないよう注意**

### 重複項目の相互参照

以下の項目は異なるカテゴリに存在しますが、観点が異なるため両方維持します。
JSON作成時は必ず `relatedGrammar` で相互リンクしてください。

| 項目 | ending | tense | 説明 |
|------|--------|-------|------|
| -고 있다 | grm_ending_021 | grm_tense_005 | ending=語尾用法、tense=進行相 |
| -아/어 있다 | grm_ending_020 | grm_tense_006 | ending=語尾用法、tense=結果状態相 |

### 統合済み重複項目

以下の項目は完全重複のため、一方のカテゴリに統合しました。

| 項目 | 統合先 | 削除元 | 備考 |
|------|--------|--------|------|
| -지 마세요 | grm_ending_005 | 旧negation_005 | 禁止語尾としてendingに統合 |

---