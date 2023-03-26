import ballerina/http;
import ballerina/io;
import ballerina/time;

listener http:Listener httpListener = new(8080);

map<string> headers = {
    "Accept": "application/vnd.github.v3+json",
    "Authorization": "Bearer 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",
    "X-GitHub-Api-Version":"2022-11-28"
};

http:Client github = check new ("https://api.github.com");

service /individual on httpListener {
    resource function get getMeanPullRequestApprovedTime(string ownername, string reponame) returns json|error {

        json[] data = [];
        json returnData;
        int totalTime = 0;
        int count = 0;

        do{            
            data = check github->get("/repos/" + ownername + "/" + reponame + "/pulls");

            foreach json item in data{
                if (item.approved_at != null) {
                    time:Utc t1 = check time:utcFromString(check item.created_at);
                    time:Utc t2 = check time:utcFromString(check item.approved_at);
                    int timeDiff = (t2[0] - t1[0]);
                    io:println("Lead Time for pull request ", count, " is ", timeDiff, " seconds");
                    totalTime += timeDiff;
                    count = count + 1;
                }
            }

            if (count == 0) {
                returnData = {"message": "No pull requests with approved_at timestamp found for the repository"};
            } else {
                int meanResponseTime = (totalTime/count);

                string timeInHours = (meanResponseTime/3600).toString();
                string timeinMinutes = ((meanResponseTime%3600)/60).toString();
                string timeinSeconds = (meanResponseTime%60).toString();

                io:println("Mean Lead Time response for a pull request = ",meanResponseTime);
                returnData = {
                    meanResponseTimeInFormat :timeInHours + "hrs  " + timeinMinutes+ "min "  + timeinSeconds + "secs",
                    ownername: ownername   
                };
            }

        } on fail var e {
            returnData = {"message": e.toString()};
        }

        return returnData;
    }
}
