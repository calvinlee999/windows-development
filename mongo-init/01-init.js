// MongoDB Initialization Script
// This script runs when MongoDB container starts for the first time

print('Starting MongoDB initialization...');

// Switch to devdb database
db = db.getSiblingDB('devdb');

// Create additional users
db.createUser({
  user: 'apiuser',
  pwd: 'apipass',
  roles: [
    { role: 'readWrite', db: 'devdb' },
    { role: 'readWrite', db: 'apidb' }
  ]
});

db.createUser({
  user: 'testuser',
  pwd: 'testpass',
  roles: [
    { role: 'readWrite', db: 'devdb' },
    { role: 'readWrite', db: 'testdb' }
  ]
});

// Create sample collections and data
db.users.insertMany([
  {
    _id: ObjectId(),
    username: 'dev_user',
    email: 'dev@example.com',
    profile: {
      firstName: 'Dev',
      lastName: 'User',
      age: 30
    },
    preferences: {
      theme: 'dark',
      language: 'en'
    },
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    _id: ObjectId(),
    username: 'test_user',
    email: 'test@example.com',
    profile: {
      firstName: 'Test',
      lastName: 'User',
      age: 25
    },
    preferences: {
      theme: 'light',
      language: 'en'
    },
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    _id: ObjectId(),
    username: 'admin_user',
    email: 'admin@example.com',
    profile: {
      firstName: 'Admin',
      lastName: 'User',
      age: 35
    },
    preferences: {
      theme: 'dark',
      language: 'en'
    },
    isAdmin: true,
    createdAt: new Date(),
    updatedAt: new Date()
  }
]);

db.products.insertMany([
  {
    _id: ObjectId(),
    name: 'Sample Product 1',
    description: 'This is a sample product for testing MongoDB',
    price: 29.99,
    category: 'Electronics',
    tags: ['sample', 'test', 'electronics'],
    inventory: {
      quantity: 100,
      warehouse: 'A1'
    },
    reviews: [
      {
        userId: 'dev_user',
        rating: 5,
        comment: 'Great product!',
        date: new Date()
      }
    ],
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    _id: ObjectId(),
    name: 'Sample Product 2',
    description: 'Another sample product for testing',
    price: 49.99,
    category: 'Books',
    tags: ['sample', 'test', 'books'],
    inventory: {
      quantity: 50,
      warehouse: 'B2'
    },
    reviews: [],
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    _id: ObjectId(),
    name: 'Sample Product 3',
    description: 'Yet another sample product',
    price: 19.99,
    category: 'Clothing',
    tags: ['sample', 'test', 'clothing'],
    inventory: {
      quantity: 75,
      warehouse: 'C3'
    },
    reviews: [
      {
        userId: 'test_user',
        rating: 4,
        comment: 'Good quality',
        date: new Date()
      },
      {
        userId: 'admin_user',
        rating: 5,
        comment: 'Excellent!',
        date: new Date()
      }
    ],
    createdAt: new Date(),
    updatedAt: new Date()
  }
]);

// Create orders collection with relationships
db.orders.insertMany([
  {
    _id: ObjectId(),
    orderNumber: 'ORD-001',
    userId: 'dev_user',
    items: [
      {
        productName: 'Sample Product 1',
        quantity: 2,
        price: 29.99
      }
    ],
    totalAmount: 59.98,
    status: 'completed',
    shippingAddress: {
      street: '123 Dev Street',
      city: 'Dev City',
      zipCode: '12345',
      country: 'USA'
    },
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    _id: ObjectId(),
    orderNumber: 'ORD-002',
    userId: 'test_user',
    items: [
      {
        productName: 'Sample Product 2',
        quantity: 1,
        price: 49.99
      },
      {
        productName: 'Sample Product 3',
        quantity: 3,
        price: 19.99
      }
    ],
    totalAmount: 109.96,
    status: 'pending',
    shippingAddress: {
      street: '456 Test Avenue',
      city: 'Test City',
      zipCode: '67890',
      country: 'USA'
    },
    createdAt: new Date(),
    updatedAt: new Date()
  }
]);

// Create indexes for better performance
db.users.createIndex({ username: 1 }, { unique: true });
db.users.createIndex({ email: 1 }, { unique: true });
db.products.createIndex({ name: 1 });
db.products.createIndex({ category: 1 });
db.products.createIndex({ tags: 1 });
db.orders.createIndex({ userId: 1 });
db.orders.createIndex({ orderNumber: 1 }, { unique: true });
db.orders.createIndex({ status: 1 });
db.orders.createIndex({ createdAt: -1 });

// Create additional databases
db = db.getSiblingDB('testdb');
db.test_collection.insertOne({ message: 'Test database initialized', createdAt: new Date() });

db = db.getSiblingDB('apidb');
db.api_logs.insertOne({ 
  endpoint: '/api/test',
  method: 'GET',
  status: 200,
  response_time: 45,
  timestamp: new Date()
});

print('MongoDB initialization completed successfully!');
