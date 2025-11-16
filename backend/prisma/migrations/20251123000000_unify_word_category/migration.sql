-- AlterEnum
ALTER TYPE "WordCategory" RENAME TO "WordCategory_old";

CREATE TYPE "WordCategory" AS ENUM ('WORDS', 'SENTENCES');

ALTER TABLE "wordbooks"
  ALTER COLUMN "category" TYPE "WordCategory"
  USING (
    CASE "category"::text
      WHEN 'MY_WORDS' THEN 'WORDS'
      ELSE 'SENTENCES'
    END
  )::"WordCategory";

ALTER TABLE "wordbooks"
  ALTER COLUMN "category" SET DEFAULT 'WORDS';

DROP TYPE "WordCategory_old";
