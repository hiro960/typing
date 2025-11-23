# 分析機能仕様書 (Analysis Feature Specifications)

## 概要
ユーザーの学習データを分析し、学習効率を向上させるための「詳細な分析レポート」機能の仕様です。
以下の3つの主要な指標を可視化します。

1.  **苦手なキー (Weak Keys)**
2.  **成長推移 (Growth Trends)**
3.  **学習習慣 (Learning Habits)**

## データソース
全てのデータは既存の `LessonCompletion` モデルから取得可能です。

-   **Model**: `LessonCompletion` (Prisma)
-   **Fields**:
    -   `wpm`: Int (成長推移)
    -   `accuracy`: Float (成長推移)
    -   `mistakeCharacters`: Json? (苦手なキー)
    -   `completedAt`: DateTime (学習習慣、成長推移)

## 機能詳細

### 1. 苦手なキー (Weak Keys)
ユーザーが頻繁に間違えるキーを特定し、ランキング形式またはヒートマップで表示します。

*   **ロジック**:
    *   指定期間（例: 直近30日、全期間）の `LessonCompletion` レコードを取得。
    *   各レコードの `mistakeCharacters` (Map<String, int>) を集計。
    *   ミス回数の多い順にソート。
*   **表示**:
    *   Top 5 ワーストキーの表示。
    *   キーボードレイアウト上のヒートマップ（赤色が濃いほどミスが多い）。

### 2. 成長推移 (Growth Trends)
学習の継続によるスキルの向上をグラフで可視化します。

*   **ロジック**:
    *   `LessonCompletion` レコードを `completedAt` の昇順で取得。
    *   日ごと、または週ごとの平均 `WPM` と `Accuracy` を計算。
*   **表示**:
    *   折れ線グラフ (Line Chart)。
    *   X軸: 日付
    *   Y軸 (左): WPM
    *   Y軸 (右): Accuracy (%)

### 3. 学習習慣 (Learning Habits)
ユーザーがいつ学習しているかの傾向を分析し、習慣化を支援します。

*   **ロジック**:
    *   `LessonCompletion` レコードの `completedAt` を使用。
    *   **時間帯別**: 0時〜23時の各時間帯での完了レッスン数を集計。
    *   **曜日別**: 月〜日の各曜日での完了レッスン数を集計。
*   **表示**:
    *   棒グラフ (Bar Chart) または レーダーチャート。
    *   「朝型」「夜型」などのタイプ判定も可能。

## API設計案

新しく `AnalysisController` (または `AnalysisService`) を作成し、以下のエンドポイントを提供することを推奨します。

### `GET /api/analysis/dashboard`
ダッシュボード表示用に全ての分析データをまとめて取得します。

**Query Parameters:**
- `period`: 'week' | 'month' | 'all' (デフォルト: 'month')

**Response:**
```json
{
  "weakKeys": [
    { "key": "ㄹ", "count": 45 },
    { "key": "aa", "count": 32 }
  ],
  "trends": [
    { "date": "2023-10-01", "wpm": 120, "accuracy": 95.5 },
    { "date": "2023-10-02", "wpm": 125, "accuracy": 96.0 }
  ],
  "habits": {
    "byHour": [0, 0, ..., 5, 10, ...], // 24時間の配列
    "byDayOfWeek": [10, 15, ..., 20] // 日〜土の配列
  }
}
```

## 実装フェーズ

1.  **Backend**:
    *   `AnalysisService` の作成: Prisma を使用して集計クエリを実装。
    *   API エンドポイントの実装。
2.  **Frontend**:
    *   `AnalysisRepository` の作成。
    *   UI コンポーネントの実装 (Charts ライブラリの選定が必要、例: `fl_chart`)。
    *   「分析」タブまたは画面の追加。
