CREATE OR REPLACE FUNCTION
    exercicio7.fn_validate_strings (
        p_value TEXT,
        p_has_numbers BOOLEAN DEFAULT FALSE,
        p_has_letters BOOLEAN DEFAULT FALSE,
        p_has_special_chars BOOLEAN DEFAULT FALSE,
        p_has_spaces BOOLEAN DEFAULT FALSE,
        p_has_uppercase BOOLEAN DEFAULT FALSE,
        p_has_lowercase BOOLEAN DEFAULT FALSE,
        p_min_length INTEGER DEFAULT NULL,
        p_max_length INTEGER DEFAULT NULL
    ) RETURNS BOOLEAN
LANGUAGE plpgsql
IMMUTABLE
PARALLEL SAFE
AS $$
DECLARE
    v_length INTEGER;
BEGIN
    -- Null sempre é inválido
    IF p_value IS NULL THEN
        RETURN FALSE;
    END IF;

    v_length := length(p_value);

    -- 1. Validações de tamanho genéricas
    IF p_min_length IS NOT NULL AND v_length < p_min_length THEN
        RETURN FALSE;
    END IF;

    IF p_max_length IS NOT NULL AND v_length > p_max_length THEN
        RETURN FALSE;
    END IF;

    -- 2. Validações de composição de caracteres
    IF p_has_numbers AND NOT (p_value ~ '[0-9]') THEN
        RETURN FALSE;
    END IF;

    IF p_has_letters AND NOT (p_value ~ '[a-zA-Z]') THEN
        RETURN FALSE;
    END IF;

    IF p_has_special_chars AND NOT (p_value ~ '[^a-zA-Z0-9\s]') THEN
        RETURN FALSE;
    END IF;

    IF p_has_spaces AND NOT (p_value ~ '\s') THEN
        RETURN FALSE;
    END IF;

    IF p_has_uppercase AND NOT (p_value ~ '[A-Z]') THEN
        RETURN FALSE;
    END IF;

    IF p_has_lowercase AND NOT (p_value ~ '[a-z]') THEN
        RETURN FALSE;
    END IF;
    
    -- 3. Validação final - aceita se passou em todas as validações
    RETURN v_length > 0 AND v_length <= 10000;
END;
$$;