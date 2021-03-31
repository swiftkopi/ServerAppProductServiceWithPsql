import Vapor
import FluentPostgresDriver

public func configure (_ app: Application) throws {

    app.databases.use(
        .postgres(
            hostname: Environment.get("HOSTNAME")!,
            username: Environment.get("USERNAME")!,
            password: Environment.get("PASSWORD")!,
            database: Environment.get("DATABASE")!
        ),
        as: .psql)

    
    app.migrations.add(FirstInitProduct())
    
    app.logger.logLevel = .debug
    
    try app.autoMigrate().wait()
    
    try routes(app)
}
