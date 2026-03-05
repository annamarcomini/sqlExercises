CREATE OR REPLACE FUNCTION validate_cnpj(cnpj_input TEXT)
 RETURNS BOOLEAN AS $$
 DECLARE
    weights1 INT[] := ARRAY[5,4,3,2,9,8,7,6,5,4,3,2];
    weights2 INT[] := ARRAY[6,5,4,3,2,9,8,7,6,5,4,3,2];
    i INT;
    sum1 INT:= 0;
    sum2 INT:= 0;
    dig1 INT;
    dig2 INT;
 BEGIN

    IF length(cnpj_input) <> 14 THEN
        RETURN FALSE;
    END IF;

    -- Rejeita números repetidos
    IF cnpj_input ~ '^(\d)\1{13}$' THEN
        RETURN FALSE;
    END IF;

    -- Primeiro dígito
    FOR i IN 1..12 LOOP
        sum1 := sum1 + substring(cnpj_input, i, 1)::INT * weights1[i];
    END LOOP;

    dig1 := sum1 % 11;
    dig1 := CASE WHEN dig1 < 2 THEN 0 ELSE 11 - dig1 END;

    IF dig1 <> substring(cnpj_input,13,1)::INT THEN
        RETURN FALSE;
    END IF;

    -- Segundo dígito
    FOR i IN 1..13 LOOP
        sum2 := sum2 + substring(cnpj_input, i, 1)::INT * weights2[i];
    END LOOP;

    dig2 := sum2 % 11;
    dig2 := CASE WHEN dig2 < 2 THEN 0 ELSE 11 - dig2 END;

    IF dig2 <> substring(cnpj_input,14,1)::INT THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE;
 END;
$$ LANGUAGE plpgsql IMMUTABLE;