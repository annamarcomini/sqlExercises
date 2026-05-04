CREATE FUNCTION exercicio7.fn_validate_blank_strings(p_txt TEXT)
RETURNS BOOLEAN
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT trim(p_txt) <> '';
$$;