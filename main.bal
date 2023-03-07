import ballerina/io;
import ballerina/http;
listener http:Listener httpListener =new (8080);
map<string> headers = {
    "Accept": "application/vnd.github.v3+json",
    "Authorization": "Bearer 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",
    "X-GitHub-Api-Version":"2022-11-28"
};
 http:Client github = check new ("https://api.github.com");
//just for the testing main is implemented
public function main() returns error?? {
    string Owner = "DuminduHarshana";
    string Reponame = "aeroAndroidApp";
    json|error repodet = getrepodet(Owner, Reponame);
    if repodet is json {
       io:print(repodet);
        
    // Result result = check repodet.cloneWithType();
    // io:print(result.owner);
    }
    json|error repos = getrepos(Owner);
    if repos is json {
      io:print(repos);


    }

}

//uncomment for make this a service 
//service /getrepodetail on new http:Listener(8080) {

function getrepodet(string owner, string reponame) returns json|error {

    //connecting github with http client
   

    json search = check github->get(searchUrl(owner, reponame));
    return search;
}
//}

function  getrepos(string owner)returns json |error{
    json rpodata= check github->get(repoUrl(owner));
    io:print(rpodata);
}
// service /getrepos on new http:Listener(8081){
// resource function get getrepos(string owner)returns string |error{
//     http:Client git =check  new("https://api.github.com");
//     json rpodata= check git->get(repoUrl(owner));
//     string data = rpodata.toBalString();
//     return data;
// }

// }

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
