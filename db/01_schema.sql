CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Usuarios 
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(20) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password TEXT NOT NULL,
    role VARCHAR(20) DEFAULT 'cliente',
    weekly_budget DECIMAL(10,2) DEFAULT 0 CHECK (weekly_budget >= 0), 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Ingredientes 
CREATE TABLE ingredients (
    id SERIAL PRIMARY KEY,
    author_id UUID REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE, 
    name VARCHAR(100) UNIQUE NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10,4) NOT NULL DEFAULT 0 CHECK (unit_price >= 0),
    unit_default VARCHAR(10) NOT NULL DEFAULT 'g',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Inventario del Usuario 
CREATE TABLE inventory (
    id SERIAL PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    ingredient_id INTEGER REFERENCES ingredients(id) ON DELETE CASCADE ON UPDATE CASCADE,
    current_quantity DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (current_quantity >= 0),
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
    author_id UUID REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    servings VARCHAR(10) DEFAULT '1-2',  
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Ingredientes de una receta (Tabla puente N:N)
CREATE TABLE recipe_ingredients (
    recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE ON UPDATE CASCADE,
    ingredient_id INTEGER REFERENCES ingredients(id) ON DELETE CASCADE ON UPDATE CASCADE,
    required_quantity DECIMAL(10,2) NOT NULL CHECK (required_quantity > 0),
    PRIMARY KEY (recipe_id, ingredient_id)
);

-- 6. Listas de Compras
CREATE TABLE shopping_lists (
    id SERIAL PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    name VARCHAR(100) NOT NULL,
    status VARCHAR(20) DEFAULT 'pendiente' CHECK (status IN ('pendiente', 'comprada', 'cancelada')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. Items de la Lista (Tabla puente N:N)
CREATE TABLE shopping_list_items (
    id SERIAL PRIMARY KEY,
    list_id INTEGER REFERENCES shopping_lists(id) ON DELETE CASCADE ON UPDATE CASCADE,
    ingredient_id INTEGER REFERENCES ingredients(id) ON DELETE CASCADE ON UPDATE CASCADE,
    target_quantity DECIMAL(10,2) NOT NULL CHECK (target_quantity > 0),
    total_price DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (total_price >= 0)
);

-- 8. Historial de Compras 
CREATE TABLE purchase_history (
    id SERIAL PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    total_cost DECIMAL(10,2) NOT NULL CHECK (total_cost >= 0),
    purchased_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);