const AWSXRay = require('aws-xray-sdk-core')
const AWS = AWSXRay.captureAWS(require('aws-sdk'))

/**
 *
 * Event doc: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html#api-gateway-simple-proxy-for-lambda-input-format
 * @param {Object} event - API Gateway Lambda Proxy Input Format
 *
 * Context doc: https://docs.aws.amazon.com/lambda/latest/dg/nodejs-prog-model-context.html 
 * @param {Object} context
 *
 * Return doc: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html
 * @returns {Object} object - API Gateway Lambda Proxy Output Format
 * 
 */
exports.lambdaHandler = async (event, context) => {
    try {
        console.log('Event:', JSON.stringify(event, null, 2));
        
        const method = event.httpMethod;
        const headers = event.headers || {};
        const queryParams = event.queryStringParameters || {};
        const body = event.body ? JSON.parse(event.body) : null;
        
        let response;
        
        if (method === 'GET') {
            response = {
                message: 'Hello World from AWS SAM Local!',
                timestamp: new Date().toISOString(),
                requestId: context.awsRequestId,
                method: method,
                queryParams: queryParams,
                headers: {
                    'user-agent': headers['User-Agent'] || headers['user-agent'],
                    'host': headers['Host'] || headers['host']
                }
            };
        } else if (method === 'POST') {
            response = {
                message: 'Hello World POST received!',
                timestamp: new Date().toISOString(),
                requestId: context.awsRequestId,
                method: method,
                receivedData: body,
                queryParams: queryParams
            };
        }

        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
                'Access-Control-Allow-Headers': 'Content-Type, Authorization'
            },
            'body': JSON.stringify(response)
        }
    } catch (err) {
        console.log(err);
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': JSON.stringify({
                message: 'Internal server error',
                error: err.message
            })
        }
    }
};
