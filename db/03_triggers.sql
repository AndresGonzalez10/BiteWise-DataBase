-- 1. TRIGGER: Auto-cálculo de precio en la Lista de Compras
CREATE OR REPLACE FUNCTION calculate_shopping_item_price()
RETURNS TRIGGER AS $$
DECLARE
    ing_price DECIMAL(10,4);
BEGIN
    SELECT unit_price INTO ing_price 
    FROM ingredients 
    WHERE id = NEW.ingredient_id;
    
    IF ing_price IS NULL THEN
        ing_price := 0;
    END IF;

    NEW.total_price := NEW.target_quantity * ing_price;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_calculate_shopping_item_price
BEFORE INSERT OR UPDATE ON shopping_list_items
FOR EACH ROW
EXECUTE FUNCTION calculate_shopping_item_price();


-- 2. TRIGGER: Limpieza Automática del Inventario (Refri)
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
FOR EACH ROW
EXECUTE FUNCTION clean_empty_inventory();