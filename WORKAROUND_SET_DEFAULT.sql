-- WORKAROUND: Set a default value for qr_code_url
-- This allows inserts to work even if PostgREST thinks it's required
-- The trigger will convert empty strings to NULL

-- Set default to empty string (which trigger will convert to NULL)
ALTER TABLE public.payment_methods 
ALTER COLUMN qr_code_url SET DEFAULT '';

-- Make sure the trigger exists
CREATE OR REPLACE FUNCTION normalize_qr_code_url()
RETURNS TRIGGER AS $$
BEGIN
  -- Convert empty strings to NULL
  IF NEW.qr_code_url = '' OR NEW.qr_code_url IS NULL THEN
    NEW.qr_code_url := NULL;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_normalize_qr_code_url ON payment_methods;

CREATE TRIGGER trigger_normalize_qr_code_url
  BEFORE INSERT OR UPDATE ON payment_methods
  FOR EACH ROW
  EXECUTE FUNCTION normalize_qr_code_url();

-- Verify
SELECT 
  column_name,
  is_nullable,
  column_default
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'payment_methods' 
  AND column_name = 'qr_code_url';
