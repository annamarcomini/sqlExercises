CREATE OR REPLACE FUNCTION exercicio5.validate_cnpj(p_cnpj_input TEXT)
 RETURNS BOOLEAN AS $$
 LANGUAGE plpgsql IMMUTABLE
 DECLARE
    v_v_weights1 INT[] := ARRAY[5,4,3,2,9,8,7,6,5,4,3,2];
    v_weights2 INT[] := ARRAY[6,5,4,3,2,9,8,7,6,5,4,3,2];
    v_i INT;
    v_sum1 INT:= 0;
    v_sum2 INT:= 0;
    v_dig1 INT;
    v_dig2 INT;
 BEGIN

    IF length(p_cnpj_input) <> 14 THEN
        RETURN FALSE;
    END IF;

    -- Rejeita números repetidos
    IF p_cnpj_input ~ '^(\d)\1{13}$' THEN
        RETURN FALSE;
    END IF;

    -- Primeiro dígito
    FOR v_i IN 1..12 LOOP
        v_sum1 := v_sum1 + substring(p_cnpj_input, v_i, 1)::INT * v_weights1[v_i];
    END LOOP;

    v_dig1 := v_sum1 % 11;
    v_dig1 := CASE WHEN v_dig1 < 2 THEN 0 ELSE 11 - v_dig1 END;

    IF v_dig1 <> substring(p_cnpj_input,13,1)::INT THEN
        RETURN FALSE;
    END IF;

    -- Segundo dígito
    FOR v_i IN 1..13 LOOP
        v_sum2 := v_sum2 + substring(p_cnpj_input, v_i, 1)::INT * v_weights2[v_i];
    END LOOP;

    v_dig2 := v_sum2 % 11;
    v_dig2 := CASE WHEN v_dig2 < 2 THEN 0 ELSE 11 - v_dig2 END;

    IF v_dig2 <> substring(p_cnpj_input,14,1)::INT THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE;
 END;
$$;