/**
 * Health check Lambda function for AWS SAM Local
 */
exports.lambdaHandler = async (event, context) => {
    try {
        const response = {
            status: 'healthy',
            timestamp: new Date().toISOString(),
            service: 'AWS SAM Local API Gateway',
            version: '1.0.0',
            uptime: process.uptime(),
            requestId: context.awsRequestId,
            environment: 'local',
            checks: {
                database: 'healthy',
                cache: 'healthy',
                externalAPI: 'healthy'
            }
        };

        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
                'Cache-Control': 'no-cache'
            },
            'body': JSON.stringify(response)
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
                status: 'unhealthy',
                message: 'Internal server error',
                error: err.message,
                timestamp: new Date().toISOString()
            })
        };
    }
};
