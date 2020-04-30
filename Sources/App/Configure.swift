import Fluent
//import FluentMySQLDriver
import FluentPostgresDriver
import Vapor
import JWT

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    /* Respond to browser CORS requests.
        This middleware is answering the OPTIONS request by merely returning it positively without doing anything else. Browsers send an OPTIONS request to hosts that are different from the originating file. So, for example, if you run your frontend under https://www.domain.com and your API from https://api.domain.com, then the browsers will send out an OPTIONS request because www.domain.com is not equal to api.domain.com. There is nothing wrong with this, and this handy middleware takes care of it for us.
    */
    app.middleware.use(CORSMiddleware())
    app.middleware.use(ErrorMiddleware() { request, error in
        return Response(status: .internalServerError)
    })

    
    // Pass JWKS to our application that will contain the appropriate keys
    guard let jwksString = Environment.process.JWKS else {
        fatalError("No value was found at the given public key enviroment 'JWKS'")}
    

    
    // If there is a problem with the JWKS this will prevent the application from starting and therefore not expose any security issue.
    try app.jwt.signers.use(jwksJSON: jwksString)
    
    
    
    /* MySQL Database
    // Make sure we have a location for the database
    guard let mysqlURL = Environment.process.MYSQL_CRED else {
        fatalError("No value was found at the given public key enviroment")}
    
    // Make sure the database URL is actually a URL
    guard let url = URL(string: mysqlURL) else {
        fatalError("Cannot parse: \(mysqlURL) correctly.")
    }
    
    // Make sure the database is actually there
    app.databases.use(try .mysql(url: url), as: .mysql)
    */
    
    
    
    // Postgre Database
    guard let psqlUrl = Environment.process.PSQL_CRED else { fatalError("No value was found at the given public key environment 'PSQL_CRED'")
           }
    guard let url = URL(string: psqlUrl) else { fatalError("Cannot parse: \(psqlUrl) correctly.")
    }
    
    app.databases.use(try .postgres(url: url), as: .psql)
    

    // Register database models for Fluent
    app.migrations.add(CreateCategory())
    app.migrations.add(CreateProduct())
    
    
    // register routes
    try routes(app)
}
