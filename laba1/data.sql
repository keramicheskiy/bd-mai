BEGIN;

INSERT INTO warehouses (name, address)
VALUES
    ('Основной склад', 'Мацква, Проектируемый проезд, 1'),
    ('Резервный склад', 'Мацква, Проектируемый проезд, 2');

INSERT INTO categories (name)
VALUES
    ('Мебель'),
    ('Электроника'),
    ('Канцелярия');

INSERT INTO products (sku, name, category_id)
VALUES
    (
        'CHAIR-001',
        'Офисный стул',
        (SELECT id FROM categories WHERE name = 'Мебель')
    ),
    (
        'DESK-001',
        'Письменный стол',
        (SELECT id FROM categories WHERE name = 'Мебель')
    ),
    (
        'MONITOR-001',
        'Монитор, 24 дюйма',
        (SELECT id FROM categories WHERE name = 'Электроника')
    ),
    (
        'KEYBOARD-001',
        'Клавиатура',
        (SELECT id FROM categories WHERE name = 'Электроника')
    ),
    (
        'PAPER-001',
        'Бумага А4, пачка',
        (SELECT id FROM categories WHERE name = 'Канцелярия')
    );

INSERT INTO suppliers (name, email, phone)
VALUES
    ('МебельПлюс', 'furniture@example.com', '+79000000001'),
    ('ТехноСнаб', 'tech@example.com', '+79000000002'),
    ('ОфисМаркет', 'office@example.com', '+79000000003');

INSERT INTO deliveries (warehouse_id, supplier_id, delivered_at)
VALUES
    (
        (SELECT id FROM warehouses WHERE address = 'Мацква, Проектируемый проезд, 1'),
        (SELECT id FROM suppliers WHERE email = 'furniture@example.com'),
        TIMESTAMP '2026-10-01 10:00:00'
    ),
    (
        (SELECT id FROM warehouses WHERE address = 'Мацква, Проектируемый проезд, 1'),
        (SELECT id FROM suppliers WHERE email = 'tech@example.com'),
        TIMESTAMP '2026-10-02 11:00:00'
    ),
    (
        (SELECT id FROM warehouses WHERE address = 'Мацква, Проектируемый проезд, 2'),
        (SELECT id FROM suppliers WHERE email = 'office@example.com'),
        TIMESTAMP '2026-10-03 12:00:00'
    ),
    (
        (SELECT id FROM warehouses WHERE address = 'Мацква, Проектируемый проезд, 2'),
        (SELECT id FROM suppliers WHERE email = 'furniture@example.com'),
        TIMESTAMP '2026-10-04 10:00:00'
    );

INSERT INTO delivery_items (delivery_id, product_id, quantity, unit_price)
VALUES
    (
        (SELECT id FROM deliveries WHERE delivered_at = '2026-10-01 10:00:00'),
        (SELECT id FROM products WHERE sku = 'CHAIR-001'),
        20,
        4500.00
    ),
    (
        (SELECT id FROM deliveries WHERE delivered_at = '2026-10-01 10:00:00'),
        (SELECT id FROM products WHERE sku = 'DESK-001'),
        10,
        12000.00
    ),
    (
        (SELECT id FROM deliveries WHERE delivered_at = '2026-10-02 11:00:00'),
        (SELECT id FROM products WHERE sku = 'MONITOR-001'),
        15,
        18000.00
    ),
    (
        (SELECT id FROM deliveries WHERE delivered_at = '2026-10-02 11:00:00'),
        (SELECT id FROM products WHERE sku = 'KEYBOARD-001'),
        30,
        1500.00
    ),
    (
        (SELECT id FROM deliveries WHERE delivered_at = '2026-10-03 12:00:00'),
        (SELECT id FROM products WHERE sku = 'PAPER-001'),
        100,
        350.00
    ),
    (
        (SELECT id FROM deliveries WHERE delivered_at = '2026-10-04 10:00:00'),
        (SELECT id FROM products WHERE sku = 'CHAIR-001'),
        5,
        4600.00
    ),
    (
        (SELECT id FROM deliveries WHERE delivered_at = '2026-10-04 10:00:00'),
        (SELECT id FROM products WHERE sku = 'DESK-001'),
        3,
        12500.00
    );

INSERT INTO stocks (warehouse_id, product_id, quantity)
VALUES
    (
        (SELECT id FROM warehouses WHERE address = 'Мацква, Проектируемый проезд, 1'),
        (SELECT id FROM products WHERE sku = 'CHAIR-001'),
        20
    ),
    (
        (SELECT id FROM warehouses WHERE address = 'Мацква, Проектируемый проезд, 1'),
        (SELECT id FROM products WHERE sku = 'DESK-001'),
        10
    ),
    (
        (SELECT id FROM warehouses WHERE address = 'Мацква, Проектируемый проезд, 1'),
        (SELECT id FROM products WHERE sku = 'MONITOR-001'),
        15
    ),
    (
        (SELECT id FROM warehouses WHERE address = 'Мацква, Проектируемый проезд, 1'),
        (SELECT id FROM products WHERE sku = 'KEYBOARD-001'),
        30
    ),
    (
        (SELECT id FROM warehouses WHERE address = 'Мацква, Проектируемый проезд, 2'),
        (SELECT id FROM products WHERE sku = 'PAPER-001'),
        100
    ),
    (
        (SELECT id FROM warehouses WHERE address = 'Мацква, Проектируемый проезд, 2'),
        (SELECT id FROM products WHERE sku = 'CHAIR-001'),
        5
    ),
    (
        (SELECT id FROM warehouses WHERE address = 'Мацква, Проектируемый проезд, 2'),
        (SELECT id FROM products WHERE sku = 'DESK-001'),
        3
    ),
    (
        (SELECT id FROM warehouses WHERE address = 'Мацква, Проектируемый проезд, 2'),
        (SELECT id FROM products WHERE sku = 'MONITOR-001'),
        0
    );

COMMIT;
