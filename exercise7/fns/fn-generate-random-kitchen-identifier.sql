CREATE OR REPLACE FUNCTION generate_random_identifier_3()
RETURNS TEXT AS $$
$$ LANGUAGE plpgsql;
DECLARE
  chars TEXT := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  result TEXT := '';
BEGIN
  FOR i IN 1..3 LOOP
    result := result || substr(chars, floor(random() * length(chars) + 1)::int, 1);
  END LOOP;
  RETURN result;
END;