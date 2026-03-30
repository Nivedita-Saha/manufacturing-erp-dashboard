CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100),
    country VARCHAR(50),
    created_at DATE DEFAULT CURRENT_DATE
);

CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100),
    country VARCHAR(50),
    lead_time_days INT
);

CREATE TABLE parts (
    part_id SERIAL PRIMARY KEY,
    part_name VARCHAR(100) NOT NULL,
    part_code VARCHAR(20) UNIQUE NOT NULL,
    unit_cost NUMERIC(10,2),
    stock_quantity INT DEFAULT 0,
    supplier_id INT REFERENCES suppliers(supplier_id)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE DEFAULT CURRENT_DATE,
    due_date DATE,
    status VARCHAR(20) CHECK (status IN ('Pending','In Progress','Completed','Cancelled')),
    total_value NUMERIC(12,2)
);

CREATE TABLE work_orders (
    work_order_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    part_id INT REFERENCES parts(part_id),
    quantity_required INT,
    quantity_produced INT DEFAULT 0,
    assigned_to VARCHAR(100),
    start_date DATE,
    end_date DATE,
    status VARCHAR(20) CHECK (status IN ('Pending','In Progress','Completed'))
);

CREATE TABLE production_runs (
    run_id SERIAL PRIMARY KEY,
    work_order_id INT REFERENCES work_orders(work_order_id),
    run_date DATE DEFAULT CURRENT_DATE,
    units_produced INT,
    defects INT DEFAULT 0,
    machine_id VARCHAR(20),
    operator VARCHAR(100)
);
