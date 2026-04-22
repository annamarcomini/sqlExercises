CREATE FUNCTION exercicio7.fn_validate_blank_strings(txt TEXT)
RETURNS BOOLEAN
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT trim(txt) <> '';
$$;