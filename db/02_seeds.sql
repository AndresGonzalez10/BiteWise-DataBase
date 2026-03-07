-- 1. INGREDIENTES INVESTIGADOS CON PESO UNITARIO
INSERT INTO ingredients (name, category, unit_price, unit_default, weight_per_unit) VALUES
('Tomate', 'Verduras', 0.0300, 'g', 120.00),
('Cebolla', 'Verduras', 0.0190, 'g', 150.00),
('Ajo', 'Verduras', 0.1200, 'g', 10.00),
('Limón', 'Verduras', 0.0700, 'g', 60.00),
('Chile', 'Verduras', 0.0420, 'g', 15.00),
('Papa', 'Verduras', 0.0400, 'g', 180.00),
('Pechuga de Pollo', 'Proteínas', 0.1450, 'g', 200.00),
('Huevo Blanco', 'Proteínas', 0.0660, 'g', 57.00),
('Atún en lata', 'Proteínas', 0.2230, 'g', 140.00),
('Arroz Súper Extra', 'Cereales', 0.0380, 'g', 1.00),
('Frijol Negro', 'Leguminosas', 0.0450, 'g', 1.00),
('Pasta Espagueti', 'Cereales', 0.0460, 'g', 1.00),
('Queso Oaxaca', 'Lácteos', 0.1600, 'g', 1.00),
('Leche Entera', 'Lácteos', 0.0370, 'ml', 1000.00),
('Aceite Vegetal', 'Abarrotes', 0.0450, 'ml', 15.00);

-- 2. RECETAS
INSERT INTO recipes (title, instructions) VALUES 
('Huevos a la Mexicana', '1. Picar tomate, cebolla y chile. 2. Sofreír en aceite. 3. Agregar los huevos y revolver.'),
('Arroz con Pollo', '1. Hervir la pechuga. 2. Sofreír el arroz. 3. Cocer todo junto con caldo de pollo.'),
('Ensalada Fresca de Atún', '1. Drenar el atún. 2. Picar finamente la cebolla y el tomate. 3. Mezclar todo con el jugo de limón y un toque de chile picado.'),
('Espagueti con Pollo al Ajillo', '1. Hervir la pasta hasta que esté al dente. 2. Picar el ajo finamente y sofreírlo en aceite junto con la pechuga cortada en cubos. 3. Mezclar la pasta con el pollo y agregar queso Oaxaca deshebrado por encima.');

-- 3. INGREDIENTES DE RECETAS

-- Receta 1: Huevos a la Mexicana
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, required_quantity) VALUES
(1, 8, 114.00), -- 2 huevos (2 * 57g)
(1, 1, 120.00), -- 1 tomate
(1, 2, 75.00),  -- media cebolla
(1, 5, 15.00),  -- 1 chile
(1, 15, 15.00); -- 1 cucharada aceite

-- Receta 2: Arroz con Pollo
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, required_quantity) VALUES
(2, 7, 400.00), -- 2 pechugas
(2, 10, 150.00), -- 150g arroz
(2, 2, 50.00),  -- un tercio de cebolla
(2, 15, 15.00); -- 1 cucharada aceite

-- Receta 3: Ensalada Fresca de Atún
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, required_quantity) VALUES
(3, 9, 140.00), -- 1 lata de atún
(3, 1, 120.00), -- 1 tomate
(3, 2, 50.00),  -- un tercio de cebolla
(3, 4, 30.00),  -- medio limón (30g de jugo aprox)
(3, 5, 15.00);  -- 1 chile picadito

-- Receta 4: Espagueti con Pollo al Ajillo
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, required_quantity) VALUES
(4, 12, 200.00), -- 200g de espagueti
(4, 3, 10.00),   -- 1 diente de ajo
(4, 7, 200.00),  -- 1 pechuga de pollo
(4, 15, 15.00),  -- 1 cucharada de aceite vegetal
(4, 13, 50.00);  -- 50g de queso Oaxaca