import ballerina/io;
import ballerina/http;

//type Resultset record {
//    json[] login;
//};
type Result record {
string owner;
int id;

};
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
    http:Client github = check new ("https://api.github.com");

    json search = check github->get(searchUrl(owner, reponame));
    return search;
}
//}

function  getrepos(string owner)returns json |error{
    http:Client git =check  new("https://api.github.com");
    json rpodata= check git->get(repoUrl(owner));
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
