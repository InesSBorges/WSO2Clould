import ballerina/http;
import ballerinax/mssql;

service /validateUserLanguage on new http:Listener(8085) {

    // Update these values or use config/secrets for production
    mssql:Client dbClient = check new ({
        host: "localhost",
        port: 1433,
        database: "your_db",
        user: "your_user",
        password: "your_password"
    });

    resource function post .(http:Caller caller, http:Request req) returns error? {
        json payload = check req.getJsonPayload();
        string userLanguage = <string>payload.userLanguage.cloneWithType("string", "");
        string operationUser = <string>payload.operationUser.cloneWithType("string", "");

        // Validate userLanguage value
        if userLanguage == "" || userLanguage == "<userLanguage/>" || userLanguage == "<userLanguage></userLanguage>" {
            userLanguage = "";
        }

        if operationUser != "" {
            // Call stored procedure ADM.ValidateUserLanguage
            string sql = "DECLARE @result VARCHAR(100), @resutCode VARCHAR(100), @message VARCHAR(100), @status INT, @languageOut VARCHAR(100) " +
                         "EXEC ADM.ValidateUserLanguage ?, ?, @result OUTPUT, @resutCode OUTPUT, @message OUTPUT, @status OUTPUT, @languageOut OUTPUT; " +
                         "SELECT @result AS result, @resutCode AS resutCode, @message AS message, @status AS status, @languageOut AS languageOut;";

            var result = dbClient->query(sql, operationUser, userLanguage);

            if result is stream<record{}, error> {
                var row = result.next();
                if row is record{} {
                    if row["result"].toString() == "1" {
                        check caller->respond({
                            validUserLanguage: row["languageOut"]
                        });
                    } else {
                        // Error from stored procedure
                        check caller->respond({
                            validResultCode: row["resutCode"],
                            validStatus: row["status"],
                            validMessage: row["message"]
                        });
                        // In a real scenario, you would call /messageOutput and /resultOutput services here
                    }
                } else {
                    check caller->respond({
                        validResultCode: "SustIMS0439",
                        validStatus: "400",
                        validMessage: "Bad Request"
                    });
                }
            } else {
                check caller->respond({
                    validResultCode: "SustIMS0439",
                    validStatus: "400",
                    validMessage: "DB Error"
                });
            }
        } else {
            // operationUser is missing
            check caller->respond({
                validResultCode: "SustIMS0439",
                validStatus: "400",
                validMessage: "Bad Request"
            });
            // In a real scenario, you would call /messageOutput and /resultOutput services here
        }