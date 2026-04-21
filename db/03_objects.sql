-- A. TRIGGERS 

-- 1. Trigger de Auditoría: 
-- Propósito: Actualizar automáticamente la columna `updated_at` con la fecha 
-- y hora actual cada vez que se modifica un registro. Es vital para la auditoría.
CREATE OR REPLACE FUNCTION fn_audit_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION fn_audit_updated_at();
CREATE TRIGGER trg_ingredients_updated_at BEFORE UPDATE ON ingredients FOR EACH ROW EXECUTE FUNCTION fn_audit_updated_at();
CREATE TRIGGER trg_recipes_updated_at BEFORE UPDATE ON recipes FOR EACH ROW EXECUTE FUNCTION fn_audit_updated_at();
CREATE TRIGGER trg_shopping_lists_updated_at BEFORE UPDATE ON shopping_lists FOR EACH ROW EXECUTE FUNCTION fn_audit_updated_at();

-- 2. Trigger de Lógica de Negocio :
-- Propósito: Cuando se agrega un ingrediente a la lista de compras, busca su precio 
-- unitario en el catálogo y calcula automáticamente el `total_price` multiplicándolo 
-- por la cantidad objetivo, evitando que el frontend haga matemáticas financieras.
CREATE OR REPLACE FUNCTION calculate_shopping_item_price()
RETURNS TRIGGER AS $$
DECLARE
    ing_price DECIMAL(10,4);
BEGIN
    SELECT unit_price INTO ing_price 
    FROM ingredients 
    WHERE id = NEW.ingredient_id;
    
    IF ing_price IS NULL THEN ing_price := 0; END IF;

    NEW.total_price := NEW.target_quantity * ing_price;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_calculate_shopping_item_price
BEFORE INSERT OR UPDATE ON shopping_list_items
FOR EACH ROW EXECUTE FUNCTION calculate_shopping_item_price();

-- 3. Trigger de Lógica de Negocio (Limpieza):
-- Propósito: Mantiene limpio el inventario. Si al descontar un ingrediente su 
-- cantidad llega a 0 (o menos), elimina la fila de la tabla `inventory` automáticamente.
CREATE OR REPLACE FUNCTION clean_empty_inventory()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.current_quantity <= 0 THEN
        DELETE FROM inventory WHERE id = NEW.id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_clean_empty_inventory
AFTER UPDATE ON inventory
FOR EACH ROW EXECUTE FUNCTION clean_empty_inventory();

-- B. FUNCIONES (Requisito: 2+ Funciones)

-- 1. Función Escalar:
-- Propósito: Devuelve un único valor numérico que representa el total de dinero 
-- que ha gastado históricamente un usuario en la plataforma.
CREATE OR REPLACE FUNCTION fn_total_gastado(p_user_id UUID)
RETURNS DECIMAL AS $$
DECLARE
    v_total DECIMAL(10,2);
BEGIN
    SELECT COALESCE(SUM(total_cost), 0) INTO v_total 
    FROM purchase_history 
    WHERE user_id = p_user_id;
    RETURN v_total;
END;
$$ LANGUAGE plpgsql;

-- 2. Función Tabulada:
-- Propósito: Retorna una tabla virtual (formato tabla) que muestra el refrigerador 
-- de un usuario, uniendo los nombres y unidades de medida desde el catálogo de ingredientes.
CREATE OR REPLACE FUNCTION fn_obtener_refri_usuario(p_user_id UUID)
RETURNS TABLE (ingrediente VARCHAR, cantidad DECIMAL, unidad VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT i.name::VARCHAR, inv.current_quantity, i.unit_default::VARCHAR
    FROM inventory inv
    JOIN ingredients i ON inv.ingredient_id = i.id
    WHERE inv.user_id = p_user_id;
END;
$$ LANGUAGE plpgsql;


-- C. VISTAS / VIEWS 

-- 1. Vista con JOIN de 2+ tablas:
-- Propósito: Mostrar un catálogo completo de recetas incluyendo el nombre legible 
-- de su autor (haciendo JOIN con la tabla de usuarios).
CREATE OR REPLACE VIEW vw_recetas_completas AS
SELECT r.id, r.title, COALESCE(u.name, 'Sistema') AS autor, r.is_custom
FROM recipes r
LEFT JOIN users u ON r.author_id = u.id;

-- 2. Vista con Funciones de Agregación (SUM):
-- Propósito: Calcular el costo estimado total para cocinar cada receta del sistema, 
-- sumando el precio unitario multiplicado por la cantidad de cada ingrediente requerido.
CREATE OR REPLACE VIEW vw_costo_recetas AS
SELECT r.title, SUM(ri.required_quantity * i.unit_price) AS costo_estimado_total
FROM recipes r
JOIN recipe_ingredients ri ON r.id = ri.recipe_id
JOIN ingredients i ON ri.ingredient_id = i.id
GROUP BY r.title;

-- 3. Vista diseñada específicamente para la Hipótesis:
-- Propósito: Mide la hipótesis de negocio agrupando el gasto semanal promedio 
-- del usuario mediante CTEs (WITH) y calculando el porcentaje de ahorro frente 
-- a su presupuesto semanal declarado.
CREATE OR REPLACE VIEW vw_reporte_hipotesis AS
WITH GastosSemanales AS (
    SELECT 
        user_id,
        DATE_TRUNC('week', purchased_at) AS semana,
        SUM(total_cost) AS gasto_semanal
    FROM purchase_history
    GROUP BY user_id, DATE_TRUNC('week', purchased_at)
),
PromedioSemanal AS (
    SELECT 
        user_id,
        AVG(gasto_semanal) AS promedio_gasto_semanal
    FROM GastosSemanales
    GROUP BY user_id
)
SELECT 
    u.id AS user_id, 
    u.name, 
    u.weekly_budget AS presupuesto_declarado,
    COALESCE(ps.promedio_gasto_semanal, 0) AS gasto_promedio_con_app,
    (u.weekly_budget - COALESCE(ps.promedio_gasto_semanal, 0)) AS ahorro_promedio_semanal,
    CASE 
        WHEN u.weekly_budget > 0 AND ps.promedio_gasto_semanal IS NOT NULL 
        THEN ROUND(((u.weekly_budget - ps.promedio_gasto_semanal) / u.weekly_budget) * 100, 2)
        ELSE 0 
    END AS porcentaje_ahorro_semanal
FROM users u
LEFT JOIN PromedioSemanal ps ON u.id = ps.user_id;

-- D. PROCEDIMIENTOS ALMACENADOS / SPs 

-- 1. SP con Transacción Explícita (BEGIN/COMMIT):
-- Propósito: Simular la compra segura de una lista. Al ser una transacción, 
-- asegura que si ocurre un error, no se cambien los datos parcialmente.
CREATE OR REPLACE PROCEDURE sp_comprar_lista_segura(p_list_id INT, p_user_id UUID)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE shopping_lists 
    SET status = 'comprada', updated_at = CURRENT_TIMESTAMP 
    WHERE id = p_list_id AND user_id = p_user_id;
    
    IF NOT FOUND THEN 
        RAISE EXCEPTION 'Lista no encontrada o no autorizada para este usuario.'; 
    END IF;
    
    COMMIT; 
END;
$$;

-- 2. SP con Cursor e Iteración:
-- Propósito: Iterar sobre todas las listas de compras que estén en estatus 'cancelada'
-- usando un cursor, y eliminarlas una por una para liberar espacio en la base de datos.
CREATE OR REPLACE PROCEDURE sp_limpiar_listas_canceladas()
LANGUAGE plpgsql AS $$
DECLARE
    cur_listas CURSOR FOR SELECT id FROM shopping_lists WHERE status = 'cancelada';
    v_id INT;
BEGIN
    OPEN cur_listas;
    LOOP
        FETCH cur_listas INTO v_id;
        EXIT WHEN NOT FOUND;
        DELETE FROM shopping_lists WHERE id = v_id;
    END LOOP;
    CLOSE cur_listas;
END;
$$;

-- 3. SP con Lógica de Negocio:
-- Propósito: Multiplicar las cantidades de todos los ingredientes de una receta 
-- específica cuando un usuario desea cocinar para más (o menos) personas.
CREATE OR REPLACE PROCEDURE sp_escalar_receta(p_recipe_id INT, p_multiplicador DECIMAL)
LANGUAGE plpgsql AS $$
BEGIN
    IF p_multiplicador <= 0 THEN
        RAISE EXCEPTION 'El multiplicador debe ser mayor a cero.';
    END IF;

    UPDATE recipe_ingredients 
    SET required_quantity = required_quantity * p_multiplicador 
    WHERE recipe_id = p_recipe_id;
END;
$$;