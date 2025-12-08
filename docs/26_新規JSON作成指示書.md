# 新規JSONファイル作成指示書

## 概要

新しいカテゴリ構造に合わせて、約70項目の新規文法JSONファイルを作成します。この作業を5人で分担して行います。

## JSONファイル構造テンプレート

```json
{
  "id": "grm_{category}_{連番3桁}",
  "title": "韓国語タイトル",
  "subtitle": "日本語説明（〜）",
  "category": "{category}",
  "level": "beginner|intermediate|advanced",
  "tags": ["タグ1", "タグ2"],
  "content": {
    "summary": "この文法の概要説明（2-3文）",
    "formationRules": [
      {
        "condition": "条件説明",
        "form": "形式",
        "example": "例"
      }
    ],
    "usageCases": [
      {
        "title": "用法タイトル",
        "description": "説明",
        "examples": [
          {
            "korean": "韓国語例文",
            "japanese": "日本語訳"
          }
        ]
      }
    ],
    "comparison": {
      "title": "比較対象との違い",
      "description": "違いの説明",
      "examples": []
    },
    "tips": ["ヒント1", "ヒント2"],
    "relatedGrammar": ["grm_xxx_001"]
  },
  "exercises": [
    {
      "id": "ex_001",
      "type": "fill_blank",
      "question": "問題文___。",
      "answer": "答え",
      "hint": "ヒント",
      "explanation": "解説"
    },
    {
      "id": "ex_002",
      "type": "choice",
      "question": "問題文",
      "choices": ["選択肢1", "選択肢2", "選択肢3", "選択肢4"],
      "answerIndex": 0,
      "explanation": "解説"
    }
  ]
}
```

## ファイル保存場所

```
application/assets/grammar/{category}/{category}_{連番3桁}.json
```

---

## 担当1: orthography（表記・発音）前半 - 12項目

### 担当範囲
`23_文法修正.md`の「1. 表記・発音」のうち、ハングルの構造〜分かち書きまで

### 作成項目一覧

| ID | ファイル名 | タイトル | subtitle | level |
|----|-----------|---------|----------|-------|
| grm_orthography_001 | orthography_001.json | 한글의 구조 | ハングルの構造 | beginner |
| grm_orthography_002 | orthography_002.json | 단모음 | 単母音（ㅏ, ㅓ, ㅗ, ㅜ, ㅡ, ㅣ, ㅐ, ㅔ, ㅚ, ㅟ） | beginner |
| grm_orthography_003 | orthography_003.json | 반모음 | 半母音（ㅗ/ㅜ系, ㅣ系） | beginner |
| grm_orthography_004 | orthography_004.json | 이중모음 | 二重母音（ㅑ, ㅕ, ㅛ, ㅠ, ㅒ, ㅖ, ㅘ, ㅙ, ㅝ, ㅞ, ㅢ） | beginner |
| grm_orthography_005 | orthography_005.json | 평음 | 平音（ㄱ, ㄷ, ㅂ, ㅅ, ㅈ） | beginner |
| grm_orthography_006 | orthography_006.json | 격음 | 激音（ㅋ, ㅌ, ㅍ, ㅊ） | beginner |
| grm_orthography_007 | orthography_007.json | 경음 | 濃音（ㄲ, ㄸ, ㅃ, ㅆ, ㅉ） | beginner |
| grm_orthography_008 | orthography_008.json | 비음 | 鼻音（ㄴ, ㅁ, ㅇ） | beginner |
| grm_orthography_009 | orthography_009.json | 유음 | 流音（ㄹ） | beginner |
| grm_orthography_010 | orthography_010.json | 받침 | 子音の字母（終声/パッチム） | beginner |
| grm_orthography_011 | orthography_011.json | 자모의 명칭과 배열 | 字母の名称と配列 | beginner |
| grm_orthography_012 | orthography_012.json | 띄어쓰기 | 分かち書きについて | intermediate |

### 内容のポイント

#### orthography_001: ハングルの構造
- ハングルは子音（初声）+ 母音（中声）+ 子音（終声/パッチム）の組み合わせ
- 初声19個、中声21個、終声27個（無音含む）
- 組み合わせの基本パターン（左右型、上下型、混合型）

#### orthography_002-004: 母音
- 単母音の発音と口の形
- 半母音（わたり音）の特徴
- 二重母音の発音のしかた

#### orthography_005-009: 子音
- 各子音グループの発音特徴
- 音声学的な分類（調音位置、調音方法）
- 発音のコツ

#### orthography_010: パッチム
- 7つの代表音
- 二重パッチムの発音規則

---

## 担当2: orthography（表記・発音）後半 - 10項目

### 担当範囲
`23_文法修正.md`の「1. 表記・発音」のうち、発音の変化

### 作成項目一覧

| ID | ファイル名 | タイトル | subtitle | level |
|----|-----------|---------|----------|-------|
| grm_orthography_013 | orthography_013.json | 받침의 중화 | 終声の中和 | intermediate |
| grm_orthography_014 | orthography_014.json | 연음화 | 連音化 | beginner |
| grm_orthography_015 | orthography_015.json | 받침의 초음화 | 終声の初音化 | intermediate |
| grm_orthography_016 | orthography_016.json | 격음화 | 激音化 | intermediate |
| grm_orthography_017 | orthography_017.json | 경음화 | 濃音化 | intermediate |
| grm_orthography_018 | orthography_018.json | 비음화 | 鼻音化 | intermediate |
| grm_orthography_019 | orthography_019.json | ㅎ의 약화 | ㅎの弱化 | intermediate |
| grm_orthography_020 | orthography_020.json | 유음화 | 流音化 | intermediate |
| grm_orthography_021 | orthography_021.json | ㄴ 첨가 | ㄴ挿入 | advanced |
| grm_orthography_022 | orthography_022.json | 구개음화 | 口蓋音化 | advanced |

### 内容のポイント

#### orthography_013: 終声の中和
- パッチムが7つの代表音に変わる現象
- 例: 부엌[부억], 밖[박]

#### orthography_014: 連音化
- パッチムが次の母音に連結する現象
- 例: 음악을[으마글], 한국어[한구거]

#### orthography_015: 終声の初音化
- ㅎパッチム + 母音の場合
- 例: 좋아요[조아요]

#### orthography_016: 激音化
- ㅎと平音が出会って激音になる
- 例: 좋다[조타], 입학[이팍]

#### orthography_017: 濃音化
- 平音が濃音に変わる条件
- 例: 학교[학꾜], 식당[식땅]

#### orthography_018: 鼻音化
- 終声が鼻音に変わる
- 例: 한국말[한궁말], 십만[심만]

#### orthography_019: ㅎの弱化
- ㅎが弱く発音される/消える
- 例: 전화[저놔], 은행[으냉]

#### orthography_020: 流音化
- ㄴがㄹに変わる
- 例: 신라[실라], 한류[할류]

#### orthography_021: ㄴ挿入
- 合成語でㄴが挿入される
- 例: 한여름[한녀름]

#### orthography_022: 口蓋音化
- ㄷ, ㅌ + 이 → ㅈ, ㅊ
- 例: 같이[가치], 맏이[마지]

---

## 担当3: conjugation（用言と活用）- 15項目

### 担当範囲
`23_文法修正.md`の「4. 用言と活用カテゴリ」のうち、新規作成分

### 作成項目一覧

| ID | ファイル名 | タイトル | subtitle | level |
|----|-----------|---------|----------|-------|
| grm_conjugation_011 | conjugation_011.json | 용언과 품사 | 韓国語の用言と品詞 | beginner |
| grm_conjugation_012 | conjugation_012.json | 어간과 어미 | 語幹・語尾・接尾辞 | beginner |
| grm_conjugation_013 | conjugation_013.json | 자음어간과 모음어간 | 子音語幹用言と母音語幹用言 | beginner |
| grm_conjugation_014 | conjugation_014.json | 제Ⅰ어기 | 第Ⅰ語基 | intermediate |
| grm_conjugation_015 | conjugation_015.json | 제Ⅱ어기 | 第Ⅱ語基 | intermediate |
| grm_conjugation_016 | conjugation_016.json | 제Ⅲ어기 | 第Ⅲ語基 | intermediate |
| grm_conjugation_017 | conjugation_017.json | 규칙용언 제Ⅰ어기 | 規則用言の第Ⅰ語基活用 | intermediate |
| grm_conjugation_018 | conjugation_018.json | 규칙용언 제Ⅱ어기 | 規則用言の第Ⅱ語基活用 | intermediate |
| grm_conjugation_019 | conjugation_019.json | 규칙용언 제Ⅲ어기 | 規則用言の第Ⅲ語基活用 | intermediate |
| grm_conjugation_020 | conjugation_020.json | 지정사의 활용 | 指定詞の活用 | intermediate |
| grm_conjugation_021 | conjugation_021.json | 특수 활용 | そのほかの特殊な活用 | advanced |
| grm_conjugation_022 | conjugation_022.json | 비표준 활용 | 規則に従わない非標準的活用形 | advanced |

### 内容のポイント

#### 용언과 품사（用言と品詞）
- 動詞・形容詞・存在詞・指定詞の区別
- 各品詞の特徴

#### 어간과 어미（語幹・語尾・接尾辞）
- 語幹と語尾の分離
- 接尾辞の役割

#### 자음어간과 모음어간（子音語幹・母音語幹）
- 語幹末の子音/母音による分類
- 活用への影響

#### 語基の説明
- 第Ⅰ語基：基本形から다を取った形
- 第Ⅱ語基：으語尾接続用
- 第Ⅲ語基：아/어語尾接続用

※ conjugation_001-010は既存のirregular（不規則活用）からの移行分

---

## 担当4: adnominal（連体形）- 9項目

### 担当範囲
`23_文法修正.md`の「7. 連体形カテゴリ」のうち、新規作成分

### 作成項目一覧

| ID | ファイル名 | タイトル | subtitle | level |
|----|-----------|---------|----------|-------|
| grm_adnominal_007 | adnominal_007.json | 동사·존재사 비과거 | 動詞と存在詞の非過去連体形の作り方 | intermediate |
| grm_adnominal_008 | adnominal_008.json | 형용사·지정사 비과거 | 形容詞と指定詞の非過去連体形の作り方 | intermediate |
| grm_adnominal_009 | adnominal_009.json | 비과거 연체형의 의미 | 非過去連体形の意味 | intermediate |
| grm_adnominal_010 | adnominal_010.json | 과거 연체형의 의미 | 過去連体形の意味 | intermediate |
| grm_adnominal_011 | adnominal_011.json | 의지·추량 연체형의 의미 | 意志・推量連体形の意味 | intermediate |
| grm_adnominal_012 | adnominal_012.json | 특정 체언과의 연결 | 意志・推量連体形のみを用いる体言 | advanced |
| grm_adnominal_013 | adnominal_013.json | 총칭 표현 | 動作の対象となるものの総称を表す | advanced |
| grm_adnominal_014 | adnominal_014.json | 한자의 훈 | 漢字の訓を表す | advanced |

### 内容のポイント

#### 非過去連体形
- 動詞・存在詞: -는（現在進行、習慣）
- 形容詞・指定詞: -(으)ㄴ（状態）

#### 過去連体形
- -(으)ㄴ（動詞: 完了した動作）
- -던（回想、未完了）

#### 意志・推量連体形
- -(으)ㄹ（未来、意志、推量）
- 것, 수, 줄, 리 などとの結合

※ adnominal_001-006は既存のending/tenseからの移行分

---

## 担当5: word_formation（単語の作り）- 11項目

### 担当範囲
`23_文法修正.md`の「11. 単語の作りカテゴリ」のうち、新規作成分

### 作成項目一覧

| ID | ファイル名 | タイトル | subtitle | level |
|----|-----------|---------|----------|-------|
| grm_word_formation_020 | word_formation_020.json | 부사형 -리/-이/-히 | 副詞形 -리、-이、-히 | intermediate |
| grm_word_formation_021 | word_formation_021.json | 부사형 I-게 | 副詞形 I-게 | beginner |
| grm_word_formation_022 | word_formation_022.json | 체언형 I-기 | 体言形 I-기 | beginner |
| grm_word_formation_023 | word_formation_023.json | 체언형 Ⅱ-ㅁ | 体言形 Ⅱ-ㅁ | intermediate |
| grm_word_formation_024 | word_formation_024.json | 파생 명사 | 用言から派生した名詞 | intermediate |
| grm_word_formation_025 | word_formation_025.json | 고유어 접두사 | 固有語の接頭辞 | intermediate |
| grm_word_formation_026 | word_formation_026.json | 한자어 접두사 | 漢字語の接頭辞 | intermediate |
| grm_word_formation_027 | word_formation_027.json | 고유어 접미사 | 固有語の接尾辞 | intermediate |
| grm_word_formation_028 | word_formation_028.json | 수량 접미사 | 数量に関する接尾辞 | intermediate |
| grm_word_formation_029 | word_formation_029.json | 복수 접미사 | 複数を表す接尾辞 | beginner |
| grm_word_formation_030 | word_formation_030.json | 용언 접미사 | 用言接尾辞 | advanced |

### 内容のポイント

#### 副詞形
- -리: 달리（違って）、빨리（早く）
- -이: 많이（たくさん）、깊이（深く）
- -히: 조용히（静かに）、급히（急いで）
- -게: 形容詞語幹 + 게 = 副詞的用法

#### 体言形
- -기: 動詞の名詞化（걷기、먹기）
- -ㅁ/-음: 動詞の名詞化（걸음、믿음）

#### 接頭辞
- 固有語: 맏-（長男の）、햇-（新〜）、덧-（上に重ねて）
- 漢字語: 불-（不）、비-（非）、초-（超）

#### 接尾辞
- 固有語: -이（行為者）、-개（道具）
- 数量: -씩（〜ずつ）、-째（〜目）
- 複数: -들（複数形）

※ word_formation_001-019は既存のadverbからの移行分

---

## 品質チェックリスト

各ファイル作成後、以下を確認してください：

- [ ] JSON構文エラーがないか
- [ ] IDとファイル名が一致しているか
- [ ] categoryが正しいカテゴリ名になっているか
- [ ] levelがbeginner/intermediate/advancedのいずれかか
- [ ] formationRulesに最低1つ以上の規則があるか
- [ ] usageCasesに最低1つ以上の用例があるか
- [ ] examplesにkoreanとjapaneseの両方があるか
- [ ] exercisesに最低2つ以上の問題があるか
- [ ] relatedGrammarのIDが正しい形式か

---

## 参考ドキュメント

- `docs/21_文法辞典機能の詳細.md` - 機能仕様
- `docs/22_文法辞典JSONファイル作成指示書.md` - JSONフォーマット詳細
- `docs/23_文法修正.md` - 各カテゴリの詳細な内容要件
- `docs/24_文法修正計画.md` - 全体計画
- `application/assets/grammar/particle/particle_001.json` - 既存ファイルの参考例
