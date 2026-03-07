CREATE OR REPLACE FUNCTION exercicio5.generate_product_code()
 RETURNS TEXT
 LANGUAGE SQL
 VOLATILE
 AS $$
  SELECT string_agg(
    substr(
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
      (random() * 61)::int + 1,
      1
    ),
    ''
  )
  FROM generate_series(1, 8);
$$;