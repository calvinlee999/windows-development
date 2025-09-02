/**
 * User management Lambda function for AWS SAM Local
 */
exports.lambdaHandler = async (event, context) => {
    try {
        console.log('User Function Event:', JSON.stringify(event, null, 2));
        
        const method = event.httpMethod;
        const pathParameters = event.pathParameters || {};
        const queryParams = event.queryStringParameters || {};
        const body = event.body ? JSON.parse(event.body) : null;
        const userId = pathParameters.id;
        
        // Mock user data
        const mockUsers = {
            '1': { id: 1, name: 'John Doe', email: 'john@example.com', role: 'admin' },
            '2': { id: 2, name: 'Jane Smith', email: 'jane@example.com', role: 'user' },
            '3': { id: 3, name: 'Bob Johnson', email: 'bob@example.com', role: 'user' }
        };
        
        let response;
        
        switch (method) {
            case 'GET':
                if (userId) {
                    const user = mockUsers[userId];
                    if (user) {
                        response = {
                            success: true,
                            data: user,
                            message: `User ${userId} retrieved successfully`
                        };
                    } else {
                        return {
                            'statusCode': 404,
                            'headers': { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
                            'body': JSON.stringify({
                                success: false,
                                message: `User ${userId} not found`
                            })
                        };
                    }
                } else {
                    response = {
                        success: true,
                        data: Object.values(mockUsers),
                        message: 'All users retrieved successfully'
                    };
                }
                break;
                
            case 'POST':
                const newUser = {
                    id: Math.floor(Math.random() * 1000),
                    ...body,
                    createdAt: new Date().toISOString()
                };
                response = {
                    success: true,
                    data: newUser,
                    message: 'User created successfully'
                };
                break;
                
            case 'PUT':
                if (userId && mockUsers[userId]) {
                    const updatedUser = {
                        ...mockUsers[userId],
                        ...body,
                        updatedAt: new Date().toISOString()
                    };
                    response = {
                        success: true,
                        data: updatedUser,
                        message: `User ${userId} updated successfully`
                    };
                } else {
                    return {
                        'statusCode': 404,
                        'headers': { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
                        'body': JSON.stringify({
                            success: false,
                            message: `User ${userId} not found`
                        })
                    };
                }
                break;
                
            case 'DELETE':
                if (userId && mockUsers[userId]) {
                    response = {
                        success: true,
                        message: `User ${userId} deleted successfully`
                    };
                } else {
                    return {
                        'statusCode': 404,
                        'headers': { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
                        'body': JSON.stringify({
                            success: false,
                            message: `User ${userId} not found`
                        })
                    };
                }
                break;
                
            default:
                return {
                    'statusCode': 405,
                    'headers': { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
                    'body': JSON.stringify({
                        success: false,
                        message: 'Method not allowed'
                    })
                };
        }

        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
                'Access-Control-Allow-Headers': 'Content-Type, Authorization'
            },
            'body': JSON.stringify({
                ...response,
                timestamp: new Date().toISOString(),
                requestId: context.awsRequestId,
                method: method
            })
        };
    } catch (err) {
        console.log(err);
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': JSON.stringify({
                success: false,
                message: 'Internal server error',
                error: err.message
            })
        };
    }
};
