-- COMPLETE VERIFICATION AND FIX
-- Run this entire script in Supabase SQL Editor

-- Step 1: Check ALL payment_methods table constraints
SELECT 
  conname as constraint_name,
  contype as constraint_type,
  pg_get_constraintdef(oid) as constraint_definition
FROM pg_constraint 
WHERE conrelid = 'payment_methods'::regclass
ORDER BY contype, conname;

-- Step 2: Check column definition
SELECT 
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'payment_methods' 
  AND column_name = 'qr_code_url';

-- Step 3: Force remove NOT NULL (run this even if it says it's already nullable)
ALTER TABLE public.payment_methods 
ALTER COLUMN qr_code_url DROP NOT NULL;

-- Step 4: Double-check by altering the column type (forces schema refresh)
ALTER TABLE public.payment_methods 
ALTER COLUMN qr_code_url TYPE text;

-- Step 5: Verify again
SELECT 
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'payment_methods' 
  AND column_name = 'qr_code_url';

-- Step 6: Test insert with NULL (this should work now)
INSERT INTO payment_methods (id, name, account_number, account_name, qr_code_url, active, sort_order, admin_name) 
VALUES ('test-null-check', 'Test Null Check', '123', 'Tester', NULL, true, 1, 'test') 
ON CONFLICT (admin_name, id) DO NOTHING
RETURNING *;

-- Step 7: Clean up test record
DELETE FROM payment_methods WHERE id = 'test-null-check' AND admin_name = 'test';
