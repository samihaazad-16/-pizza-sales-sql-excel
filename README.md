# Pizza Shop Sales Analysis

This portfolio project uses SQLite and Excel to answer three questions\. How did revenue change month to month? Which products and categories brought in the most revenue? How did delivery, pickup and walk\-in sales compare?

The dataset represents a fictional pizza shop from January through June 2025\. It contains 469 orders and 913 order lines\. Revenue is quantity × unit price, before tax, tips and fees\. Orders are counted by unique order ID\.

## Results

- The shop generated **$12,087\.80** across **469 orders**, for an average order value of **$25\.77**\.
- June was the strongest month at **$2,801\.45**, up **22\.1%** from May\. Order volume increased from **91 to 105** over the same period\.
- Pizza generated **73\.2%** of revenue\. Pepperoni Pizza led all products at **$3,645\.72**\.
- Delivery led the channels with **$5,302\.10** across **204 orders**\.

## Open the project

1. Open `Pizza_Sales_Dashboard.xlsx` to see the dashboard, the saved SQL results and the joined order\-line data\.
2. Open `results/sales.sqlite` in DB Browser for SQLite\. In the Execute SQL tab, try `SELECT * FROM monthly_sales ORDER BY month;` and compare the output with the dashboard\. The views are already in the database\.
3. Read `analysis.sql` to see how the views were built\. The project uses joins, grouped totals, distinct counts, a common table expression and a ranking function\.

## Reproduce the analysis

Run `python run_analysis.py` from the extracted project folder using Python 3\. On systems where Python is available as `python3`, use `python3 run_analysis.py`\. The script reads the three source CSVs in `data/`, creates the SQLite database, checks row counts, and exports CSVs to `results/`\.

The Excel workbook contains a saved import of those results\. Its formulas calculate average order value, month\-over\-month revenue changes and category revenue share\. The SQL Results tab also uses Excel to multiply line quantities by unit prices and compare the total with SQL revenue\.

For the supplied data, rerunning the script reproduces the saved workbook inputs\. If you change the data, replace the corresponding blocks on SQL Results and Order Lines with the new exports\. The workbook is sized for the supplied six months, categories, products, channels and order lines\. Extend the formulas and chart ranges if those dimensions change\.
