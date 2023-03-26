import ballerina/io;
import ballerina/http;
listener http:Listener httpListener = new (8080);

map<string> headers = {
    "Accept": "application/vnd.github.v3+json",
    "Authorization": "Bearer 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",
    "X-GitHub-Api-Version":"2022-11-28"
};
 http:Client github = check new ("https://api.github.com");
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

//uncomment for make this a service 
service /getrepodetail on httpListener {

resource function get getrepodet(string ownername, string reponame) returns json|error {

   json[] data;
        json returnData;
        do {
            data = check github->get(searchUrl(ownername,reponame),headers);
            returnData = {
                ownername: ownername,
                reponame:reponame,
                commitCount: data.toString()
            };
        } on fail var e {
            returnData = {"message": e.toString()};
        }

        return returnData;  
    
 }
}


function  getrepos(string owner)returns json |error{
    json rpodata= check github->get(repoUrl(owner));
    io:print(rpodata);
}
 service /getrepos on httpListener{
 resource function get getrepos(string ownername)returns json |error{
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
function repoUrl(string owner)returns string{
   return "/users/" + owner + "/repos";
}

service /getpullrq on httpListener {

resource function get getCommitCount(string ownername, string reponame) returns json|error {

        json[] data;
        json returnData;
        do {
            data = check github->get("/repos/" + ownername + "/" + reponame + "/commits", headers);
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
            data = check github->get("/repos/" + ownername + "/" + reponame + "/pulls", headers);
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
