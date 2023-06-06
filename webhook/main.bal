import ballerina/websub;
import ballerina/io;

// Create a subscriber service to listen to Github events
type Details record {
    
};

@websub:SubscriberServiceConfig {
    target: [
        "https://api.github.com/hub", 
        // Set the path to your Github repository
        "https://github.com/Piyumini1011/Temp/events/*.json" 
    ],
    // Set the ngrok callback URL 
    callback: "https://6671-2402-d000-811c-7b4a-18dd-31bd-21f7-f9b2.ngrok.io", 
    httpConfig: {
        auth: {
            // Set your GitHub Personal Access Token (PAT)
            token: "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" 
        }
    }
}

service /events on new websub:Listener(80) {
    remote function onEventNotification(websub:ContentDistributionMessage event) 
                                                                returns error? {

        var retrievedContent = event.content;
       //io:println(retrievedContent);
    if (retrievedContent is json) {
    var issue = retrievedContent.issue;
    var pull_request=retrievedContent.pull_request;
    //io:println(pull_request);
    //var comment=retrievedContent.pull_request.comments;
    //io:println(comment);
    if (issue is json) {
        var labels = issue.labels;
        if (labels is json[]) {
            boolean isBug = false;
            foreach var label in labels {
                if (label.name is string && label.name == "bug") {
                    isBug = true;
                    
                }
            }
            if (isBug) {
                io:println("Issue is a bug");
            } 
        }
    } else if (pull_request is json) {
        var state = pull_request.state;
        
        if(state is string){
            var isStatePrinted = false;
                        foreach var _ in state{
                if ( state == "open" && !isStatePrinted) {
                        io:println("One Pull request is opened");
                isStatePrinted = true;
                    }

                if ( state == "closed" && !isStatePrinted) {

                 io:println("One Pull request is closed");
                 isStatePrinted = true;
                    }
                }    
        }


                    
                
    
} else {
    io:println("Invalid content format");
}


        
    }
}
}
