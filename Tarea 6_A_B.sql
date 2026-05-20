--6.	Calcula un listado de clientes que tienen cesta media (facturación divida en número de pedidos) inferior a la cesta media de su género.
-- Para esta query vamos a dar por hecho que tenemos el total_amount en la tabla orders

-- Opción A: utilizando subconsultas

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




-- Opción B; utilizando una tabla temporal que simplifique el ejercicio CTE (WITH)
-- hacemos una tabla temporal que calcula la media de gasto por género


WITH medias_por_genero AS (
    SELECT 
        c2.gender,
        AVG(o2.total_amount) ::NUMERIC(10,2) AS media_genero -- usamos el casteo para que solo nos salgan dos decimales 
    FROM customers c2
    INNER JOIN orders o2 ON c2.customer_id = o2.customer_id
    GROUP BY c2.gender
)

-- y luego la utiliamos en la query con el alias .mpg
SELECT 
    c.customer_id,
    c.customer_name,
    c.gender,
    AVG(o.total_amount) ::NUMERIC(10,2) AS cesta_media_cliente,
    mpg.media_genero AS cesta_media_genero  -- en la query metemos el dato calculado de la CTE
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN medias_por_genero mpg ON c.gender = mpg.gender -- hacemos el join con la CTE .mpg 
GROUP BY c.customer_id, c.customer_name, c.gender, mpg.media_genero
HAVING AVG(o.total_amount) < mpg.media_genero -- y en el Having metemos el calculo para que nos devuelva los mayores dle gasto medio
ORDER BY c.gender, cesta_media_cliente ASC;


