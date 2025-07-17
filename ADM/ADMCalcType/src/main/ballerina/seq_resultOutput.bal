import ballerina/http;

service /resultOutput on new http:Listener(8083) {

    resource function post .(http:Caller caller, http:Request req) returns error? {
        json payload = check req.getJsonPayload();

        // Extract values from payload or set defaults
        string validStatus = <string>payload.validStatus.cloneWithType("string", "null");
        string validId = <string>payload.validId.cloneWithType("string", "null");
        string validResultCode = <string>payload.validResultCode.cloneWithType("string", "");
        string validMessageDescription = <string>payload.validMessageDescription.cloneWithType("string", "");
        string validClientMessageDescription = <string>payload.validClientMessageDescription.cloneWithType("string", "");
        string validMessage = <string>payload.validMessage.cloneWithType("string", "");
        int totalRecords = payload.totalRecords is int ? <int>payload.totalRecords : 0;
        int totalErrors = payload.totalErrors is int ? <int>payload.totalErrors : 1;

        // Compose timestamp
        string timestamp = time:format(time:currentTime(), "yyyy-MM-dd'T'HH:mm:ss.SSSXXX");

        // If validId contains '_', treat as array of ids (simulate original logic)
        boolean isArray = validId.contains("_");

        json result;
        if isArray {
            result = {
                result: {
                    timestamp: timestamp,
                    resultCode: validResultCode,
                    messageDescription: validMessageDescription,
                    clientMessageDescription: validClientMessageDescription,
                    totalRecords: totalRecords,
                    totalErrors: totalErrors,
                    message: validMessage,
                    status: validStatus,
                    id: validId.split("_")
                }
            };
        } else {
            result = {
                result: {
                    timestamp: timestamp,
                    resultCode: validResultCode,
                    messageDescription: validMessageDescription,
                    clientMessageDescription: validClientMessageDescription,
                    totalRecords: totalRecords,
                    totalErrors: totalErrors,
                    message: validMessage,
                    status: validStatus,
                    id: [validId]
                }
            };
        }

        check caller