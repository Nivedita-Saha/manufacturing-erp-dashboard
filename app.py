import psycopg2
from flask import Flask, render_template, request
from psycopg2.extras import RealDictCursor

app = Flask(__name__)

def get_db():
    return psycopg2.connect(
        dbname="manufacturing_db",
        user="niveditasaha",
        host="localhost",
        port="5432"
    )

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/orders")
def orders():
    status = request.args.get("status", "")
    conn = get_db()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    query = """
        WITH order_summary AS (
            SELECT o.order_id, c.customer_name, o.order_date, o.due_date,
                   o.status, o.total_value,
                   COUNT(w.work_order_id) AS total_work_orders,
                   SUM(w.quantity_produced) AS total_units_produced
            FROM orders o
            JOIN customers c ON o.customer_id = c.customer_id
            LEFT JOIN work_orders w ON o.order_id = w.order_id
            GROUP BY o.order_id, c.customer_name, o.order_date,
                     o.due_date, o.status, o.total_value
        )
        SELECT *,
            CASE WHEN status = 'Completed' THEN 'On Time'
                 WHEN status = 'Cancelled' THEN 'Cancelled'
                 WHEN due_date < CURRENT_DATE THEN 'Overdue'
                 ELSE 'In Progress'
            END AS delivery_status
        FROM order_summary
        {where}
        ORDER BY order_date DESC
    """
    if status:
        cur.execute(query.format(where="WHERE status = %s"), (status,))
    else:
        cur.execute(query.format(where=""))
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return render_template("orders.html", rows=rows, status=status)

@app.route("/production")
def production():
    conn = get_db()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("""
        SELECT pr.operator, pr.machine_id,
               COUNT(pr.run_id) AS total_runs,
               SUM(pr.units_produced) AS total_units,
               SUM(pr.defects) AS total_defects,
               ROUND(SUM(pr.defects)::NUMERIC /
                     NULLIF(SUM(pr.units_produced), 0) * 100, 2) AS defect_rate_pct,
               ROUND(AVG(pr.units_produced), 1) AS avg_units_per_run
        FROM production_runs pr
        JOIN work_orders w ON pr.work_order_id = w.work_order_id
        JOIN parts p ON w.part_id = p.part_id
        GROUP BY pr.operator, pr.machine_id
        ORDER BY defect_rate_pct DESC
    """)
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return render_template("production.html", rows=rows)

@app.route("/stock")
def stock():
    conn = get_db()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("""
        WITH stock_usage AS (
            SELECT p.part_id, p.part_name, p.part_code, p.stock_quantity,
                   p.unit_cost, s.supplier_name, s.lead_time_days,
                   SUM(w.quantity_required) AS total_required
            FROM parts p
            LEFT JOIN work_orders w ON p.part_id = w.part_id
            LEFT JOIN suppliers s ON p.supplier_id = s.supplier_id
            GROUP BY p.part_id, p.part_name, p.part_code,
                     p.stock_quantity, p.unit_cost,
                     s.supplier_name, s.lead_time_days
        ),
        ranked AS (
            SELECT *,
                stock_quantity - COALESCE(total_required, 0) AS projected_remaining,
                RANK() OVER (ORDER BY stock_quantity ASC) AS stock_rank,
                ROUND(stock_quantity * unit_cost, 2) AS stock_value,
                CASE
                    WHEN stock_quantity - COALESCE(total_required, 0) < 0 THEN 'Critical'
                    WHEN stock_quantity < 100 THEN 'Low'
                    WHEN stock_quantity < 300 THEN 'Moderate'
                    ELSE 'Healthy'
                END AS stock_status
            FROM stock_usage
        )
        SELECT part_code, part_name, supplier_name, lead_time_days,
               stock_quantity, total_required, projected_remaining,
               stock_value, stock_status, stock_rank
        FROM ranked
        ORDER BY stock_rank
    """)
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return render_template("stock.html", rows=rows)

if __name__ == "__main__":
    app.run(debug=True)
