const express = require('express');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Logging middleware
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next();
});

// In-memory user storage for demo
const users = [
  { id: '1', name: 'John Doe', email: 'john@example.com' },
  { id: '2', name: 'Jane Smith', email: 'jane@example.com' }
];

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'healthy',
    service: 'AWS API Gateway Simulator',
    timestamp: new Date().toISOString(),
    endpoints: [
      'GET /hello',
      'GET /users',
      'POST /users',
      'GET /users/{id}',
      'PUT /users/{id}',
      'DELETE /users/{id}',
      'GET /health'
    ]
  });
});

// Hello World endpoint
app.get('/hello', (req, res) => {
  res.json({
    message: 'Hello from AWS API Gateway Simulator!',
    timestamp: new Date().toISOString(),
    query: req.query
  });
});

// GET /users - List all users
app.get('/users', (req, res) => {
  res.json({ 
    users: users,
    count: users.length 
  });
});

// POST /users - Create new user
app.post('/users', (req, res) => {
  const { name, email } = req.body;
  
  if (!name || !email) {
    return res.status(400).json({ 
      error: 'Bad Request',
      message: 'Name and email are required' 
    });
  }

  const newUser = {
    id: (users.length + 1).toString(),
    name,
    email
  };
  
  users.push(newUser);
  res.status(201).json({ 
    message: 'User created successfully',
    user: newUser 
  });
});

// GET /users/{id} - Get specific user
app.get('/users/:id', (req, res) => {
  const user = users.find(u => u.id === req.params.id);
  
  if (user) {
    res.json({ user });
  } else {
    res.status(404).json({ 
      error: 'Not Found',
      message: 'User not found' 
    });
  }
});

// PUT /users/{id} - Update user
app.put('/users/:id', (req, res) => {
  const userIndex = users.findIndex(u => u.id === req.params.id);
  
  if (userIndex === -1) {
    return res.status(404).json({ 
      error: 'Not Found',
      message: 'User not found' 
    });
  }

  const { name, email } = req.body;
  if (name) users[userIndex].name = name;
  if (email) users[userIndex].email = email;

  res.json({ 
    message: 'User updated successfully',
    user: users[userIndex] 
  });
});

// DELETE /users/{id} - Delete user
app.delete('/users/:id', (req, res) => {
  const userIndex = users.findIndex(u => u.id === req.params.id);
  
  if (userIndex === -1) {
    return res.status(404).json({ 
      error: 'Not Found',
      message: 'User not found' 
    });
  }

  const deletedUser = users.splice(userIndex, 1)[0];
  res.json({ 
    message: 'User deleted successfully',
    user: deletedUser 
  });
});

// Start server
app.listen(PORT, '0.0.0.0', () => {
  console.log(` AWS API Gateway Simulator running on port ${PORT}`);
  console.log(` Health check: http://localhost:${PORT}/health`);
  console.log(` Available endpoints:`);
  console.log(`   GET  /hello`);
  console.log(`   GET  /users`);
  console.log(`   POST /users`);
  console.log(`   GET  /users/{id}`);
  console.log(`   PUT  /users/{id}`);
  console.log(`   DELETE /users/{id}`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM received, shutting down gracefully');
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('SIGINT received, shutting down gracefully');
  process.exit(0);
});
