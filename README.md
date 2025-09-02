#  Local Development Infrastructure

> **Comprehensive local development environment with databases, message brokers, API gateways, and AWS simulation**

[![Docker](https://img.shields.io/badge/Docker-20.10+-blue?style=flat-square&logo=docker)](https://docker.com)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15+-green?style=flat-square&logo=postgresql)](https://postgresql.org)
[![Kafka](https://img.shields.io/badge/Apache_Kafka-3.0+-orange?style=flat-square&logo=apache-kafka)](https://kafka.apache.org)
[![AWS](https://img.shields.io/badge/AWS_Simulation-LocalStack+SAM-yellow?style=flat-square&logo=amazon-aws)](https://localstack.cloud)

This project provides a complete local development infrastructure using Docker Compose, featuring databases, message brokers, API gateways, AWS simulation, and development tools optimized for modern application development.

##  **Infrastructure Status: PRODUCTION READY**

###  **Active Services**
| Service | Status | Port | Management UI | Credentials |
|---------|--------|------|---------------|-------------|
| **LocalStack (AWS Services)** |  Running | 3000 | Web UI Available | - |
| **AWS SAM CLI (Node.js 18)** |  Running | 3001 | Container Ready | - |
| **Nginx Microservices Gateway** |  Running | 8090/8091 | :8091 | - |
| **PostgreSQL** |  Available | 5432 | :5050 | devuser/devpass |
| **MongoDB** |  Available | 27017 | :8081 | admin/admin123 |
| **Redis** |  Available | 6379 | :8082 | devpass |
| **Apache Kafka** |  Available | 9092 | :9021 | - |
| **RabbitMQ** |  Available | 5672 | :15672 | devuser/devpass |

##  **Validated Components**

###  **AWS Simulation Stack (Fully Operational)**
`
 LocalStack: Comprehensive AWS service simulation
 SAM CLI: Official AWS serverless development
 Services: S3, DynamoDB, Lambda, SageMaker, Bedrock, CloudFront
 Network: Integrated with infrastructure network
 Status: Both containers healthy and accessible
`

**LocalStack Available Services:**
- **S3**: Object storage simulation
- **DynamoDB**: NoSQL database simulation  
- **Lambda**: Serverless function execution
- **SageMaker**: ML model development
- **Bedrock**: AI/ML services simulation
- **CloudFront**: CDN simulation
- **API Gateway**: REST/GraphQL APIs
- **And 50+ more AWS services**

###  **Nginx Microservices Gateway (Production Ready)**
`
 Health Check: nginx gateway healthy
 Admin Interface: Full management UI
 Routing: /api/users/, /api/orders/, /api/payments/
 CORS: Enabled for development
 Load Balancing: Ready for backend services
`

**Gateway Endpoints:**
- **Main Gateway**: http://localhost:8090
- **Admin Interface**: http://localhost:8091
- **Health Check**: http://localhost:8090/health
- **Gateway Status**: http://localhost:8091/gateway/status

###  **Docker Infrastructure**
- **Network**: local-infrastructure_default bridge
- **Volumes**: Persistent data storage for all services
- **Health Checks**: Monitoring for all containers
- **Auto-restart**: Unless stopped policy for reliability
- **Email Config**: cloudycat999@gmail.com

##  **Quick Start**

### Prerequisites
- Docker Desktop 20.10+
- PowerShell 5.1+ or PowerShell Core 7+
- 8GB+ available RAM (32GB system recommended)
- 20GB+ available disk space

### Start Development Environment
`powershell
# Clone and navigate to repository
git clone https://github.com/calvinlee999/windows-development.git
cd windows-development

# Start all core services
.\stable-infra.ps1 start

# Verify all services
.\stable-infra.ps1 status

# Test complete infrastructure
.\stable-infra.ps1 health
`

### Quick Service Commands
`powershell
# Start infrastructure with stable ports
.\stable-infra.ps1 start

# Check detailed status
.\stable-infra.ps1 status

# Restart specific services
.\stable-infra.ps1 restart

# Health check all services
.\stable-infra.ps1 health

# Stop all services
.\stable-infra.ps1 stop

# Complete cleanup
.\stable-infra.ps1 clean
`

##  **Service Details**

###  **Databases**

#### PostgreSQL
- **Connection**: postgresql://devuser:devpass@localhost:5432/devdb
- **Admin UI**: http://localhost:5050 (admin@dev.local / admin)
- **Multiple DBs**: devdb, testdb, apidb, microservices_db
- **Health Check**: Built-in monitoring

#### MongoDB
- **Connection**: mongodb://admin:admin123@localhost:27017
- **Admin UI**: http://localhost:8081
- **Credentials**: admin / admin123
- **Collections**: Auto-created on demand

#### Redis
- **Connection**: redis://:devpass@localhost:6379
- **Admin UI**: http://localhost:8082
- **Use Cases**: Caching, sessions, pub/sub

###  **Message Brokers**

#### Apache Kafka
- **Bootstrap Server**: localhost:9092
- **Management UI**: http://localhost:9021
- **Topics**: Auto-created on first message
- **Use Cases**: Event streaming, microservices communication

#### RabbitMQ
- **AMQP URL**: amqp://devuser:devpass@localhost:5672/dev
- **Management UI**: http://localhost:15672
- **Queues**: Auto-created, persistent storage

###  **API Gateways & AWS Simulation**

#### LocalStack (AWS Services)
- **Base URL**: http://localhost:3000
- **Features**: 50+ AWS services simulation
- **S3 Endpoint**: http://localhost:3000
- **DynamoDB**: Full NoSQL simulation
- **Lambda**: Local function execution
- **SageMaker**: ML development environment
- **Bedrock**: AI services simulation

#### AWS SAM CLI (Official)
- **Container**: aws-sam-nodejs18 (Node.js 18)
- **Port**: 3001 (ready for sam local start-api)
- **Use Cases**: Official AWS Lambda development
- **Commands**: sam build, sam local start-api, sam deploy

#### Nginx Microservices Gateway
- **Main Gateway**: http://localhost:8090
- **Admin Interface**: http://localhost:8091
- **Routes**: 
  - /api/users/  Backend port 8001
  - /api/orders/  Backend port 8002  
  - /api/payments/  Backend port 8003
- **CORS**: Enabled for frontend development
- **Features**: Load balancing, health checks, admin UI

##  **Testing & Validation**

### Infrastructure Health Check
`powershell
.\stable-infra.ps1 health
`

**Sample Output:**
`
 Infrastructure Health Check
================================

 PostgreSQL: Healthy (Port 5432)
 MongoDB: Healthy (Port 27017) 
 Redis: Healthy (Port 6379)
 Kafka: Healthy (Port 9092)
 RabbitMQ: Healthy (Port 5672)
 LocalStack: Healthy (Port 3000)
 AWS SAM CLI: Ready (Port 3001)
 Nginx Gateway: Healthy (Port 8090)

 All 8 services are operational
 Admin UIs: All accessible
`

### AWS Services Testing
`powershell
# Test LocalStack S3
aws --endpoint-url=http://localhost:3000 s3 mb s3://test-bucket

# Test Lambda with SAM CLI
docker exec -it aws-sam-nodejs18 sam --version

# Test Nginx Gateway
curl http://localhost:8090/health
`

##  **Development Usage**

### Environment Variables
`ash
# Database Connections
DATABASE_URL=postgresql://devuser:devpass@localhost:5432/devdb
MONGODB_URL=mongodb://admin:admin123@localhost:27017
REDIS_URL=redis://:devpass@localhost:6379

# Message Brokers
KAFKA_BROKERS=localhost:9092
RABBITMQ_URL=amqp://devuser:devpass@localhost:5672/dev

# AWS Simulation
AWS_ENDPOINT_URL=http://localhost:3000
AWS_DEFAULT_REGION=us-east-1
AWS_ACCESS_KEY_ID=test
AWS_SECRET_ACCESS_KEY=test

# API Gateway
NGINX_GATEWAY_URL=http://localhost:8090
GATEWAY_ADMIN_URL=http://localhost:8091

# Contact
DEV_EMAIL=cloudycat999@gmail.com
`

### AWS Local Development
`javascript
// Node.js with LocalStack
const AWS = require('aws-sdk');

const s3 = new AWS.S3({
  endpoint: 'http://localhost:3000',
  accessKeyId: 'test',
  secretAccessKey: 'test',
  s3ForcePathStyle: true
});

// DynamoDB Local
const dynamodb = new AWS.DynamoDB({
  endpoint: 'http://localhost:3000',
  region: 'us-east-1'
});
`

### Microservices with Nginx Gateway
`javascript
// Frontend API calls through gateway
const apiClient = axios.create({
  baseURL: 'http://localhost:8090'
});

// Route to different services
const users = await apiClient.get('/api/users/');
const orders = await apiClient.get('/api/orders/');
const payments = await apiClient.post('/api/payments/', paymentData);
`

### SAM CLI Development
`ash
# Initialize SAM project
docker exec -it aws-sam-nodejs18 sam init

# Build and test locally  
docker exec -it aws-sam-nodejs18 sam build
docker exec -it aws-sam-nodejs18 sam local start-api --host 0.0.0.0
`

##  **Performance & Monitoring**

### Resource Usage (32GB System)
- **Memory**: ~6GB for full stack (18% of 32GB)
- **CPU**: Intel Core Ultra 9 185H (22 cores) - minimal usage
- **Storage**: ~15GB including images and volumes
- **Network**: Bridge network with service discovery

### Health Monitoring
`powershell
# Check all container health
docker ps --format "table {{.Names}}\t{{.Status}}"

# Monitor resource usage
docker stats

# View service logs
docker-compose logs -f localstack
docker logs nginx-gateway
`

##  **Architecture Overview**

`
        
   Frontend            Nginx Gateway        Microservices  
   (Port 3000+)    (Port 8090)      (Port 8001+)   
        
                                
                                

                    Core Infrastructure                          

   Databases       Message Queues       AWS Simulation         
                                                               
  PostgreSQL      Kafka           LocalStack (Port 3000)    
   (Port 5432)      (Port 9092)     SAM CLI (Port 3001)       
  MongoDB         RabbitMQ        S3, DynamoDB, Lambda      
   (Port 27017)     (Port 5672)     SageMaker, Bedrock        
  Redis                                                       
   (Port 6379)                                                 

`

##  **Troubleshooting**

### Common Issues

#### Port Conflicts
`powershell
# Check what's using a port
netstat -ano | findstr :3000

# All ports are fixed - no more random ports!
# PostgreSQL: 5432, MongoDB: 27017, Redis: 6379
# Kafka: 9092, RabbitMQ: 5672, LocalStack: 3000
# SAM CLI: 3001, Nginx: 8090/8091
`

#### Service Won't Start
`powershell
# Check container logs
docker logs container-name

# Restart specific service
docker restart container-name

# Complete infrastructure restart
.\stable-infra.ps1 restart
`

#### LocalStack Issues
`powershell
# Check LocalStack health
curl http://localhost:3000/health

# View LocalStack logs
docker logs aws-api-simulator

# Reset LocalStack data
docker restart aws-api-simulator
`

### Performance Optimization
`powershell
# System cleanup
docker system prune -f

# Monitor resources
.\stable-infra.ps1 status

# Start only needed services (modify docker-compose.yml)
`

##  **Security Considerations**

### Development-Only Setup
-  **DO NOT use in production**
- Default passwords are for development only
- No SSL/TLS encryption configured
- Open network policies for development convenience

### Secure Development Practices
- Use environment variables for configuration
- Different credentials for production environments
- Regular security updates for base images
- Implement proper authentication in applications

##  **Contributing**

### Adding New Services
1. Add service to docker-compose.yml
2. Update stable-infra.ps1 management script
3. Add health checks and monitoring
4. Create test scripts for functionality
5. Update README with configuration details

### Development Workflow
`powershell
# 1. Make changes to configuration
# 2. Test changes
.\stable-infra.ps1 health

# 3. Commit changes
git add .
git commit -m "feat: enhance infrastructure setup"
git push origin main
`

##  **Changelog**

### September 2025 - Major Infrastructure Update
-  **LocalStack Integration**: Complete AWS services simulation
-  **AWS SAM CLI**: Official Node.js 18 serverless development
-  **Nginx Gateway**: Production-ready microservices routing
-  **Stable Ports**: Fixed port configuration eliminates conflicts
-  **Ultra-Stable Setup**: Persistent volumes and restart policies
-  **MongoDB Auth**: Fixed admin/admin123 credentials
-  **Email Integration**: cloudycat999@gmail.com configuration
-  **32GB System**: Optimized for high-performance development
-  **Management Scripts**: Complete PowerShell automation suite

### Previous Versions
- Database services with management UIs
- Message broker integration
- Docker Compose orchestration
- PowerShell management tools

##  **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

##  **Related Projects**

- [Windows Development](https://github.com/calvinlee999/windows-development) - This repository
- [Windows Dotfiles](https://github.com/calvinlee999/dotfiles) - PowerShell development environment

---

** Happy Local Development!**

*For questions or issues, please open a GitHub issue or contact cloudycat999@gmail.com*

---
**System Specs**: Intel Core Ultra 9 185H (22 cores), 32GB RAM, 3.4+ TB Storage
**Infrastructure Email**: cloudycat999@gmail.com
**Last Updated**: September 2, 2025
