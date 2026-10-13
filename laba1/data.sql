begin; --откатик--

insert into warehouses (name, address) values
    ('Основной склад', 'Мацква, Проектируемый проезд, 1'),
    ('Резервный склад', 'Мацква, Проектируемый проезд, 2');

insert into categories (name) values
    ('Мебель'),
    ('Электроника'),
    ('Канцелярия');

insert into products (sku, name, category_id)
select v.sku, v.name, c.id
from (values
    ('CHAIR-001', 'Офисный стул', 'Мебель'),
    ('DESK-001', 'Письменный стол', 'Мебель'),
    ('MONITOR-001', 'Монитор, 24 дюйма', 'Электроника'),
    ('KEYBOARD-001', 'Клавиатура', 'Электроника'),
    ('PAPER-001', 'Бумага А4, пачка', 'Канцелярия')
) as v(sku, name, category_name)
join categories c on c.name = v.category_name;

insert into suppliers (name, email, phone) values
    ('МебельПлюс', 'furniture@example.com', '+79000000001'),
    ('ТехноСнаб', 'tech@example.com', '+79000000002'),
    ('ОфисМаркет', 'office@example.com', '+79000000003');

with new_deliveries as (
    insert into deliveries (warehouse_id, supplier_id, delivered_at)
    select w.id, s.id, v.delivered_at
    from (values
        ('Мацква, Проектируемый проезд, 1', 'furniture@example.com', timestamp '2026-10-01 10:00:00'),
        ('Мацква, Проектируемый проезд, 1', 'tech@example.com', timestamp '2026-10-02 11:00:00'),
        ('Мацква, Проектируемый проезд, 2', 'office@example.com', timestamp '2026-10-03 12:00:00'),
        ('Мацква, Проектируемый проезд, 2', 'furniture@example.com', timestamp '2026-10-04 10:00:00')
    ) as v(address, email, delivered_at)
    join warehouses w on w.address = v.address
    join suppliers s on s.email = v.email
    returning id, delivered_at
)
insert into delivery_items (delivery_id, product_id, quantity, unit_price)
select d.id, p.id, v.quantity, v.unit_price
from (values
    (timestamp '2026-10-01 10:00:00', 'CHAIR-001', 20, 4500.00),
    (timestamp '2026-10-01 10:00:00', 'DESK-001', 10, 12000.00),
    (timestamp '2026-10-02 11:00:00', 'MONITOR-001', 15, 18000.00),
    (timestamp '2026-10-02 11:00:00', 'KEYBOARD-001', 30, 1500.00),
    (timestamp '2026-10-03 12:00:00', 'PAPER-001', 100, 350.00),
    (timestamp '2026-10-04 10:00:00', 'CHAIR-001', 5, 4600.00),
    (timestamp '2026-10-04 10:00:00', 'DESK-001', 3, 12500.00)
) as v(delivered_at, sku, quantity, unit_price)
join new_deliveries d on d.delivered_at = v.delivered_at
join products p on p.sku = v.sku;

insert into stocks (warehouse_id, product_id, quantity)
select d.warehouse_id, i.product_id, sum(i.quantity)::integer
from deliveries d
join delivery_items i on i.delivery_id = d.id
group by d.warehouse_id, i.product_id;

insert into stocks (warehouse_id, product_id, quantity)
select w.id, p.id, 0
from warehouses w
cross join products p
where w.address = 'Мацква, Проектируемый проезд, 2'
  and p.sku = 'MONITOR-001';

commit;
