CREATE OR REPLACE FUNCTION exercicio7.fn_validate_email(
    p_value TEXT
) RETURNS BOOLEAN
IMMUTABLE
PARALLEL SAFE
LANGUAGE SQL
AS $$
    SELECT p_value IS NOT NULL 
    AND p_value ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+$'
    AND length(p_value) <= 255
    AND length(split_part(p_value, '@', 1)) <= 64
    AND length(split_part(p_value, '@', 2)) <= 191;
$$;