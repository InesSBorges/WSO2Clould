import ballerina/http;
import ballerinax/mssql;

service /language on new http:Listener(8080) {

    // Update these values or use Choreo/WSO2 config for production
    mssql:Client dbClient = check new ({
        host: "localhost",
        port: 1433,
        database: "your_db",
        user: "your_user",
        password: "your_password"
    });

    resource function post lookup(http:Caller caller, http:Request req) returns error? {
        json payload = check req.getJsonPayload();
        int? idLanguage = <int?>payload.id;
        string? languageCode = <string?>payload.code;

        if idLanguage is () && languageCode is () {
            // No id or code provided
            check caller->respond({
                validResultCode: "SustIMS0100",
                validMessage: "OK",
                validStatus: "202"
            });
            return;
        }

        string sql = "SELECT * FROM ADM.Language WITH(NOLOCK) " +
                     "WHERE IdLanguage = ISNULL(?, IdLanguage) " +
                     "AND LanguageCode = ISNULL(?, LanguageCode)";
        var result = dbClient->query(sql, idLanguage, languageCode);

        if result is stream<record{}, error> {
            var row = result.next();
            if row is record{} {
                int idLang = <int>row["IdLanguage"];
                if idLang >= 1 {
                    // Return the found language row and set validIdLanguage
                    row["validIdLanguage"] = idLang;
                    check caller->respond(row);
                } else {
                    // IdLanguage not valid
                    check caller->respond({
                        validMessage: "OK",
                        validStatus: "202",
                        validResultCode: "SustIMS0100"
                    });
                }
            } else {
                // No result found
                check caller->respond({
                    validMessage: "OK",
                    validStatus: "202",
                    validResultCode: "SustIMS0100"
                });
            }
        } else {
            // DB error
            check caller->respond({
                validMessage: "DB Error",
                validStatus: "500",
                validResultCode: "SustIMS9999"
            });
        }