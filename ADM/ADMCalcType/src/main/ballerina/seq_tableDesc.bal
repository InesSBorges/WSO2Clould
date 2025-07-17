import ballerina/http;

service /tableDesc on new http:Listener(8084) {

    // POST: Create Table Description
    resource function post .(http:Caller caller, http:Request req) returns error? {
        json input = check req.getJsonPayload();

        // Simulate XSLT and enrichment steps
        string validUserLanguage = input.validUserLanguage.toString();
        string operationUser = input.operationUser.toString();
        json inputTableDesc = input;

        // Simulate call to seq_languageDesc (should call the actual service in production)
        int validIdLanguageDesc = 1;
        int validIdLanguage = 1;

        if validIdLanguageDesc < 1 {
            // Simulate error output and call to message/result output
            check caller->respond({
                validResultCode: input.validResultCode,
                validMessage: input.validMessage,
                validStatus: input.validStatus
            });
            return;
        }

        // Simulate payloadFactory and SOAP call to ds_ADMTableDesc
        json soapRequest = {
            Operation: "INSERT",
            IdLanguageDesc: validIdLanguageDesc,
            IdLanguage: validIdLanguage,
            OperationUser: operationUser,
            Active: input.active
        };

        // Simulate SOAP response
        json soapResponse = {
            result: 1,
            idOutput: 123
        };

        if soapResponse.result == 1 {
            check caller->respond({
                validIdTableDesc: soapResponse.idOutput
            });
        } else {
            check caller->respond({
                validResultCode: input.resutCode,
                validMessage: input.message,
                validStatus: input.status,
                rollbackLanguageDesc: true
            });
        }
    }

    // DELETE: Delete Table Description
    resource function delete .(http:Caller caller, http:Request req) returns error? {
        json input = check req.getJsonPayload();
        string idTableDesc = input.idTableDesc.toString();

        // Simulate SOAP getTableDesc call
        json getTableDescResponse = {
            IdTableDesc: idTableDesc,
            IdLanguageDesc: 1,
            IdLanguage: 1,
            TableDescLastUpdatedUser: "user",
            TableDescActive: true
        };

        if getTableDescResponse.IdTableDesc != "" {
            // Simulate enrich and property extraction
            int validIdLanguageDesc = getTableDescResponse.IdLanguageDesc;

            // Simulate SOAP deleteTableDesc call
            json deleteResponse = {
                result: 1
            };

            if deleteResponse.result == 1 {
                check caller->respond({
                    deleted: true,
                    idTableDesc: idTableDesc
                });
            } else {
                check caller->respond({
                    validResultCode: input.resutCode,
                    validMessage: input.message,
                    validStatus: input.status
                });
            }
        } else {
            check caller->respond({
                validResultCode: "SustIMS0151",
                validMessage: "OK",
                validStatus: "202"
            });
        }
    }

    // PUT: Update Table Description
    resource function put .(http:Caller caller, http:Request req) returns error? {
        json input = check req.getJsonPayload();
        string idTableDesc = input.idTableDesc.toString();

        // Simulate SOAP getTableDesc call
        json getTableDescResponse = {
            IdTableDesc: idTableDesc,
            IdLanguageDesc: 1,
            IdLanguage: 1
        };

        if getTableDescResponse.IdTableDesc != "" {
            // Simulate enrich and property extraction
            string idLanguageDesc = getTableDescResponse.IdLanguageDesc.toString();
            string idLanguage = getTableDescResponse.IdLanguage.toString();

            // Simulate SOAP updateTableDesc call
            json updateResponse = {
                result: 1
            };

            if updateResponse.result == 1 {
                check caller->respond({
                    updated: true,
                    idTableDesc: idTableDesc
                });
            } else {
                check caller->respond({
                    validResultCode: input.resutCode,
                    validMessage: input.message,
                    validStatus: input.status
                });
            }
        } else {
            check caller->respond({
                validResultCode: "SustIMS0151",
                validMessage: "OK",
                validStatus: "202"
            });
        }
    }