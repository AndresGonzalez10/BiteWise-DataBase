-- ==========================================
-- 02_seeds.sql (Datos iniciales - Catálogo Global)
-- ==========================================

-- 1. INGREDIENTES GLOBALES 
INSERT INTO ingredients (name, category, unit_price, unit_default) VALUES
('Tomate', 'Verduras', 3.6000, 'unidad'),        -- 120g * 0.03 = $3.60 por pieza
('Cebolla', 'Verduras', 2.0190, 'unidad'),            -- Se mantiene en gramos
('Ajo', 'Verduras', 1.2000, 'unidad'),           -- 10g * 0.12 = $1.20 por diente
('Limón', 'Verduras', 4.2000, 'unidad'),         -- 60g * 0.07 = $4.20 por pieza
('Chile', 'Verduras', 0.6300, 'unidad'),         -- 15g * 0.042 = $0.63 por pieza
('Papa', 'Verduras', 7.2000, 'unidad'),          -- 180g * 0.04 = $7.20 por pieza
('Pechuga de Pollo', 'Proteínas', 0.1450, 'g'),  -- Se mantiene en gramos
('Huevo Blanco', 'Proteínas', 3.7620, 'unidad'), -- 57g * 0.066 = $3.76 por pieza
('Atún en lata', 'Proteínas', 31.2200, 'unidad'),-- 140g * 0.223 = $31.22 por lata
('Arroz Súper Extra', 'Cereales', 0.0380, 'g'),  -- Se mantiene en gramos
('Frijol Negro', 'Leguminosas', 0.0450, 'g'),    -- Se mantiene en gramos
('Pasta Espagueti', 'Cereales', 0.0460, 'g'),    -- Se mantiene en gramos
('Queso Oaxaca', 'Lácteos', 0.1600, 'g'),        -- Se mantiene en gramos
('Leche Entera', 'Lácteos', 0.0370, 'ml'),       -- Se mantiene en ml
('Aceite Vegetal', 'Abarrotes', 0.0450, 'ml');   -- Se mantiene en ml

-- 2. RECETAS GLOBALES 
INSERT INTO recipes (title, instructions) VALUES 
('Huevos a la Mexicana', '1. Picar tomate, cebolla y chile. 2. Sofreír en aceite. 3. Agregar los huevos y revolver.'),
('Arroz con Pollo', '1. Hervir la pechuga. 2. Sofreír el arroz. 3. Cocer todo junto con caldo de pollo.'),
('Ensalada Fresca de Atún', '1. Drenar el atún. 2. Picar finamente la cebolla y el tomate. 3. Mezclar todo con el jugo de limón y un toque de chile picado.'),
('Espagueti con Pollo al Ajillo', '1. Hervir la pasta hasta que esté al dente. 2. Picar el ajo finamente y sofreírlo en aceite junto con la pechuga cortada en cubos. 3. Mezclar la pasta con el pollo y agregar queso Oaxaca deshebrado por encima.');

-- 3. INGREDIENTES DE RECETAS 

-- Receta 1: Huevos a la Mexicana
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, required_quantity) VALUES
(1, 8, 2.00),    -- 2 huevos (ahora literal '2 unidades')
(1, 1, 1.00),    -- 1 tomate (ahora literal '1 unidad')
(1, 2, 75.00),   -- media cebolla (en gramos)
(1, 5, 1.00),    -- 1 chile (ahora literal '1 unidad')
(1, 15, 15.00);  -- 1 cucharada aceite (en ml)

-- Receta 2: Arroz con Pollo
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, required_quantity) VALUES
(2, 7, 400.00),  -- 2 pechugas (en gramos)
(2, 10, 150.00), -- 150g arroz
(2, 2, 50.00),   -- un tercio de cebolla (en gramos)
(2, 15, 15.00);  -- 1 cucharada aceite (en ml)

-- Receta 3: Ensalada Fresca de Atún
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, required_quantity) VALUES
(3, 9, 1.00),    -- 1 lata de atún (ahora literal '1 unidad')
(3, 1, 1.00),    -- 1 tomate (ahora literal '1 unidad')
(3, 2, 50.00),   -- un tercio de cebolla (en gramos)
(3, 4, 0.50),    -- medio limón (ahora literal '0.5 unidad')
(3, 5, 1.00);    -- 1 chile picadito (ahora literal '1 unidad')

-- Receta 4: Espagueti con Pollo al Ajillo
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, required_quantity) VALUES
(4, 12, 200.00), -- 200g de espagueti
(4, 3, 1.00),    -- 1 diente de ajo (ahora literal '1 unidad')
(4, 7, 200.00),  -- 1 pechuga de pollo (en gramos)
(4, 15, 15.00),  -- 1 cucharada de aceite vegetal (en ml)
(4, 13, 50.00);  -- 50g de queso Oaxaca