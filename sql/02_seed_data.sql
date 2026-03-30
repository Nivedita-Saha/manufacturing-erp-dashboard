INSERT INTO customers (customer_name, contact_email, country) VALUES
('Hargreaves Industrial', 'orders@hargreaves.co.uk', 'United Kingdom'),
('Delta Engineering GmbH', 'procurement@delta-eng.de', 'Germany'),
('Apex Manufacturing Inc', 'supply@apexmfg.com', 'United States'),
('Nordic Precision AB', 'info@nordicprecision.se', 'Sweden'),
('Castillo Mecánica', 'compras@castillomec.es', 'Spain');

INSERT INTO suppliers (supplier_name, contact_email, country, lead_time_days) VALUES
('SteelCore Supplies', 'sales@steelcore.co.uk', 'United Kingdom', 7),
('PrecisionParts GmbH', 'orders@precisionparts.de', 'Germany', 14),
('AlloyTech Ltd', 'info@alloytech.co.uk', 'United Kingdom', 5),
('FastenerPro Inc', 'sales@fastenerpro.com', 'United States', 10),
('MetalWorks Europe', 'supply@metalworkseu.com', 'Netherlands', 12);

INSERT INTO parts (part_name, part_code, unit_cost, stock_quantity, supplier_id) VALUES
('Steel Shaft 20mm', 'SHF-020', 12.50, 340, 1),
('Aluminium Housing', 'ALH-001', 45.00, 120, 3),
('Bearing Assembly', 'BRG-104', 28.75, 200, 2),
('Hex Bolt M12', 'HBT-M12', 0.85, 5000, 4),
('Precision Gear 40T', 'GER-040', 67.20, 85, 2),
('Stainless Bracket', 'BKT-SS1', 18.30, 410, 1),
('Drive Belt 500mm', 'BLT-500', 22.00, 150, 5),
('Control Valve', 'VLV-CTL', 95.00, 60, 3);

INSERT INTO orders (customer_id, order_date, due_date, status, total_value) VALUES
(1, '2025-01-10', '2025-02-10', 'Completed', 15200.00),
(2, '2025-01-18', '2025-02-28', 'Completed', 8750.00),
(3, '2025-02-05', '2025-03-15', 'In Progress', 22400.00),
(4, '2025-02-20', '2025-03-30', 'In Progress', 11600.00),
(1, '2025-03-01', '2025-04-01', 'Pending', 9800.00),
(5, '2025-03-10', '2025-04-20', 'Pending', 31500.00),
(2, '2024-11-15', '2024-12-15', 'Completed', 6400.00),
(3, '2024-12-01', '2025-01-05', 'Cancelled', 4200.00);

INSERT INTO work_orders (order_id, part_id, quantity_required, quantity_produced, assigned_to, start_date, end_date, status) VALUES
(1, 1, 200, 200, 'James Patel', '2025-01-12', '2025-02-08', 'Completed'),
(1, 3, 100, 100, 'Sarah Okafor', '2025-01-12', '2025-02-06', 'Completed'),
(2, 5, 80, 80, 'James Patel', '2025-01-20', '2025-02-25', 'Completed'),
(3, 2, 150, 90, 'Tom Brennan', '2025-02-07', NULL, 'In Progress'),
(3, 7, 120, 60, 'Sarah Okafor', '2025-02-10', NULL, 'In Progress'),
(4, 6, 300, 300, 'James Patel', '2025-02-22', '2025-03-20', 'Completed'),
(4, 4, 1000, 500, 'Tom Brennan', '2025-02-22', NULL, 'In Progress'),
(5, 8, 50, 0, 'Sarah Okafor', '2025-03-05', NULL, 'Pending'),
(6, 1, 400, 0, 'James Patel', '2025-03-12', NULL, 'Pending'),
(7, 3, 90, 90, 'Tom Brennan', '2024-11-18', '2024-12-12', 'Completed');

INSERT INTO production_runs (work_order_id, run_date, units_produced, defects, machine_id, operator) VALUES
(1, '2025-01-13', 50, 2, 'MCH-01', 'James Patel'),
(1, '2025-01-20', 75, 1, 'MCH-01', 'James Patel'),
(1, '2025-01-27', 75, 0, 'MCH-02', 'James Patel'),
(2, '2025-01-13', 100, 3, 'MCH-03', 'Sarah Okafor'),
(3, '2025-01-21', 80, 4, 'MCH-02', 'James Patel'),
(4, '2025-02-08', 45, 1, 'MCH-01', 'Tom Brennan'),
(4, '2025-02-15', 45, 0, 'MCH-03', 'Tom Brennan'),
(5, '2025-02-11', 60, 5, 'MCH-02', 'Sarah Okafor'),
(6, '2025-02-23', 150, 2, 'MCH-01', 'James Patel'),
(6, '2025-03-01', 150, 1, 'MCH-01', 'James Patel'),
(7, '2025-02-23', 250, 8, 'MCH-03', 'Tom Brennan'),
(10, '2024-11-19', 90, 2, 'MCH-02', 'Tom Brennan');
