import ballerina/http;
import ballerinax/mssql;

service /messageOutput on new http:Listener(8082) {

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
        string validResultCode = <string>payload.validResultCode;
        string validUserLanguage = <string>payload.validUserLanguage;

        // Simulate stored procedure call and output parameters
        // In real code, use a stored procedure call with OUT parameters if supported
        string sql = "DECLARE @MessageDescription varchar(500), " +
                     "@ClientMessageDescription varchar(500) " +
                     "EXECUTE [ADM].[GetMessageResultOutput] ?, ?, " +
                     "@MessageDescription OUTPUT, @ClientMessageDescription OUTPUT; " +
                     "SELECT @MessageDescription AS MessageDescription, " +
                     "@ClientMessageDescription AS ClientMessageDescription;";

        var result = dbClient->query(sql, validResultCode, validUserLanguage);

        if result is stream<record{}, error> {
            var row = result.next();
            if row is record{} {
                check caller->respond({
                    validMessageDescription: row["MessageDescription"],
                    validClientMessageDescription: row["ClientMessageDescription"]
                });
            } else {
                check caller->respond({
                    validMessageDescription: "",
                    validClientMessageDescription: ""
                });
            }
        } else {
            check caller->respond({
                validMessageDescription: "DB Error",
                validClientMessageDescription: "DB Error"
            });