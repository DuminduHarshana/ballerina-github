import ballerina/io;
import ballerina/http;

listener http:Listener httpListener = new (8080);
listener http:Listener gitListener = new (9090);
json token = {};
// map<string> headers = {
//     "Accept": "application/vnd.github.v3+json",
//     "Authorization": "Bearer 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",
//     "X-GitHub-Api-Version":"2022-11-28"
// };
http:Client github = check new ("https://api.github.com");
string BASE_URL = "https://api.github.com";

string USER_RESOURCE_PATH = "/user";

//just for the testing main is implemented
// public function main() returns error?? {
//     string Owner = "DuminduHarshana";
//     string Reponame = "aeroAndroidApp";
//     json|error repodet = getrepodet(Owner, Reponame);
//     if repodet is json {
//        io:print(repodet);

//     // Result result = check repodet.cloneWithType();
//     // io:print(result.owner);
//     }
//     json|error repos = getrepos(Owner);
//     if repos is json {
//       io:print(repos);

//     }

// }

@http:ServiceConfig {

    cors: {
        allowOrigins: ["http://localhost:3000"],
        allowCredentials: true,
        allowMethods: ["GET", "POST", "OPTIONS"]
    }
}

service / on gitListener {

    resource function post githubLogin(http:Caller caller, http:Request req) returns error? {

        // Extract the token from the request body
        var jsonPayload = check req.getJsonPayload();
        json token = check jsonPayload.token;
        io:print(token);
       

        check caller->respond(token);

    }
}
 string OAUTH_TOKEN=token.toString();
// service / on httpListener {
//     resource function get token(string code) returns json|error {
//         http:Client client2 = check new("https://github.com");
//         string clientId = "00bba9c289b344fd4277";
//         string clientSecret = "a6d137fa4ac43ca8ef77d5673cce9026a84a7e3d";

//         http:Request request = new;
//         request.addHeader("Content-Type", "application/json");
//         json[] data;
//         json payload;
//         do {
//             data = check client2->get("/oauth/access_token?client_id="+clientId+"&client_secret="+clientSecret+"&code="+code);
//            string accessToken = data.toString();
//           io:print(accessToken);

//         } on fail var e {
//             payload = {"message": e.toString()};
//         }
//         return payload;
//     }
// }

service /githubApi on httpListener {

    resource function post getUserInfo(http:Caller caller, http:Request req) returns error? {
        map<string|string[]> headers = {"Authorization": "Bearer " + OAUTH_TOKEN};
        http:Response response = check github->get(USER_RESOURCE_PATH, headers);
        io:println(response.getJsonPayload());
        check caller->respond(response);
    }
}

service /getrepodetail on httpListener {

    resource function get getrepodet(string ownername, string reponame) returns json|error {

        json[] data;
        json returnData;
        do {
            data = check github->get(searchUrl(ownername, reponame));
            returnData = {
                ownername: ownername,
                reponame: reponame,
                commitCount: data.toString()
            };
        } on fail var e {
            returnData = {"message": e.toString()};
        }

        return returnData;

    }
}

function getrepos(string owner) returns json|error {
    json rpodata = check github->get(repoUrl(owner));
    io:print(rpodata);
}

service /getrepos on httpListener {
    resource function get getrepos(string ownername) returns json|error {
        json[] data;
        json returnData;
        do {
            data = check github->get("/users/" + ownername + "/repos");
            returnData = {
                ownername: ownername,
                reponame: data.toString()
            };
        } on fail var e {
            returnData = {"message": e.toString()};
        }

        return returnData;

    }

}

//function for appeding owner name and reponame
function searchUrl(string owner, string reponame) returns string {
    return "/repos/" + owner + "/" + reponame + "";

}

function repoUrl(string owner) returns string {
    return "/users/" + owner + "/repos";
}

service /getpullrq on httpListener {

    resource function get getCommitCount(string ownername, string reponame) returns json|error {

        json[] data;
        json returnData;
        do {
            data = check github->get("/repos/" + ownername + "/" + reponame + "/commits");
            returnData = {
                ownername: ownername,
                reponame: reponame,
                commitCount: data.length()
            };
        } on fail var e {
            returnData = {"message": e.toString()};
        }

        return returnData;
    }

    resource function get getPullRequestCount(string ownername, string reponame) returns json|error {

        json[] data;
        json returnData;
        do {
            data = check github->get("/repos/" + ownername + "/" + reponame + "/pulls");
            returnData = {
                ownername: ownername,
                reponame: reponame,
                PullRequestCount: data.length()
            };
        } on fail var e {
            returnData = {"message": e.toString()};
        }

        return returnData;
    }
}