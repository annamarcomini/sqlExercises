CREATE OR REPLACE FUNCTION validate_cpf(cpf_input TEXT)
 RETURNS BOOLEAN AS $$
 DECLARE
    weights1 INT[] := ARRAY[10,9,8,7,6,5,4,3,2];
    weights2 INT[] := ARRAY[11,10,9,8,7,6,5,4,3,2];
    sum1 INT:= 0;
    sum2 INT:= 0;
    dig1 INT;
    dig2 INT;
 BEGIN

    -- Verifica tamanho
    IF length(cpf_input) <> 11 THEN
        RETURN FALSE;
    END IF;

    -- Rejeita CPFs com todos os dígitos iguais
    IF cpf_input ~ '^(\d)\1{10}$' THEN
        RETURN FALSE;
    END IF;

    -- Primeiro dígito
    FOR i IN 1..9 LOOP
        sum1 := sum1 + substring(cpf_input, i, 1)::INT * weights1[i];
    END LOOP;
    
    --pego o resto de sum1 divido por 11
    dig1 := (sum1 * 10) % 11;
    --se o resto de 10 então o valor de dig1 vai ficar como 0
    IF dig1 = 10 THEN dig1 := 0; END IF;
    --se dig1 calculado for diferente de (<>) do decimo digito que ta sendo inserido no banco barra o cpf
    IF dig1 <> substring(cpf_input,10,1)::INT THEN
        RETURN FALSE;
    END IF;

    -- Segundo dígito
    FOR i IN 1..10 LOOP
        sum2 := sum2 + substring(cpf_input, i, 1)::INT * weights2[i];
    END LOOP;


    dig2 := (sum2 * 10) % 11;
    IF dig2 = 10 THEN dig2 := 0; END IF;
    IF dig2 <> substring(cpf_input,11,1)::INT THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE;
 END;
$$ LANGUAGE plpgsql IMMUTABLE;
