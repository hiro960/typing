-- CreateTable
CREATE TABLE "PronunciationGameResult" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "difficulty" "RankingGameDifficulty" NOT NULL,
    "score" INTEGER NOT NULL,
    "correctCount" INTEGER NOT NULL,
    "maxCombo" INTEGER NOT NULL,
    "totalBonusTime" INTEGER NOT NULL,
    "characterLevel" INTEGER NOT NULL,
    "timeSpent" INTEGER,
    "accuracy" DOUBLE PRECISION,
    "playedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PronunciationGameResult_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "PronunciationGameResult_userId_idx" ON "PronunciationGameResult"("userId");

-- CreateIndex
CREATE INDEX "PronunciationGameResult_difficulty_idx" ON "PronunciationGameResult"("difficulty");

-- CreateIndex
CREATE INDEX "PronunciationGameResult_score_idx" ON "PronunciationGameResult"("score");

-- CreateIndex
CREATE INDEX "PronunciationGameResult_playedAt_idx" ON "PronunciationGameResult"("playedAt");

-- CreateIndex
CREATE INDEX "PronunciationGameResult_difficulty_playedAt_score_idx" ON "PronunciationGameResult"("difficulty", "playedAt", "score");

-- AddForeignKey
ALTER TABLE "PronunciationGameResult" ADD CONSTRAINT "PronunciationGameResult_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
