--8.	Haz un ranking de pedidos por cada customer_id, y quedate luego con el primer order_id. ¿Para que puede ser util hacer esta consulta?
-- Esta consulta es útil para saber en que momento se captó ese cliente, cuántos años lleva siendo cliente de cara a utilizarlo para campañas de marketing 
-- por ejemplo, o medir el éxito de las diferentes campañas en un periodo de tiempo. 
-- Para este query propongo una subconsulta para sacar el ranking de las fechas de las compras, y luego quedarnos solo con la primera posición. 


-- Opción A: utilizando una subconsulta en el from con una función de ventana y el over partition, que luego saco con el where (segundo paso).

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


-- Opción B: utilizar una CTE creando mi with para sacar el listado de pedidos y aplicando la función de ventan con el over patition en esta CTE

WITH pedidos_numerados AS (
    SELECT 
        o.customer_id,
        o.order_id,
        o.order_date,
        ROW_NUMBER() OVER(PARTITION BY o.customer_id ORDER BY o.order_date ASC, o.order_id ASC) AS ranking_pedido
    FROM orders o
)
SELECT 
    customer_id,
    order_id,
    order_date
FROM pedidos_numerados
WHERE ranking_pedido = 1;