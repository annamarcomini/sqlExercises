
-- ============================================
-- polices owners
-- ============================================

--- owners veem os proprios cadastros
CREATE POLICY select_owners
  ON exercicio8.owners
  FOR SELECT
  TO owners
  USING (
    id = current_setting('app.owner_id')::integer
  );

--- owners podem atualizar seus proprios cadastros
CREATE POLICY update_owners
  ON exercicio8.owners
  FOR UPDATE
  TO owners
   USING (
    id = current_setting('app.owner_id')::integer
  )
  WITH CHECK (
    id = current_setting('app.owner_id')::integer
  );

--- owners podem ver apenas as casas que possuem
CREATE POLICY owners_select_houses
  ON exercicio8.houses
  FOR SELECT
  TO owners
  USING (
    deleted_at IS NULL
    AND id IN (
      SELECT house_id 
      FROM exercicio8.house_owner 
      WHERE owner_id = current_setting('app.owner_id')::integer
       AND deleted_at IS NULL
    )
  );

--- owners podem inserir casas
CREATE POLICY owners_insert_houses
  ON exercicio8.houses
  FOR INSERT
  TO owners
  WITH CHECK (true);

--- owners podem atualizar apenas as casas que possuem
CREATE POLICY owners_update_houses
  ON exercicio8.houses
  FOR UPDATE
  TO owners
  USING (
    deleted_at IS NULL
    AND id IN (
      SELECT house_id 
      FROM exercicio8.house_owner 
      WHERE owner_id = current_setting('app.owner_id')::integer
       AND deleted_at IS NULL
    )
  )
   WITH CHECK (
    id IN (SELECT house_id FROM exercicio8.house_owner WHERE owner_id = current_setting('app.owner_id')::integer)
  );

--- owners podem ver móveis
CREATE POLICY select_furniture_owners
  ON exercicio8.furniture
  FOR SELECT
  TO owners
  USING (true);

--- owners podem ver comodos
CREATE POLICY select_rooms_owners
  ON exercicio8.rooms
  FOR SELECT
  TO owners
  USING (true);

-- ============================================
-- polices sellers
-- ============================================

--- sellers veem os proprios cadastros
CREATE POLICY select_sellers
  ON exercicio8.sellers
  FOR SELECT
  TO sellers
  USING (
    id = current_setting('app.seller_id')::integer
  );

--- sellers podem atualizar seus proprios cadastros
CREATE POLICY update_sellers
  ON exercicio8.sellers
  FOR UPDATE
  TO sellers
   USING (
    id = current_setting('app.seller_id')::integer
  )
  WITH CHECK (
    id = current_setting('app.seller_id')::integer
  );

--- sellers podem ver todas as casas
CREATE POLICY sellers_select_houses
  ON exercicio8.houses
  FOR SELECT
  TO sellers
  USING (true);
 
--- sellers podem atualizar todas as casas
CREATE POLICY sellers_update_houses
  ON exercicio8.houses
  FOR UPDATE
  TO sellers
  USING (true)
  WITH CHECK (true);

--- sellers podem inserir casas
CREATE POLICY sellers_insert_houses
  ON exercicio8.houses
  FOR INSERT
  TO sellers
  WITH CHECK (true);

--- sellers podem ver vinculos entre casas e proprietarios
CREATE POLICY sellers_select_house_owner
  ON exercicio8.house_owner
  FOR SELECT
  TO sellers
  USING (true);

--- sellers podem atualizar vinculos entre casas e proprietarios
CREATE POLICY sellers_update_house_owner
  ON exercicio8.house_owner
  FOR UPDATE
  TO sellers
  USING (true)
  WITH CHECK (true);

--- sellers podem inserir vinculos entre casas e proprietarios e não se pode vincular um proprietário a mais de 5 casas
CREATE POLICY sellers_insert_house_owner
  ON exercicio8.house_owner
  FOR INSERT
  TO sellers
  WITH CHECK (
    (
        SELECT COUNT(*)
        FROM exercicio8.house_owner ho
        JOIN exercicio8.houses h
            ON h.id = ho.house_id
        WHERE ho.owner_id = owner_id
          AND ho.deleted_at IS NULL
          AND h.deleted_at IS NULL
    ) < 5
  );

--- sellers podem ver vendas
CREATE POLICY sellers_select_sales
  ON exercicio8.sales
  FOR SELECT
  TO sellers
  USING (true);

--- sellers podem atualizar vendas
CREATE POLICY sellers_update_sales
  ON exercicio8.sales
  FOR UPDATE
  TO sellers
  USING (true)
  WITH CHECK (true);

--- sellers não pode vender moveis e casas que não existem e fora da janela de compra da casa
CREATE POLICY sales_insert
  ON exercicio8.sales
  FOR INSERT
  TO sellers
  WITH CHECK (
 
    EXISTS (
        SELECT 1
        FROM exercicio8.houses h
        WHERE h.id = house_id
          AND h.deleted_at IS NULL
    )

    AND

    EXISTS (
        SELECT 1
        FROM exercicio8.furniture f
        WHERE f.id = furniture_id
          AND f.deleted_at IS NULL
    )
    AND

    EXISTS (
    SELECT 1
    FROM exercicio8.houses h
    WHERE h.id = house_id
      AND EXTRACT(ISODOW FROM CURRENT_TIMESTAMP)
            BETWEEN h.start_day_purchase
                AND h.end_day_purchase
      AND CURRENT_TIME
            BETWEEN h.start_time_purchase
                AND h.end_time_purchase
   )
  );

--- sellers podem ver moveis
CREATE POLICY sellers_select_furniture
  ON exercicio8.furniture
  FOR SELECT
  TO sellers
  USING (true);

--- sellers podem atualizar moveis
CREATE POLICY sellers_update_furniture
  ON exercicio8.furniture
  FOR UPDATE
  TO sellers
  USING (true)
  WITH CHECK (true);

--- sellers podem associar apenas 6 moveis a um comodo e garante que o comodo exista naquele id da casa inserido e não em outro id de casa
CREATE POLICY sellers_max_six_furniture
  ON exercicio8.furniture
  FOR INSERT
  TO sellers
  WITH CHECK (
    (
        SELECT COUNT(*)
        FROM exercicio8.furniture f
        WHERE f.room_id = room_id
          AND f.deleted_at IS NULL
    ) < 6

    AND 

    EXISTS (
        SELECT 1
        FROM exercicio8.rooms r
        WHERE r.id = room_id
          AND r.house_id = house_id
          AND r.deleted_at IS NULL
    )

    AND 

    (
        SELECT COUNT(*)
        FROM exercicio8.furniture f
        WHERE f.house_id = house_id
          AND f.deleted_at IS NULL
    ) < 35
   );

--- sellers podem ver comodos
CREATE POLICY sellers_select_rooms
  ON exercicio8.rooms
  FOR SELECT
  TO sellers
  USING (true);

--- sellers podem atualizar comodos
CREATE POLICY sellers_update_rooms
  ON exercicio8.rooms
  FOR UPDATE
  TO sellers
  USING (true)
  WITH CHECK (true);

--- sellers podem inserir comodos
CREATE POLICY sellers_insert_rooms
  ON exercicio8.rooms
  FOR INSERT
  TO sellers
  WITH CHECK (true);
