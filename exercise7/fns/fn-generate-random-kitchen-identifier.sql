CREATE OR REPLACE FUNCTION exercicio7.generate_random_identifier_3()
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    chars TEXT := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    result TEXT;
BEGIN
    LOOP
        result := '';

        FOR i IN 1..3 LOOP
            result := result || substr(
                chars,
                floor(random() * length(chars) + 1)::int,
                1
            );
        END LOOP;

        IF NOT EXISTS (
            SELECT 1
            FROM exercicio7.stations
            WHERE kitchen_identifier = result
        ) THEN
            RETURN result;
        END IF;
    END LOOP;
END;
$$;