-- FINAL FIX WITH API SCHEMA REFRESH
-- Run this in Supabase SQL Editor

-- Step 1: Check for any triggers that might enforce NOT NULL
SELECT 
  trigger_name,
  event_manipulation,
  action_statement
FROM information_schema.triggers
WHERE event_object_table = 'payment_methods';

-- Step 2: Check for any check constraints
SELECT 
  conname as constraint_name,
  pg_get_constraintdef(oid) as constraint_definition
FROM pg_constraint 
WHERE conrelid = 'payment_methods'::regclass
  AND contype = 'c';

-- Step 3: Force remove NOT NULL (multiple methods)
DO $$
BEGIN
  -- Method 1: Direct drop
  BEGIN
    ALTER TABLE public.payment_methods 
    ALTER COLUMN qr_code_url DROP NOT NULL;
    RAISE NOTICE 'Method 1: Dropped NOT NULL';
  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'Method 1 failed: %', SQLERRM;
  END;
  
  -- Method 2: Alter type then drop
  BEGIN
    ALTER TABLE public.payment_methods 
    ALTER COLUMN qr_code_url TYPE text;
    
    ALTER TABLE public.payment_methods 
    ALTER COLUMN qr_code_url DROP NOT NULL;
    RAISE NOTICE 'Method 2: Dropped NOT NULL via type change';
  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'Method 2 failed: %', SQLERRM;
  END;
END $$;

-- Step 4: Verify column is nullable
SELECT 
  column_name,
  is_nullable,
  data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'payment_methods' 
  AND column_name = 'qr_code_url';

-- Step 5: Test direct insert with NULL
INSERT INTO payment_methods (id, name, account_number, account_name, qr_code_url, active, sort_order, admin_name) 
VALUES ('api-test-null', 'API Test Null', '123', 'Tester', NULL, true, 1, 'test')
ON CONFLICT (admin_name, id) DO UPDATE SET qr_code_url = NULL
RETURNING id, name, qr_code_url;

-- Step 6: Clean up test
DELETE FROM payment_methods WHERE id = 'api-test-null' AND admin_name = 'test';

-- Step 7: Refresh PostgREST schema cache (if possible)
-- Note: This might require Supabase dashboard action or API call
NOTIFY pgrst, 'reload schema';
