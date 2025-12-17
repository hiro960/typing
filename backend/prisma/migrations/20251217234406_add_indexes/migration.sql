-- DropIndex
DROP INDEX "Bookmark_userId_idx";

-- DropIndex
DROP INDEX "ExchangeRate_baseCurrency_targetCurrency_idx";

-- DropIndex
DROP INDEX "LessonCompletion_userId_idx";

-- DropIndex
DROP INDEX "User_auth0UserId_idx";

-- DropIndex
DROP INDEX "User_email_idx";

-- DropIndex
DROP INDEX "User_username_idx";

-- DropIndex
DROP INDEX "wordbooks_userId_idx";

-- CreateIndex
CREATE INDEX "Bookmark_userId_createdAt_idx" ON "Bookmark"("userId", "createdAt");

-- CreateIndex
CREATE INDEX "Comment_postId_createdAt_idx" ON "Comment"("postId", "createdAt");

-- CreateIndex
CREATE INDEX "LessonCompletion_userId_completedAt_idx" ON "LessonCompletion"("userId", "completedAt");

-- CreateIndex
CREATE INDEX "LessonCompletion_userId_lessonId_idx" ON "LessonCompletion"("userId", "lessonId");

-- CreateIndex
CREATE INDEX "wordbooks_userId_status_idx" ON "wordbooks"("userId", "status");

-- CreateIndex
CREATE INDEX "wordbooks_userId_category_idx" ON "wordbooks"("userId", "category");
