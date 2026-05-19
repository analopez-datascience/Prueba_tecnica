--Ana Belén López Pérez, prueba técnica para Amaris Consulting

--1.	Número de compras realizadas por cliente ordenado por el número de compres.

SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS numero_de_compras
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY numero_de_compras DESC;

--2.	Cantidad de productos por pedido.

SELECT 
    order_id AS pedido,
   	SUM(quantity) AS cantidad_productos_comprados
	--COUNT(product_id) AS total_productos_distintos *(entendemos que se refiere a la cantidad total de productos y no a la cantidad de diferentes productos)
FROM orderlines
GROUP BY order_id
ORDER BY order_id ASC;

--3.	Ingreso (€) por cliente ordenado por cliente que más ingreso ha generado.

-- OPCIÓN A: si nuestra tabla orders incluyese el total_amount la query seria la siguiente: 
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS ingreso_total_por_cliente
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY ingreso_total_por_cliente DESC;

-- OPCIÓN B: quizás en nuestra tabla orders no tenemos el total_amount y entonces debemos hacer un joins más, uniendo nuestra tabla customers con la tabla orders y de ahí unir a orderlines:

SELECT 
    c.customer_id,
    c.customer_name,
    SUM(ol.quantity * ol.price_per_unit) AS ingreso_total_por_cliente
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN orderlines ol ON o.order_id = ol.order_id
GROUP BY c.customer_id, c.customer_name
ORDER BY ingreso_total_por_cliente DESC;

--4.	Comprobar con una query si todos los usuarios que la tabla 'customers' han realizado un pedido (tabla orderlines).
-- Al encontrar null podemos afirmar que no todos los clientes que están registrado en nuestra base de datos han realizado pedidos

SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN orderlines ol ON o.order_id = ol.order_id
WHERE ol.orderline_id IS NULL;

--5.	Calcula el listado de los 10 productos con menos unidades vendidas (hint: incluye productos sin ventas).
-- Utilizamos un Left join para asegurarnos que nos va a devolver los productos que no han tenido ventas y lo sacamos por pantalla con el coalesce para que salga como 0.

SELECT 
    p.product_id,
    p.product_name,
    COALESCE(SUM(ol.quantity), 0) AS unidades_vendidas
FROM products p
LEFT JOIN orderlines ol ON p.product_id = ol.product_id
GROUP BY p.product_id, p.product_name
ORDER BY unidades_vendidas ASC
LIMIT 10;


--6.	Calcula un listado de clientes que tienen cesta media (facturación divida en número de pedidos) inferior a la cesta media de su género.
-- Para esta query vamos a dar por hecho que tenemos el total_amount en la tabla orders

SELECT 
    c.customer_id,
    c.customer_name,
    c.gender,
    AVG(o.total_amount) AS cesta_media_cliente,
	
-- Metemos una subconsulta dónde calculamos la cesta media dependiendo del genero del cliente
    (SELECT AVG(o2.total_amount)
     FROM customers c2
     INNER JOIN orders o2 ON c2.customer_id = o2.customer_id
     WHERE c2.gender = c.gender) AS cesta_media_genero

FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.gender

--Finalment nos quedamos con los que están por debajo de la media
HAVING AVG(o.total_amount) < (
    SELECT AVG(o2.total_amount)
    FROM customers c2
    INNER JOIN orders o2 ON c2.customer_id = o2.customer_id
    WHERE c2.gender = c.gender
)
ORDER BY c.gender, cesta_media_cliente ASC;


--7.	Calcula la recency de compra (días desde la última compra) para todos los clientes con compra.
-- Aqui vamos a aplicar la formula para el motor de base de datos que se indicaba en el enunciado (PostgreSQL), al día de hoy le restamos el día "mas reciente" de compra,
-- también utilizamos el inner para asegurarnos que solo sacamos los datos de clientes que si han comprado. 

SELECT 
    c.customer_id,
    c.customer_name,
    MAX(o.order_date) AS fecha_ultima_compra,
  	CURRENT_DATE - MAX(o.order_date) AS dias_desde_ultima_compra 
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY dias_desde_ultima_compra ASC;

--8.	Haz un ranking de pedidos por cada customer_id, y quedate luego con el primer order_id. ¿Para que puede ser util hacer esta consulta?
-- Esta consulta es útil para saber en que momento se captó ese cliente, cuántos años lleva siendo cliente de cara a utilizarlo para campañas de marketing 
-- por ejemplo, o medir el éxito de las diferentes campañas en un periodo de tiempo. 
-- Para este query propongo una subconsulta para sacar el ranking de las fechas de las compras, y luego quedarnos solo con la primera posición. 

SELECT 
    customer_id,
    order_id,
    order_date
FROM (
    SELECT 
        o.customer_id,
        o.order_id,
        o.order_date,
     	ROW_NUMBER() OVER(PARTITION BY o.customer_id ORDER BY o.order_date ASC, o.order_id ASC) AS ranking_pedido
    FROM orders o
) subconsulta
WHERE ranking_pedido = 1;
