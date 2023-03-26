import ballerina/http;
import ballerina/io;


 listener http:Listener gitListener =new (9090);
@http:ServiceConfig {
  
    cors: {
        allowOrigins: ["http://localhost:3000"],
        allowCredentials: true,
        allowMethods: ["GET", "POST", "OPTIONS"]
    }
}

service / on gitListener{
    
    resource function post githubLogin(http:Caller caller, http:Request req) returns error? {
       
        // Extract the token from the request body
        var jsonPayload = check req.getJsonPayload();
        json|error token = jsonPayload.token;
        // Perform any processing necessary with the token
        io:print(token);
        // Send a response back to the frontend
        
        check  caller->respond(token);
    }
}