-- CreateEnum
CREATE TYPE "WordStatus" AS ENUM ('MASTERED', 'REVIEWING', 'NEEDS_REVIEW');

-- CreateEnum
CREATE TYPE "WordCategory" AS ENUM ('MY_WORDS', 'EXAMPLES', 'IDIOMS');

-- CreateTable
CREATE TABLE "wordbooks" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "word" TEXT NOT NULL,
    "meaning" TEXT NOT NULL,
    "example" TEXT,
    "status" "WordStatus" NOT NULL DEFAULT 'REVIEWING',
    "category" "WordCategory" NOT NULL DEFAULT 'MY_WORDS',
    "lastReviewedAt" TIMESTAMP(3),
    "reviewCount" INTEGER NOT NULL DEFAULT 0,
    "successRate" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "tags" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "wordbooks_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "wordbooks_userId_idx" ON "wordbooks"("userId");

-- CreateIndex
CREATE INDEX "wordbooks_category_idx" ON "wordbooks"("category");

-- CreateIndex
CREATE INDEX "wordbooks_status_idx" ON "wordbooks"("status");

-- AddForeignKey
ALTER TABLE "wordbooks" ADD CONSTRAINT "wordbooks_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
