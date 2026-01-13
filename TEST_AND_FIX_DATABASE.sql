-- TEST AND FIX DATABASE CONSTRAINT
-- Run this in Supabase SQL Editor

-- Step 1: Check current state
SELECT 
  'Current State:' as info,
  column_name,
  is_nullable,
  data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'payment_methods' 
  AND column_name = 'qr_code_url';

-- Step 2: Try to insert NULL directly (this will tell us if constraint is really gone)
-- First, let's see if we can insert NULL
DO $$
DECLARE
  test_result text;
BEGIN
  BEGIN
    INSERT INTO payment_methods (id, name, account_number, account_name, qr_code_url, active, sort_order, admin_name) 
    VALUES ('direct-null-test', 'Direct Null Test', '123', 'Tester', NULL, true, 1, 'test')
    ON CONFLICT (admin_name, id) DO UPDATE SET qr_code_url = NULL;
    
    test_result := 'SUCCESS: NULL was accepted!';
    RAISE NOTICE '%', test_result;
    
    -- Clean up
    DELETE FROM payment_methods WHERE id = 'direct-null-test' AND admin_name = 'test';
    
  EXCEPTION
    WHEN not_null_violation THEN
      test_result := 'FAILED: NOT NULL constraint still exists!';
      RAISE NOTICE '%', test_result;
      
      -- Try to fix it
      BEGIN
        ALTER TABLE public.payment_methods 
        ALTER COLUMN qr_code_url DROP NOT NULL;
        
        RAISE NOTICE 'Attempted to drop NOT NULL constraint';
      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'Could not drop constraint: %', SQLERRM;
      END;
      
  END;
END $$;

-- Step 3: Force remove constraint (run this regardless)
ALTER TABLE public.payment_methods 
ALTER COLUMN qr_code_url DROP NOT NULL;

-- Step 4: Verify final state
SELECT 
  'Final State:' as info,
  column_name,
  is_nullable,
  data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'payment_methods' 
  AND column_name = 'qr_code_url';
