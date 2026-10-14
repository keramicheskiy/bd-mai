BEGIN;

CREATE TABLE warehouses (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    name TEXT NOT NULL,
    address TEXT NOT NULL
);

CREATE TABLE categories(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE products(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sku TEXT NOT NULL UNIQUE, --артикул товара--
    name TEXT NOT NULL, 
    category_id INTEGER NOT NULL REFERENCES categories(id)
);

CREATE TABLE suppliers(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    phone TEXT NOT NULL UNIQUE
);

CREATE TABLE deliveries(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    warehouse_id INTEGER NOT NULL REFERENCES warehouses(id),
    supplier_id INTEGER NOT NULL REFERENCES suppliers(id),
    delivered_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE delivery_items(
    delivery_id INTEGER NOT NULL REFERENCES deliveries(id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price > 0),
    PRIMARY KEY (delivery_id, product_id)
);

CREATE TABLE stocks(
    warehouse_id INTEGER NOT NULL REFERENCES warehouses(id),
    product_id INTEGER NOT NULL REFERENCES products(id),
    quantity INTEGER NOT NULL CHECK (quantity >= 0),
    PRIMARY KEY (warehouse_id, product_id)
);

COMMIT;