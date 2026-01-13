/*
  # Add Trigger to Handle Empty QR Code URLs
  
  This trigger converts empty strings to NULL for qr_code_url,
  as a backup in case the PostgREST API schema cache hasn't refreshed.
*/

-- Create function to convert empty strings to NULL
CREATE OR REPLACE FUNCTION normalize_qr_code_url()
RETURNS TRIGGER AS $$
BEGIN
  -- Convert empty strings to NULL
  IF NEW.qr_code_url = '' THEN
    NEW.qr_code_url := NULL;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
DROP TRIGGER IF EXISTS trigger_normalize_qr_code_url ON payment_methods;

CREATE TRIGGER trigger_normalize_qr_code_url
  BEFORE INSERT OR UPDATE ON payment_methods
  FOR EACH ROW
  EXECUTE FUNCTION normalize_qr_code_url();
