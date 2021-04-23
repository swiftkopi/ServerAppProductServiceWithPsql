import Vapor
import FluentPostgresDriver

func routes(_ app: Application) throws {
    
    let port: Int
    
    if let envPort = Environment.get("PRODUCT_PORT"){
        port = Int(envPort) ?? 8081
    } else {
        port = 8081
    }

    app.databases.use(
        .postgres(
            hostname: Environment.get("DB_HOSTNAME")!,
            username: Environment.get("DB_USERNAME")!,
            password: Environment.get("DB_PASSWORD")!,
            database: Environment.get("DB_NAME")!
        ),
        as: .psql)

    app.migrations.add(AddColumnSkuTillToppingId())
    
    app.logger.logLevel = .debug
    
    app.http.server.configuration.port = port
    
    try app.autoMigrate().wait()
  
    try app.register(collection: ProductsController())
    
}
