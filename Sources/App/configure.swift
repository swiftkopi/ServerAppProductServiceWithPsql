import Vapor
import FluentPostgresDriver
import Redis

public func configure (_ app: Application) throws {
    
    let redisConf : String
    let port: Int
    
    if let redisHostname = Environment.get("HOSTNAME_REDIS"){
        redisConf = redisHostname
    } else {
         redisConf = "localhost"
    }
    
    if let envPort = Environment.get("PORT_PRODUCT_SERVICE"){
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
    
    app.redis.configuration = try RedisConfiguration(hostname: redisConf)
    
    
    
    app.migrations.add(CreateSchemaProduct())
    
    app.logger.logLevel = .debug
    
    app.http.server.configuration.port = port
    
    try app.autoMigrate().wait()
    
    try routes(app)
}
