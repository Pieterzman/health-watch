export type AmplifyDependentResourcesAttributes = {
    "auth": {
        "healthwatchapp5a4a01f2": {
            "IdentityPoolId": "string",
            "IdentityPoolName": "string",
            "UserPoolId": "string",
            "UserPoolArn": "string",
            "UserPoolName": "string",
            "AppClientIDWeb": "string",
            "AppClientID": "string",
            "CreatedSNSRole": "string"
        }
    },
    "api": {
        "healthwatchapp": {
            "GraphQLAPIIdOutput": "string",
            "GraphQLAPIEndpointOutput": "string"
        }
    },
    "storage": {
        "S3HealthData": {
            "BucketName": "string",
            "Region": "string"
        }
    }
}