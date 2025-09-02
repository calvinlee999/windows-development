-- Create additional databases for different projects
CREATE DATABASE testdb;
CREATE DATABASE apidb;
CREATE DATABASE microservices_db;

-- Create additional users
CREATE USER apiuser WITH ENCRYPTED PASSWORD 'apipass';
CREATE USER testuser WITH ENCRYPTED PASSWORD 'testpass';

-- Grant permissions
GRANT ALL PRIVILEGES ON DATABASE testdb TO testuser;
GRANT ALL PRIVILEGES ON DATABASE apidb TO apiuser;
GRANT ALL PRIVILEGES ON DATABASE microservices_db TO devuser;

-- Create some sample tables in devdb
\c devdb;

CREATE SCHEMA IF NOT EXISTS app;

CREATE TABLE IF NOT EXISTS app.users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS app.products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO app.users (username, email) VALUES 
    ('dev_user', 'dev@example.com'),
    ('test_user', 'test@example.com'),
    ('admin_user', 'admin@example.com');

INSERT INTO app.products (name, description, price) VALUES 
    ('Sample Product 1', 'This is a sample product for testing', 29.99),
    ('Sample Product 2', 'Another sample product', 49.99),
    ('Sample Product 3', 'Yet another sample product', 19.99);
