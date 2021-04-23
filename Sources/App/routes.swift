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
            hostname: Environment.get("HOSTNAME")!,
            username: Environment.get("USERNAME")!,
            password: Environment.get("PASSWORD")!,
            database: Environment.get("DATABASE")!
        ),
        as: .psql)

    app.migrations.add(AddColumnSkuTillToppingId())
    
    app.logger.logLevel = .debug
    
    app.http.server.configuration.port = port
    
    try app.autoMigrate().wait()
  
    try app.register(collection: ProductsController())
    
}
