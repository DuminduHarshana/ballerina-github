import ballerina/http;
import ballerina/mime;
import ballerina/io;

listener http:Listener gitListener = new (9090);

http:Client github = check new ("https://github.com");

@http:ServiceConfig {

    cors: {
        allowOrigins: ["http://localhost:3000"],
        allowCredentials: true,
        allowMethods: ["GET", "POST", "OPTIONS"]
    }
}

service / on gitListener {

    resource function post githubLogin(@http:Payload map<json> token) returns json|error {
        string clientId = "00bba9c289b344fd4277";
        string clientSecret = "a6d137fa4ac43ca8ef77d5673cce9026a84a7e3d";
        string code = check token.token;
        json returnData = {};
        do {
            json response = check github->post("/login/oauth/access_token",
            {

                client_id: clientId,
                client_secret: clientSecret,
                code: code
            },
            {
                Accept: mime:APPLICATION_JSON
            });

            returnData = {
                res: response

            };
            string j = check response.access_token;
            io:print(j);
            
        } on fail var err {
            returnData = {
                "message": err.toString()
            };
        }
        return returnData;
    }
}
