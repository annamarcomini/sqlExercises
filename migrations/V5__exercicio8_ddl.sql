-- ======================================
-- TABELA DE PROPRIETÁRIOS
-- ======================================

CREATE TABLE IF NOT EXISTS exercicio8.owners (
    id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name          VARCHAR(150)  NOT NULL,
    email         VARCHAR(150)  NOT NULL,
    telephone     VARCHAR(20),
    password_hash VARCHAR(128)  NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ          DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS exercicio8.sellers (
    id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name          VARCHAR(150) NOT NULL,
    email         VARCHAR(150) NOT NULL,
    telephone     VARCHAR(20),
    password_hash VARCHAR(128) NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ          DEFAULT NULL
);

-- ======================================
-- TABELA DE CASAS
-- ======================================

CREATE TABLE IF NOT EXISTS exercicio8.houses (
    id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name    VARCHAR(150) NOT NULL,
    address VARCHAR(200) NOT NULL,

    start_day_purchase SMALLINT NOT NULL CHECK (start_day_purchase BETWEEN 1 AND 7),
    end_day_purchase   SMALLINT NOT NULL CHECK (end_day_purchase BETWEEN 1 AND 7),

    start_time_purchase TIME NOT NULL,
    end_time_purchase   TIME NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ          DEFAULT NULL
);

-- ============================================
-- ASSOCIATIVA N:N ENTRE PROPRIETÁRIOS E CASAS
-- ============================================

CREATE TABLE IF NOT EXISTS exercicio8.house_owner (
    id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    owner_id INTEGER NOT NULL,
    house_id INTEGER NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ          DEFAULT NULL,
    
    --declaração de chaves únicas
    CONSTRAINT exercicio8_house_owner_uq_owner_id_house_id UNIQUE (owner_id, house_id),

    --declaração de chaves estrangeiras
    CONSTRAINT fk_owner
    FOREIGN KEY (owner_id)
    REFERENCES exercicio8.owners(id),

    CONSTRAINT fk_house
    FOREIGN KEY (house_id)
    REFERENCES exercicio8.houses(id)
);

-- ======================================
-- CÔMODOS
-- ======================================

CREATE TABLE IF NOT EXISTS exercicio8.rooms (
    id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    house_id INTEGER      NOT NULL,
    name     VARCHAR(100) NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ          DEFAULT NULL,

    --declaração de chaves estrangeiras
    CONSTRAINT fk_house_room
    FOREIGN KEY (house_id)
    REFERENCES exercicio8.houses(id)
);

-- ======================================
-- MÓVEIS
-- ======================================

CREATE TABLE IF NOT EXISTS exercicio8.furniture (
    id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    house_id    INTEGER         NOT NULL,
    room_id     INTEGER         NOT NULL,
    name        VARCHAR(120)    NOT NULL,
    description VARCHAR(2000)   NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ          DEFAULT NULL,
    
    --declaração de chaves estrangeiras
    CONSTRAINT fk_furniture_house
    FOREIGN KEY (house_id)
    REFERENCES exercicio8.houses(id),

    CONSTRAINT fk_furniture_room
    FOREIGN KEY (room_id)
    REFERENCES exercicio8.rooms(id)
);

-- ======================================
-- VENDAS
-- ======================================

CREATE TABLE IF NOT EXISTS exercicio8.sales (
    id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    seller_id    INTEGER          NOT NULL,
    owner_id     INTEGER          NOT NULL,
    house_id     INTEGER          NOT NULL,
    furniture_id INTEGER          NOT NULL,
    value        NUMERIC(12,2)    NOT NULL,
    sale_date    TIMESTAMPTZ      NOT NULL DEFAULT CURRENT_TIMESTAMP,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ          DEFAULT NULL,
    
    --declaração de chaves estrangeiras
    CONSTRAINT fk_owner_sale
    FOREIGN KEY (owner_id)
    REFERENCES exercicio8.owners(id),

    CONSTRAINT fk_house_sale
    FOREIGN KEY (house_id)
    REFERENCES exercicio8.houses(id),

    CONSTRAINT fk_furniture_sale
    FOREIGN KEY (furniture_id)
    REFERENCES exercicio8.furniture(id),

    CONSTRAINT fk_seller_sale
    FOREIGN KEY(seller_id)
    REFERENCES exercicio8.sellers(id)
);