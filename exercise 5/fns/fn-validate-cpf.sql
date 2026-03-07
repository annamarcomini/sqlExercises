CREATE OR REPLACE FUNCTION exercicio5.validate_cpf(p_cpf_input TEXT)
 RETURNS BOOLEAN AS $$
 LANGUAGE plpgsql IMMUTABLE
 DECLARE
    v_weights1 INT[] := ARRAY[10,9,8,7,6,5,4,3,2];
    v_weights2 INT[] := ARRAY[11,10,9,8,7,6,5,4,3,2];
    v_sum1 INT:= 0;
    v_sum2 INT:= 0;
    v_dig1 INT;
    v_dig2 INT;
 BEGIN

    -- Verifica tamanho
    IF length(p_cpf_input) <> 11 THEN
        RETURN FALSE;
    END IF;

    -- Rejeita CPFs com todos os dígitos iguais
    IF p_cpf_input ~ '^(\d)\1{10}$' THEN
        RETURN FALSE;
    END IF;

    -- Primeiro dígito
    FOR i IN 1..9 LOOP
        v_sum1 := v_sum1 + substring(p_cpf_input, i, 1)::INT * v_weights1[i];
    END LOOP;
    
    --pego o resto de v_sum1 divido por 11
    v_dig1 := (v_sum1 * 10) % 11;
    --se o resto de 10 então o valor de v_dig1 vai ficar como 0
    IF v_dig1 = 10 THEN v_dig1 := 0; END IF;
    --se v_dig1 calculado for diferente de (<>) do decimo digito que ta sendo inserido no banco barra o cpf
    IF v_dig1 <> substring(p_cpf_input,10,1)::INT THEN
        RETURN FALSE;
    END IF;

    -- Segundo dígito
    FOR i IN 1..10 LOOP
        v_sum2 := v_sum2 + substring(p_cpf_input, i, 1)::INT * v_weights2[i];
    END LOOP;


    v_dig2 := (v_sum2 * 10) % 11;
    IF v_dig2 = 10 THEN v_dig2 := 0; END IF;
    IF v_dig2 <> substring(p_cpf_input,11,1)::INT THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE;
 END;
$$;
