INSERT INTO categories (name)
VALUES ('Мебель');

INSERT INTO products (sku, name, category_id)
VALUES (
    'CHAIR-001',
    'Другой офисный стул',
    (SELECT id FROM categories WHERE name = 'Мебель')
);

INSERT INTO suppliers (name, email, phone)
VALUES (
    'Другой поставщик',
    'furniture@example.com',
    '+79000000099'
);

INSERT INTO suppliers (name, email, phone)
VALUES (
    'Другой поставщик',
    'other-supplier@example.com',
    '+79000000001'
);

INSERT INTO products (sku, name, category_id)
VALUES (
    'TEST-NULL-NAME',
    NULL,
    (SELECT id FROM categories WHERE name = 'Мебель')
);

INSERT INTO products (sku, name, category_id)
VALUES ('TEST-NO-CATEGORY', 'Тестовый товар', -1);

UPDATE delivery_items
SET quantity = 0
WHERE (delivery_id, product_id) = (
    SELECT delivery_id, product_id
    FROM delivery_items
    ORDER BY delivery_id, product_id
    LIMIT 1
);

UPDATE delivery_items
SET unit_price = -100.00
WHERE (delivery_id, product_id) = (
    SELECT delivery_id, product_id
    FROM delivery_items
    ORDER BY delivery_id, product_id
    LIMIT 1
);

UPDATE stocks
SET quantity = -1
WHERE (warehouse_id, product_id) = (
    SELECT warehouse_id, product_id
    FROM stocks
    ORDER BY warehouse_id, product_id
    LIMIT 1
);

INSERT INTO delivery_items (delivery_id, product_id, quantity, unit_price)
SELECT delivery_id, product_id, 1, 100.00
FROM delivery_items
ORDER BY delivery_id, product_id
LIMIT 1;

INSERT INTO stocks (warehouse_id, product_id, quantity)
SELECT warehouse_id, product_id, 1
FROM stocks
ORDER BY warehouse_id, product_id
LIMIT 1;

DELETE FROM products
WHERE id = (
    SELECT product_id
    FROM delivery_items
    ORDER BY delivery_id, product_id
    LIMIT 1
);
