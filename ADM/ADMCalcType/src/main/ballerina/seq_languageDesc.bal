import ballerina/http;

service /languageDesc on new http:Listener(8081) {

    // POST: Create Language Description
    resource function post .(http:Caller caller, http:Request req) returns error? {
        json input = check req.getJsonPayload();

        // Simulate transformation and enrichment (XSLT, enrich, etc.)
        json inputLanguageDesc = input;

        // Simulate call to seq_language (should call the actual service in production)
        // Here, just mock a validIdLanguage for demonstration
        int validIdLanguage = 1;

        // Simulate DB call to ds_ADMLanguageDesc (replace with actual HTTP client call)
        json dbResponse = {
            result: 1,
            idOutput: "123"
        };

        if dbResponse.result == 1 {
            check caller->respond({
                validIdLanguageDesc: dbResponse.idOutput
            });
        } else {
            check caller->respond({
                validResultCode: dbResponse.resutCode,
                validMessage: dbResponse.message,
                validStatus: dbResponse.status
            });
        }
    }

    // DELETE: Delete Language Description
    resource function delete .(http:Caller caller, http:Request req) returns error? {
        json input = check req.getJsonPayload();
        string idLanguageDesc = <string>input.idLanguageDesc;

        // Simulate DB call to ds_ADMLanguageDesc for delete
        json dbResponse = {
            result: 1
        };

        if dbResponse.result == 1 {
            check caller->respond({
                validIdLanguageDesc: idLanguageDesc
            });
        } else {
            check caller->respond({
                validResultCode: dbResponse.resutCode,
                validMessage: dbResponse.message,
                validStatus: dbResponse.status
            });
        }
    }

    // PUT: Update Language Description
    resource function put .(http:Caller caller, http:Request req) returns error? {
        json input = check req.getJsonPayload();

        // Simulate transformation and enrichment (XSLT, enrich, etc.)
        json inputLanguageDesc = input;

        // Simulate call to seq_language (should call the actual service in production)
        int validIdLanguage = 1;

        // Simulate DB get
        json dbGetResponse = {
            IdLanguageDesc: 1
        };

        if dbGetResponse.IdLanguageDesc >= 1 {
            check caller->respond({
                resultInput: inputLanguageDesc,
                resultDB: dbGetResponse
            });
        } else {
            check caller->respond({
                validResultCode: "SustIMS0151",
                validMessage: "OK",
                validStatus: "202"