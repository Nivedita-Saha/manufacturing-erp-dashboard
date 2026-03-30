# Manufacturing ERP Dashboard

A full-stack ERP reporting system simulating manufacturing operations data management and business intelligence reporting. Built to demonstrate SQL Server-level querying skills, ERP data modelling, and parameterised report generation — directly applicable to ERP development roles in manufacturing and engineering environments.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Database | PostgreSQL 16 (SQL Server-compatible syntax) |
| Backend | Python 3.12 + Flask |
| Reporting | Parameterised SQL queries via psycopg2 |
| Frontend | Jinja2 templates |

---

## Database Schema

Six relational tables modelling a precision manufacturing company:

- **customers** — client organisations placing production orders
- **suppliers** — parts suppliers with lead time tracking
- **parts** — inventory items with stock levels and unit costs
- **orders** — customer orders with due dates and status tracking
- **work_orders** — production tasks linked to orders and parts
- **production_runs** — individual machine runs with defect tracking

---

## SQL Techniques Demonstrated

### CTEs (Common Table Expressions)
- Order summary report with multi-table joins across customers, orders, and work_orders
- Stock risk analysis combining parts, suppliers, and work order demand

### Window Functions
- `RANK()` to rank orders by value across the full dataset
- `SUM() OVER (PARTITION BY ...)` for running revenue totals per customer
- Percentage of total revenue calculation using windowed aggregation

### Multi-Table Joins
- 4-table joins across production_runs, work_orders, parts, and suppliers
- LEFT JOINs to preserve parts with no active work orders

### Aggregation
- Defect rate percentage per operator and machine
- Projected stock remaining after fulfilling all active work orders
- Average units per production run with NULL-safe division

---

## Reports

### Order Report (`/orders`)
CTE-based report showing all customer orders with delivery status, work order count, and units produced. Includes a status filter (Pending / In Progress / Completed / Cancelled).

### Production Performance Report (`/production`)
Aggregated defect rate analysis by operator and machine. Colour-coded defect rate badges highlight performance issues at a glance.

### Stock Risk Report (`/stock`)
Advanced CTE + window function report ranking parts by stock risk. Flags Critical items where demand exceeds supply, with supplier lead times to inform replenishment decisions.

---

## Running Locally
```bash
# Start PostgreSQL
/opt/homebrew/opt/postgresql@16/bin/pg_ctl -D /opt/homebrew/var/postgresql@16 -l /opt/homebrew/var/postgresql@16/logfile start

# Clone and set up
git clone https://github.com/Nivedita-Saha/manufacturing-erp-dashboard.git
cd manufacturing-erp-dashboard
python3 -m venv venv
source venv/bin/activate
pip install flask psycopg2-binary

# Create and seed the database
createdb manufacturing_db
psql manufacturing_db < sql/01_schema.sql
psql manufacturing_db < sql/02_seed_data.sql

# Run the app
python app.py
```

Then open `http://127.0.0.1:5000` in your browser.

---

## Project Structure
```
manufacturing-erp-dashboard/
├── app.py                  # Flask app and SQL report queries
├── templates/
│   ├── base.html           # Shared layout and navigation
│   ├── index.html          # Dashboard home page
│   ├── orders.html         # Order report with filter
│   ├── production.html     # Production performance report
│   └── stock.html          # Stock risk report
└── sql/
    ├── 01_schema.sql       # Table definitions
    ├── 02_seed_data.sql    # Sample manufacturing data
    └── 03_reports.sql      # Standalone SQL report queries
```

---

## Key ERP Concepts Modelled

- Order lifecycle management (Pending → In Progress → Completed)
- Work order assignment and progress tracking
- Parts inventory with supplier lead time awareness
- Production run logging with defect rate monitoring
- Stock risk classification (Critical / Low / Moderate / Healthy)
