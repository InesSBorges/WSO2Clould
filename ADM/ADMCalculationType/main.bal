
import ballerinax/mssql;
import ballerina/http;

service /calculation on new http:Listener(8080) {

    configurable string dbHost = ?;
    configurable int dbPort = ?;
    configurable string dbUser = ?;
    configurable string dbPassword = ?;
    configurable string dbName = ?;

    final mssql:Client dbClient = check new ({
        host: dbHost,
        port: dbPort,
        user: dbUser,
        password: dbPassword,
        database: dbName
    });

    // PUT: Atualiza um tipo de cálculo
    resource function put /updateCalculationType (http:Caller caller, http:Request req) returns error? {
        json payload = check req.getJsonPayload();
        string idCalculationType = <string>payload.idCalculationType;
        string newCalculationType = <string>payload.newCalculationType;

        string sqlQuery = string `UPDATE CalculationType SET typeName = '${newCalculationType}' WHERE id = '${idCalculationType}'`;
        check dbClient->execute(sqlQuery);

        check caller->respond("Calculation Type updated successfully.");
    }

    // GET: Busca um tipo de cálculo por ID
    resource function get /getCalculationType/[string id] returns json|error {
        stream<record {}, error> result = dbClient->query(
            `SELECT * FROM CalculationType WHERE id = ${id}`);
        record {}? row = result.next();
        if row is record {} {
            return row;
        }
        return { message: "Calculation Type not found." };
    }

    // POST: Cria um novo tipo de cálculo
    resource function post /createCalculationType (http:Caller caller, http:Request req) returns error? {
        json payload = check req.getJsonPayload();
        string idCalculationType = <string>payload.idCalculationType;
        string calculationType = <string>payload.calculationType;

        string insertQuery = string `INSERT INTO CalculationType (id, typeName) VALUES ('${idCalculationType}', '${calculationType}')`;
        check dbClient->execute(insertQuery);

        check caller->respond("Calculation Type created successfully.");
    }
}
