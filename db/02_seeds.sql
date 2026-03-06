-- 1. USUARIO DE PRUEBA (Para que no fallen las relaciones)
INSERT INTO users (id, name, email, password_hash, role) VALUES 
('e58000a6-6735-443f-b02e-8a7c88872493', 'Andres', 'andres@test.com', 'hash123', 'estudiante');

-- 2. INGREDIENTES INVESTIGADOS CON PESO UNITARIO
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

-- 3. RECETAS
INSERT INTO recipes (title, instructions) VALUES 
('Huevos a la Mexicana', '1. Picar tomate, cebolla y chile. 2. Sofreír en aceite. 3. Agregar los huevos y revolver.'),
('Arroz con Pollo', '1. Hervir la pechuga. 2. Sofreír el arroz. 3. Cocer todo junto con caldo de pollo.');

-- 4. INGREDIENTES DE RECETAS
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, required_quantity) VALUES
(1, 8, 114.00), -- 2 huevos (2 * 57g)
(1, 1, 120.00), -- 1 tomate
(1, 2, 75.00),  -- media cebolla
(1, 5, 15.00),  -- 1 chile
(1, 15, 15.00); -- 1 cucharada aceite

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, required_quantity) VALUES
(2, 7, 400.00), -- 2 pechugas
(2, 10, 150.00), -- 150g arroz
(2, 2, 50.00),
(2, 15, 15.00);