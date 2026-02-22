-- Habilitar extensión para IDs únicos si no existe
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Catálogo Maestro de Ingredientes
CREATE TABLE ingredients (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    category VARCHAR(50),
    unit_default VARCHAR(20),
    unit_price INTEGER NOT NULL DEFAULT 0 
);

-- 2. Usuarios
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Inventario del Usuario 
CREATE TABLE inventory (
    id SERIAL PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    ingredient_id INTEGER REFERENCES ingredients(id),
    current_quantity DECIMAL(10,2) NOT NULL DEFAULT 0,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Recetas 
CREATE TABLE recipes (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    instructions TEXT NOT NULL,
    image_url TEXT,
    is_custom BOOLEAN DEFAULT FALSE,
    author_id UUID REFERENCES users(id) ON DELETE SET NULL
);

-- 5. Relación Ingredientes-Recetas
CREATE TABLE recipe_ingredients (
    recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
    ingredient_id INTEGER REFERENCES ingredients(id),
    required_quantity DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (recipe_id, ingredient_id)
);

-- 6. Listas de Compras
CREATE TABLE shopping_lists (
    id SERIAL PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. Items de la Lista 
CREATE TABLE shopping_list_items (
    id SERIAL PRIMARY KEY,
    list_id INTEGER REFERENCES shopping_lists(id) ON DELETE CASCADE,
    ingredient_id INTEGER REFERENCES ingredients(id),
    target_quantity DECIMAL(10,2) NOT NULL,
    total_price INTEGER NOT NULL DEFAULT 0 
);