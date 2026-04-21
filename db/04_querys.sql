-- QUERY 1: VALIDADOR PRINCIPAL DE LA HIPÓTESIS
WITH GastosPorSemana AS (
    SELECT 
        user_id,
        DATE_TRUNC('week', purchased_at) AS semana,
        SUM(total_cost) AS gasto_semanal
    FROM purchase_history
    GROUP BY user_id, DATE_TRUNC('week', purchased_at)
),
GastoPromedio AS (
    SELECT 
        user_id,
        AVG(gasto_semanal) AS promedio_semanal
    FROM GastosPorSemana
    GROUP BY user_id
)
SELECT 
    u.name AS usuario, 
    u.weekly_budget AS presupuesto_sin_app,
    COALESCE(gp.promedio_semanal, 0) AS gasto_promedio_con_app,
    CASE 
        WHEN u.weekly_budget > 0 AND gp.promedio_semanal IS NOT NULL 
        THEN ROUND(((u.weekly_budget - gp.promedio_semanal) / u.weekly_budget) * 100, 2)
        ELSE 0 
    END AS porcentaje_ahorro
FROM users u
LEFT JOIN GastoPromedio gp ON u.id = gp.user_id
WHERE u.role = 'cliente';

-- QUERY 2: VALORIZACIÓN DEL INVENTARIO 
SELECT 
    u.name AS usuario,
    COUNT(inv.ingredient_id) AS total_ingredientes_diferentes,
    SUM(inv.current_quantity * i.unit_price) AS valor_dinero_en_refri
FROM inventory inv
JOIN users u ON inv.user_id = u.id
JOIN ingredients i ON inv.ingredient_id = i.id
GROUP BY u.name
HAVING COUNT(inv.ingredient_id) > 3
ORDER BY valor_dinero_en_refri DESC;


-- QUERY 3: RECETAS MÁS COSTOSAS DEL CATÁLOGO 
SELECT 
    r.title AS nombre_receta,
    COUNT(ri.ingredient_id) AS cantidad_ingredientes,
    SUM(ri.required_quantity * i.unit_price) AS costo_total_estimado
FROM recipes r
JOIN recipe_ingredients ri ON r.id = ri.recipe_id
JOIN ingredients i ON ri.ingredient_id = i.id
GROUP BY r.title
HAVING SUM(ri.required_quantity * i.unit_price) > 50.00
ORDER BY costo_total_estimado DESC;


-- QUERY 4: ANÁLISIS DE DÉFICIT DE UNA RECETA 
SELECT 
    i.name AS ingrediente,
    ri.required_quantity AS requiere_receta,
    COALESCE(inv.current_quantity, 0) AS tiene_en_refri,
    (ri.required_quantity - COALESCE(inv.current_quantity, 0)) AS falta_comprar,
    ((ri.required_quantity - COALESCE(inv.current_quantity, 0)) * i.unit_price) AS costo_del_faltante
FROM recipe_ingredients ri
JOIN ingredients i ON ri.ingredient_id = i.id
LEFT JOIN inventory inv ON ri.ingredient_id = inv.ingredient_id 
    AND inv.user_id = (SELECT id FROM users LIMIT 1) 
WHERE ri.recipe_id = 1 
  AND (ri.required_quantity - COALESCE(inv.current_quantity, 0)) > 0;

-- QUERY 5: COMPORTAMIENTO DE COMPRAS / TASA DE CONVERSIÓN (GROUP BY, CASE)
SELECT 
    status AS estatus_de_lista,
    COUNT(id) AS total_listas,
    ROUND((COUNT(id) * 100.0) / (SELECT COUNT(*) FROM shopping_lists), 2) AS porcentaje_del_total
FROM shopping_lists
GROUP BY status
ORDER BY total_listas DESC;