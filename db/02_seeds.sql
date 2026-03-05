

-- 1. INGREDIENTES INVESTIGADOS (Precios por 1g o 1ml)

INSERT INTO ingredients (name, category, unit_price, unit_default) VALUES
('Tomate', 'Verduras', 0.0300, 'g'),
('Cebolla', 'Verduras', 0.0190, 'g'),
('Ajo', 'Verduras', 0.1200, 'g'),
('Limón', 'Verduras', 0.0700, 'g'),
('Chile', 'Verduras', 0.0420, 'g'),
('Papa', 'Verduras', 0.0400, 'g'),
('Pechuga de Pollo', 'Proteínas', 0.1450, 'g'),
('Huevo Blanco', 'Proteínas', 0.0660, 'g'),
('Atún en lata', 'Proteínas', 0.2230, 'g'),
('Arroz Súper Extra', 'Cereales', 0.0380, 'g'),
('Frijol Negro', 'Leguminosas', 0.0450, 'g'),
('Pasta Espagueti', 'Cereales', 0.0460, 'g'),
('Queso Oaxaca', 'Lácteos', 0.1600, 'g'),
('Leche Entera', 'Lácteos', 0.0370, 'ml'),
('Aceite Vegetal', 'Abarrotes', 0.0450, 'ml');


INSERT INTO recipes (title, instructions) VALUES 
('Huevos a la Mexicana', '1. Picar tomate, cebolla y chile. 2. Sofreír en aceite. 3. Agregar los huevos y revolver.'),
('Arroz con Pollo', '1. Hervir la pechuga. 2. Sofreír el arroz. 3. Cocer todo junto con caldo de pollo.');


--INGREDIENTES QUE LLEVAN LAS RECETAS 


INSERT INTO recipe_ingredients (recipe_id, ingredient_id, required_quantity) VALUES
(1, 8, 100.00),
(1, 1, 60.00),  
(1, 2, 30.00),  
(1, 5, 10.00),  
(1, 15, 15.00); 

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, required_quantity) VALUES
(2, 7, 200.00), 
(2, 10, 150.00),
(2, 2, 50.00),  
(2, 15, 15.00); 