begin;

do $$
declare
    first_product integer;
    second_product integer;
    existing_sku text;
    existing_delivery integer;
    delivered_product integer;
    existing_warehouse integer;
    stocked_product integer;
begin
    select id, sku into first_product, existing_sku
    from products order by id limit 1;

    select id into second_product
    from products where id <> first_product order by id limit 1;

    select delivery_id, product_id into existing_delivery, delivered_product
    from delivery_items order by delivery_id, product_id limit 1;

    select warehouse_id, product_id into existing_warehouse, stocked_product
    from stocks order by warehouse_id, product_id limit 1;

    if second_product is null or existing_delivery is null
       or existing_warehouse is null then
        raise exception 'Сначала заполните базу через data.sql';
    end if;

    if exists (select 1 from categories where id = -1) then
        raise exception 'Для теста внешнего ключа category_id = -1 должен отсутствовать';
    end if;

    -- 1. Артикул другого товара нарушает unique.
    begin
        update products set sku = existing_sku where id = second_product;
        raise exception 'Тест 1 провален: повторный артикул принят';
    exception when unique_violation then
        raise notice 'Тест 1 пройден: unique запрещает повторный артикул';
    end;

    -- 2. Название товара обязательно.
    begin
        update products set name = null where id = first_product;
        raise exception 'Тест 2 провален: пустое название принято';
    exception when not_null_violation then
        raise notice 'Тест 2 пройден: not null запрещает отсутствие названия';
    end;

    -- 3. Товар нельзя привязать к несуществующей категории.
    begin
        update products set category_id = -1 where id = first_product;
        raise exception 'Тест 3 провален: несуществующая категория принята';
    exception when foreign_key_violation then
        raise notice 'Тест 3 пройден: внешний ключ проверяет наличие категории';
    end;

    -- 4. Количество в поставке должно быть положительным.
    begin
        update delivery_items set quantity = 0
        where delivery_id = existing_delivery and product_id = delivered_product;
        raise exception 'Тест 4 провален: нулевое количество в поставке принято';
    exception when check_violation then
        raise notice 'Тест 4 пройден: check запрещает нулевое количество в поставке';
    end;

    -- 5. Цена должна быть положительной.
    begin
        update delivery_items set unit_price = -100
        where delivery_id = existing_delivery and product_id = delivered_product;
        raise exception 'Тест 5 провален: отрицательная цена принята';
    exception when check_violation then
        raise notice 'Тест 5 пройден: check запрещает отрицательную цену';
    end;

    -- 6. Остаток не может быть отрицательным.
    begin
        update stocks set quantity = -1
        where warehouse_id = existing_warehouse and product_id = stocked_product;
        raise exception 'Тест 6 провален: отрицательный остаток принят';
    exception when check_violation then
        raise notice 'Тест 6 пройден: check запрещает отрицательный остаток';
    end;

    -- 7. Пара склад + товар уже существует: составной ключ запрещает повтор.
    begin
        insert into stocks (warehouse_id, product_id, quantity)
        values (existing_warehouse, stocked_product, 1);
        raise exception 'Тест 7 провален: повторная пара склад + товар принята';
    exception when unique_violation then
        raise notice 'Тест 7 пройден: составной primary key запрещает повтор пары';
    end;
end;
$$;

rollback;
