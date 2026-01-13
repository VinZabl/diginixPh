-- DIRECT FIX - Run this in Supabase SQL Editor
-- This will definitely remove the NOT NULL constraint

-- Step 1: Check what we're working with
SELECT 
  table_schema,
  table_name,
  column_name,
  is_nullable,
  data_type
FROM information_schema.columns
WHERE table_name = 'payment_methods' 
  AND column_name = 'qr_code_url';

-- Step 2: Remove NOT NULL constraint (run this even if it says it's already nullable)
ALTER TABLE public.payment_methods 
ALTER COLUMN qr_code_url DROP NOT NULL;

-- Step 3: Verify it worked
SELECT 
  table_schema,
  table_name,
  column_name,
  is_nullable,
  data_type
FROM information_schema.columns
WHERE table_name = 'payment_methods' 
  AND column_name = 'qr_code_url';

-- If is_nullable is still 'NO', try this alternative:
-- (Uncomment if needed)
/*
DO $$
BEGIN
  -- Recreate the column as nullable
  ALTER TABLE public.payment_methods 
  ALTER COLUMN qr_code_url TYPE text;
  
  ALTER TABLE public.payment_methods 
  ALTER COLUMN qr_code_url DROP NOT NULL;
  
  RAISE NOTICE 'Column is now nullable';
END $$;
*/
