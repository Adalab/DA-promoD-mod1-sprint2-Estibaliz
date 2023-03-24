USE northwind;

/*1. Selecciona todos los campos de los productos, que pertenezcan a los proveedores con códigos: 1, 3, 7, 8 y 9, 
que tengan stock en el almacén, y al mismo tiempo que sus precios unitarios estén entre 50 y 100. 
Por último, ordena los resultados por código de proveedor de forma ascendente.*/

SELECT * 
FROM products
WHERE supplier_id IN (1, 3, 7, 8, 9) AND units_in_stock <> 0
HAVING unit_price BETWEEN 50 AND 100
ORDER BY supplier_id;

-- En esta primera primera query hemos seleccionado todos los registros de la tabla products, especificando en WHERE los
-- números de los proveedores indicados entre paréntesis (ya que de otra manera da error de sintaxis) y que las unidades 
-- en stock fueran distintas a cero con el operador. En este caso el HAVING funcionaria como un equivalente a WHERE, dónde 
-- también especificamos que las cantidades deben estar entre 50 y 100 (con ayuda del BETWEEN)


/*2. Devuelve el nombre y apellidos y el id de los empleados con códigos entre el 3 y el 6, 
además que hayan vendido a clientes que tengan códigos que comiencen con las letras de la A hasta la G. 
Por último, en esta búsqueda queremos filtrar solo por aquellos envíos que la fecha de pedido este comprendida 
entre el 22 y el 31 de Diciembre de cualquier año.*/

SELECT employee_id, first_name, last_name, order_date, customer_id
FROM employees
NATURAL JOIN orders
WHERE employee_id BETWEEN 3 AND 6
	AND (DAY(order_date) BETWEEN 22 AND '31') AND MONTH(order_date) = 12
    AND customer_id REGEXP '^[A-G].*';

-- En este segundo ejercicio, antes de construirlo, hemos creado en primer lugar una query para concretar que el employee_id
-- estuviera entre 3 y 6, otra para determinar el patrón de REGEX necesario para que el nombre de los clientes comprendiera de la 
-- A a la G, y por último aislamos el mes y los días solicitados. Al tratarse e so tablas diferentes utilizamos un NATURAL JOIN 
-- para unirlas pero no indicamos que se trata del employee_id porque en las dos tablas se llama igual.

/*3. Calcula el precio de venta de cada pedido una vez aplicado el descuento. Muestra el id del la orden, el id del producto, 
el nombre del producto, el precio unitario, la cantidad, el descuento y el precio de venta después de haber aplicado el descuento.*/

SELECT a.order_id, b.product_id, b.product_name, a.unit_price, a.quantity, a.discount, (a.unit_price * a.quantity) * (1- a.discount) AS PrecioVenta
FROM order_details AS a
INNER JOIN products AS b
ON a.product_id = b.product_id
ORDER BY order_id;

-- Para este tercer ejercicio hemos aplicado un INNER JOIN, para el cual si tenemos que especificar el nombre de la columna de unión
-- en el ON, y hemos dado alias a las tablas. No hemos utilizado un NATURAL JOIN porque aunque es más cómodo, nos eliminaba 
-- algunos registros al probar con él, dado que NATURAL JOIN no permite duplicados.

/*4. Usando una subconsulta, muestra los productos cuyos precios estén por encima del precio medio total de los productos de la BBDD.
¿Qué productos ha vendido cada empleado y cuál es la cantidad vendida de cada uno de ellos?*/

SELECT product_name, unit_price
		FROM products
		WHERE unit_price > ( 
							SELECT AVG(unit_price)
							FROM products); 

-- En el cuarto ejercicio primero hemos construido una subquery para calcular la media de unit_price de los productos de nuestra 
-- base de datos, y luego la hemos unido a la query principal por la clausula WHERE, para que nos proporcione las columnas donde
-- ese unit_price es mayor que el medio de nuestra base.
-- Para sacar los productos vendidos por cada empleado y la cantidad vendida de cada uno he empleado una query aparte (no entendía
-- como hacerlo todo junto)

SELECT first_name AS "Nombre", last_name AS "Apellido", product_name AS "Producto", SUM(quantity) AS "Cantidad_total_vendida", employees.employee_id
FROM employees
INNER JOIN orders
	ON employees.employee_id = orders.employee_id
INNER JOIN order_details
	ON order_details.order_id = orders.order_id
INNER JOIN products
	ON order_details.product_id = products.product_id
GROUP BY employees.employee_id, products.product_name
ORDER BY employees.employee_id, Producto;

/*5. Basándonos en la query anterior, ¿qué empleado es el que vende más productos? Soluciona este ejercicio con una subquery
BONUS ¿Podríais solucionar este mismo ejercicio con una CTE?*/

