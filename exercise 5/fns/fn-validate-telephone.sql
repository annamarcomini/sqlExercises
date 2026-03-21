CREATE OR REPLACE FUNCTION exercicio5.validate_telephone(p_telephone_input TEXT)
 RETURNS BOOLEAN 
 LANGUAGE PLPGSQL IMMUTABLE
 AS $$
 BEGIN

    IF length(p_telephone_input) NOT IN (10, 11) THEN
        RETURN FALSE;
    END IF;

    IF p_telephone_input ~ '^(\d)\1+$' THEN
        RETURN FALSE;
    END IF;

    IF p_telephone_input !~ '^(?:[1-9]{2})(?:9\d{8}|[2-5]\d{7})$' THEN
        RETURN FALSE;
    END IF;

    IF NOT (
        substring(p_telephone_input, 1, 2)::INT = ANY (
            ARRAY[
                11,12,13,14,15,16,17,18,19,
                21,22,24,
                27,28,
                31,32,33,34,35,37,38,
                41,42,43,44,45,46,
                47,48,49,
                51,53,54,55,
                61,
                62,64,
                63,
                65,66,
                67,
                68,
                69,
                71,73,74,75,77,
                79,
                81,87,
                82,
                83,
                84,
                85,88,
                86,89,
                91,93,94,
                92,97,
                95,
                96,
                98,99
            ]
        )
        ) THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE;
    
 END;
$$;
