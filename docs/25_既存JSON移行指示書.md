# 既存JSONファイル移行指示書

## 概要

既存の15カテゴリ（257項目）を新しい11カテゴリに移行します。この作業を5人で分担して行います。

## 新カテゴリ構造

| # | カテゴリID | 日本語名 | JSON値 |
|---|-----------|----------|--------|
| 1 | orthography | 表記・発音 | `"orthography"` |
| 2 | substantive | 体言 | `"substantive"` |
| 3 | particle | 助詞 | `"particle"` |
| 4 | conjugation | 用言と活用 | `"conjugation"` |
| 5 | sentence_ending | 終止形と待遇法 | `"sentence_ending"` |
| 6 | connective | 接続形 | `"connective"` |
| 7 | adnominal | 連体形 | `"adnominal"` |
| 8 | tense_aspect | 時制 | `"tense_aspect"` |
| 9 | expression | さまざまな表現 | `"expression"` |
| 10 | quotation | 直接話法と間接話法 | `"quotation"` |
| 11 | word_formation | 単語の作り | `"word_formation"` |

## 共通の作業手順

### 1. JSONファイルの移行手順

1. 元のファイルを読み込む
2. `id`を新しいカテゴリに合わせて変更（例: `grm_pronoun_001` → `grm_substantive_001`）
3. `category`を新しいカテゴリに変更
4. `relatedGrammar`の参照を新しいIDに更新
5. 新しいディレクトリに新しいファイル名で保存

### 2. ファイル名の命名規則

```
{新カテゴリ}/{新カテゴリ}_{連番3桁}.json

例: substantive/substantive_001.json
```

### 3. ID命名規則

```
grm_{新カテゴリ}_{連番3桁}

例: grm_substantive_001
```

---

## 担当1: particle + connective（維持カテゴリ）

### 担当範囲: 47項目

#### particle（25項目）- そのまま維持
- ファイル: `particle/particle_001.json` ～ `particle/particle_025.json`
- ID: `grm_particle_001` ～ `grm_particle_025`
- **変更なし**（category属性が`particle`のままなので移行不要）

#### connective（22項目）- そのまま維持
- ファイル: `connective/connective_001.json` ～ `connective/connective_022.json`
- ID: `grm_connective_001` ～ `grm_connective_022`
- **変更なし**（category属性が`connective`のままなので移行不要）

### 作業内容
1. 各ファイルの`relatedGrammar`を確認
2. 旧カテゴリIDへの参照があれば新カテゴリIDに更新
3. 変更があったファイルのみ保存

### relatedGrammar更新マッピング
```
grm_pronoun_* → grm_substantive_*
grm_numeral_* → grm_substantive_*
grm_interrogative_* → grm_substantive_*
grm_ending_* → grm_sentence_ending_* または grm_expression_*
grm_tense_* → grm_tense_aspect_* または grm_adnominal_*
grm_irregular_* → grm_conjugation_*
grm_negation_* → grm_tense_aspect_*
grm_voice_* → grm_tense_aspect_*
grm_honorific_* → grm_tense_aspect_* または grm_sentence_ending_*
grm_adverb_* → grm_word_formation_* または grm_expression_*
```

---

## 担当2: quotation + expression（維持カテゴリ）

### 担当範囲: 36項目

#### quotation（11項目）- そのまま維持
- ファイル: `quotation/quotation_001.json` ～ `quotation/quotation_011.json`
- ID: `grm_quotation_001` ～ `grm_quotation_011`
- **変更なし**

#### expression（25項目）- そのまま維持
- ファイル: `expression/expression_001.json` ～ `expression/expression_025.json`
- ID: `grm_expression_001` ～ `grm_expression_025`
- **変更なし**

### 作業内容
担当1と同様に`relatedGrammar`の更新のみ

---

## 担当3: substantive（体言）カテゴリの作成

### 担当範囲: 49項目 → substantive

#### 移行元と新ID対応表

| 旧カテゴリ | 旧ID範囲 | 新ID範囲 | 項目数 |
|-----------|---------|---------|--------|
| pronoun | grm_pronoun_001-015 | grm_substantive_001-015 | 15 |
| numeral | grm_numeral_001-022 | grm_substantive_016-037 | 22 |
| interrogative | grm_interrogative_001-012 | grm_substantive_038-049 | 12 |

### 作業手順

1. **pronoun（15項目）**
   - 元: `pronoun/pronoun_001.json` → 先: `substantive/substantive_001.json`
   - ID変更: `grm_pronoun_001` → `grm_substantive_001`
   - category変更: `"pronoun"` → `"substantive"`

2. **numeral（22項目）**
   - 元: `numeral/numeral_001.json` → 先: `substantive/substantive_016.json`
   - ID変更: `grm_numeral_001` → `grm_substantive_016`
   - category変更: `"numeral"` → `"substantive"`

3. **interrogative（12項目）**
   - 元: `interrogative/interrogative_001.json` → 先: `substantive/substantive_038.json`
   - ID変更: `grm_interrogative_001` → `grm_substantive_038`
   - category変更: `"interrogative"` → `"substantive"`

### JSON変更例

```json
// 変更前
{
  "id": "grm_pronoun_001",
  "category": "pronoun",
  ...
}

// 変更後
{
  "id": "grm_substantive_001",
  "category": "substantive",
  ...
}
```

---

## 担当4: ending + honorific → 複数カテゴリへ分散

### 担当範囲: 50項目

#### ending（35項目）の移行先

| 旧ID | タイトル | 移行先カテゴリ | 新ID |
|------|---------|--------------|------|
| ending_001 | -아/어요 | sentence_ending | sentence_ending_001 |
| ending_002 | -습니다/ㅂ니다 | sentence_ending | sentence_ending_002 |
| ending_003 | -아/어 | sentence_ending | sentence_ending_003 |
| ending_004 | -(으)세요 | sentence_ending | sentence_ending_004 |
| ending_005 | -지 마세요 | sentence_ending | sentence_ending_005 |
| ending_006 | -(으)ㄹ게요 | sentence_ending | sentence_ending_006 |
| ending_007 | -(으)ㄹ까요 | sentence_ending | sentence_ending_007 |
| ending_008 | -고 싶다 | expression | expression_026 |
| ending_009 | -(으)ㄹ 수 있다/없다 | expression | expression_027 |
| ending_010 | -아/어야 하다 | expression | expression_028 |
| ending_011 | -(으)면 되다 | expression | expression_029 |
| ending_012 | -지 않다 | tense_aspect | tense_aspect_001 |
| ending_013 | -못하다 | tense_aspect | tense_aspect_002 |
| ending_014 | -(으)ㄴ/는 것 같다 | expression | expression_030 |
| ending_015 | -나 보다 | expression | expression_031 |
| ending_016 | -(으)ㄹ 것이다 | expression | expression_032 |
| ending_017 | -게 되다 | expression | expression_033 |
| ending_018 | -아/어 보다 | expression | expression_034 |
| ending_019 | -아/어 주다 | expression | expression_035 |
| ending_020 | -아/어 있다 | tense_aspect | tense_aspect_003 |
| ending_021 | -고 있다 | tense_aspect | tense_aspect_004 |
| ending_022 | -아/어 본 적이 있다 | expression | expression_036 |
| ending_023 | -(으)려고 하다 | expression | expression_037 |
| ending_024 | -기로 하다 | expression | expression_038 |
| ending_025 | -(으)ㄹ 뻔하다 | expression | expression_039 |
| ending_026 | -던 | adnominal | adnominal_001 |
| ending_027 | -(으)ㄹ수록 | connective | connective_023 |
| ending_028 | -(으)니까 | sentence_ending | sentence_ending_008 |
| ending_029 | -더라 | sentence_ending | sentence_ending_009 |
| ending_030 | -(으)ㄹ까 봐 | expression | expression_040 |
| ending_031 | -네요 | sentence_ending | sentence_ending_010 |
| ending_032 | -군요 | sentence_ending | sentence_ending_011 |
| ending_033 | -잖아요 | sentence_ending | sentence_ending_012 |
| ending_034 | -거든요 | sentence_ending | sentence_ending_013 |
| ending_035 | -(으)ㅂ시다 | sentence_ending | sentence_ending_014 |

#### honorific（15項目）の移行先

| 旧ID | タイトル | 移行先カテゴリ | 新ID |
|------|---------|--------------|------|
| honorific_001 | -(으)시- | tense_aspect | tense_aspect_005 |
| honorific_002 | 드시다/잡수시다 | tense_aspect | tense_aspect_006 |
| honorific_003 | 주무시다 | tense_aspect | tense_aspect_007 |
| honorific_004 | 계시다 | tense_aspect | tense_aspect_008 |
| honorific_005 | 돌아가시다 | tense_aspect | tense_aspect_009 |
| honorific_006 | 말씀하시다 | tense_aspect | tense_aspect_010 |
| honorific_007 | 드리다 | tense_aspect | tense_aspect_011 |
| honorific_008 | 여쭈다/여쭙다 | tense_aspect | tense_aspect_012 |
| honorific_009 | 뵙다 | tense_aspect | tense_aspect_013 |
| honorific_010 | 모시다 | tense_aspect | tense_aspect_014 |
| honorific_011 | 데리다 | tense_aspect | tense_aspect_015 |
| honorific_012 | 저/제 | substantive | substantive_050 |
| honorific_013 | 저희 | substantive | substantive_051 |
| honorific_014 | -(으)십시오 | sentence_ending | sentence_ending_015 |
| honorific_015 | -옵-/-사옵- | sentence_ending | sentence_ending_016 |

---

## 担当5: tense + negation + voice + irregular + adverb → 複数カテゴリへ分散

### 担当範囲: 65項目

#### tense（12項目）の移行先

| 旧ID | タイトル | 移行先カテゴリ | 新ID |
|------|---------|--------------|------|
| tense_001 | 現在形 | tense_aspect | tense_aspect_016 |
| tense_002 | 過去形 -았/었- | tense_aspect | tense_aspect_017 |
| tense_003 | 未来形 | tense_aspect | tense_aspect_018 |
| tense_004 | -겠- | tense_aspect | tense_aspect_019 |
| tense_005 | 進行相 | tense_aspect | tense_aspect_020 |
| tense_006 | 結果状態相 | tense_aspect | tense_aspect_021 |
| tense_007 | 大過去 | tense_aspect | tense_aspect_022 |
| tense_008 | 過去連体形 | adnominal | adnominal_002 |
| tense_009 | 非過去連体形 | adnominal | adnominal_003 |
| tense_010 | 未来連体形 | adnominal | adnominal_004 |
| tense_011 | 回想連体形1 | adnominal | adnominal_005 |
| tense_012 | 回想連体形2 | adnominal | adnominal_006 |

#### negation（7項目）→ tense_aspect

| 旧ID | 新ID |
|------|------|
| negation_001 | tense_aspect_023 |
| negation_002 | tense_aspect_024 |
| negation_003 | tense_aspect_025 |
| negation_004 | tense_aspect_026 |
| negation_005 | tense_aspect_027 |
| negation_006 | tense_aspect_028 |
| negation_007 | tense_aspect_029 |

#### voice（12項目）→ tense_aspect

| 旧ID | 新ID |
|------|------|
| voice_001 | tense_aspect_030 |
| voice_002 | tense_aspect_031 |
| ... | ... |
| voice_012 | tense_aspect_041 |

#### irregular（10項目）→ conjugation

| 旧ID | 新ID |
|------|------|
| irregular_001 | conjugation_001 |
| irregular_002 | conjugation_002 |
| ... | ... |
| irregular_010 | conjugation_010 |

#### adverb（24項目）→ word_formation + expression

| 旧ID | タイトル | 移行先カテゴリ | 新ID |
|------|---------|--------------|------|
| adverb_001-010 | 程度副詞等 | word_formation | word_formation_001-010 |
| adverb_011-014 | 様態副詞等 | word_formation | word_formation_011-014 |
| adverb_015-019 | 呼応副詞等 | expression | expression_041-045 |
| adverb_020-024 | その他副詞 | word_formation | word_formation_015-019 |

---

## interjection（12項目）- 削除

- ファイル: `interjection/interjection_001.json` ～ `interjection/interjection_012.json`
- **削除対象**: 移行せず、ディレクトリごと削除

---

## 注意事項

1. **relatedGrammarの更新**
   - 全てのファイルで`relatedGrammar`配列内の旧IDを新IDに更新すること

2. **tags配列**
   - そのまま維持（変更不要）

3. **順序（order）**
   - 新カテゴリ内での連番に更新

4. **fileパス**
   - `grammar_index.json`で使用するため、正しいパスで保存すること

5. **検証**
   - JSON構文エラーがないか確認
   - IDの重複がないか確認

---

## 最終的なカテゴリ別項目数（予定）

| カテゴリ | 項目数 |
|---------|--------|
| orthography | 0（新規作成のみ） |
| substantive | 51 |
| particle | 25 |
| conjugation | 10 |
| sentence_ending | 16 |
| connective | 23 |
| adnominal | 6 |
| tense_aspect | 41 |
| expression | 45 |
| quotation | 11 |
| word_formation | 19 |
| **合計** | **247** |

※ interjection 12項目削除、ending_027をconnectiveに移行
