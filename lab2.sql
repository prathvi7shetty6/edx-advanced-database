/*
1) Write a SELECT statement that answers this question: Which products have a list price that’s greater than the average list price for all products?
Return the prodcut_id, product_name and list_price columns for each product.
Sort the result set by the list_price column in descending sequence.
*/
SELECT product_id, product_name, list_price
FROM products
WHERE list_price > (
SELECT AVG(list_price)
FROM products)
ORDER BY list_price DESC;

/*
2) Write a SELECT statement that returns three columns: email_address, order_id, and the order total for each
customer. To do this, you can group the result set by the email_address and order_id columns. In addition,
you must calculate the order total from the columns in the Order_Items table.

Write a second SELECT statement that uses the first SELECT statement in its FROM clause. The main query should return
three columns: the customer’s email address and the largest order (aliased as max_order_total) and the smallest order_id
(aliased as min_order_id). To do this, you can group the result set by the email_address. Sort the result set by the largest
order in descending sequence.

Using mysql 5.7
*/
SELECT email_address, MAX(order_total) AS max_order_total,
MIN(order_id) AS min_order_id
FROM (
  SELECT email_address, o.order_id AS order_id, (item_price * quantity) AS order_total
  FROM customers as c JOIN orders as o
  ON c.customer_id = o.customer_id
  JOIN order_items as ot
  ON ot.order_id = o.order_id
  GROUP BY email_address, order_id
 ) AS customer_details
 GROUP BY email_address

/*
 3) Write a SELECT statement that returns the name, list_price and discount percent of each product that has a unique discount percent. In other words, don’t include products that have the same discount percent as another product.
Sort the result set by the product_name column.
*/
SELECT p.product_name, list_price, discount_percent 
FROM products p
WHERE discount_percent NOT IN (
SELECT discount_percent
FROM products WHERE product_id <> p.product_id)
ORDER BY product_name

/*
4) Use a correlated subquery to return one row per customer, representing the customer’s oldest order (the one with the earliest date). Each row should include these three columns: email_address, oldest_order_id, and oldest_order_date. Only include customers who have placed an order.
Sort the result set by the oldest_order_date and oldest_order_id columns.
*/
SELECT email_address, order_id AS oldest_order_id, order_date AS oldest_order_date
FROM customers natural join orders
WHERE  order_date = (
SELECT MIN(order_date)
FROM orders o
WHERE customers.customer_id = o.customer_id
) 
