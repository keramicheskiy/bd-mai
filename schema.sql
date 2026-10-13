
create table warehouses (
    id integer generated always as identity primary key, 
    name text not null,
    address text not null
);

create table categories(
    id integer generated always as identity primary key, 
    name text not null unique
);

create table products(
    id integer generated always as identity primary key,
    sku text not null unique, --артикул товара--
    name text not null, 
    category_id integer not null references categories(id)
);

create table suppliers(
    id integer generated always as identity primary key,
    name text not null,
    email text not null unique,
    phone text not null unique
);

create table deliveries(
    id integer generated always as identity primary key,
    warehouse_id integer not null references warehouses(id),
    supplier_id integer not null references suppliers(id),
    delivered_at timestamp not null default current_timestamp
);

create table delivery_items(
    delivery_id integer not null references deliveries(id) on delete cascade,
    product_id integer not null references products(id) on delete restrict,
    quantity integer not null check (quantity > 0),
    unit_price decimal(10,2) not null check (unit_price > 0),
    primary key (delivery_id, product_id)
);

create table stocks(
    warehouse_id integer not null references warehouses(id),
    product_id integer not null references products(id),
    quantity integer not null check (quantity >= 0),
    primary key (warehouse_id, product_id)
);

