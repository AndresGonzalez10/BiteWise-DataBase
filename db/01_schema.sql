-- Habilitar extensión para IDs únicos si no existe
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Usuarios 
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(20) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role VARCHAR(20) DEFAULT 'cliente',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 1. Ingredientes
CREATE TABLE ingredients (
    id SERIAL PRIMARY KEY,
    author_id UUID REFERENCES users(id) ON DELETE CASCADE, 
    name VARCHAR(100) UNIQUE NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10,4) NOT NULL DEFAULT 0,
    unit_default VARCHAR(10) NOT NULL DEFAULT 'g',
    weight_per_unit DECIMAL(10,2) NOT NULL DEFAULT 1.00
);

-- 3. Inventario del Usuario 
CREATE TABLE inventory (
    id SERIAL PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    ingredient_id INTEGER REFERENCES ingredients(id),
    current_quantity DECIMAL(10,2) NOT NULL DEFAULT 0,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, ingredient_id)
);

-- 4. Recetas 
CREATE TABLE recipes (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    instructions TEXT NOT NULL,
    image_url TEXT,
    is_custom BOOLEAN DEFAULT false,
    author_id UUID REFERENCES users(id) ON DELETE CASCADE, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Ingredientes de una receta
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
    total_price DECIMAL(10,2) NOT NULL DEFAULT 0 
);