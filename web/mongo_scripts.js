require('dotenv').config();
const express = require('express');
const { MongoClient } = require('mongodb');
const cors = require('cors'); // Add CORS package
const app = express();
const port = process.env.PORT || 3000;
const uri = process.env.MONGODB_URI || "mongodb+srv://abdman0095:TaMShId6GDbbVshL@cluster0.ojbm5cy.mongodb.net/";

// Enhanced CORS configuration
const corsOptions = {
  origin: [
    'http://localhost',          // Local development
    'http://localhost:8080',     // Common Flutter web port
    'http://192.168.*',          // Local network (adjust as needed)
    'http://localhost:55231/' // Production domain
  ],
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true
};

app.use(cors(corsOptions));
app.use(express.json());

// Security middleware
app.use((req, res, next) => {
  res.header('X-Content-Type-Options', 'nosniff');
  res.header('X-Frame-Options', 'DENY');
  next();
});

// GET all customers with error handling
app.get('/customers', async (req, res) => {
  const client = new MongoClient(uri, {
    connectTimeoutMS: 5000,
    serverSelectionTimeoutMS: 5000
  });

  try {
    await client.connect();
    const customers = await client.db("bank_portal")
      .collection("customers")
      .find()
      .project({ _id: 0 }) // Exclude MongoDB _id from response
      .toArray();
      
    res.json({
      success: true,
      data: customers,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    console.error('Database error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch customers',
      details: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  } finally {
    await client.close().catch(err => console.error('Connection close error:', err));
  }
});

// POST new customer with validation
app.post('/customers', async (req, res) => {
  // Basic validation
  if (!req.body.CustomerID || !req.body.FullName) {
    return res.status(400).json({
      success: false,
      error: 'Missing required fields: CustomerID and FullName'
    });
  }

  const client = new MongoClient(uri);
  try {
    await client.connect();
    
    // Check for duplicate CustomerID
    const existingCustomer = await client.db("bank_portal")
      .collection("customers")
      .findOne({ CustomerID: req.body.CustomerID });

    if (existingCustomer) {
      return res.status(409).json({
        success: false,
        error: 'Customer with this ID already exists'
      });
    }

    // Add metadata
    const customerData = {
      ...req.body,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      KYC_Status: req.body.KYC_Status || 'Pending',
      RiskCategory: req.body.RiskCategory || 'Low'
    };

    const result = await client.db("bank_portal")
      .collection("customers")
      .insertOne(customerData);

    res.status(201).json({
      success: true,
      id: result.insertedId,
      CustomerID: customerData.CustomerID
    });
  } catch (error) {
    console.error('Database error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to create customer'
    });
  } finally {
    await client.close().catch(err => console.error('Connection close error:', err));
  }
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    database: 'connected' // You could add actual DB ping here
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Server error:', err);
  res.status(500).json({
    success: false,
    error: 'Internal server error'
  });
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
  console.log(`CORS-enabled for: ${corsOptions.origin.join(', ')}`);
});