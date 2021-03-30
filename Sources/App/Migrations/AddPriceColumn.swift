import Fluent

struct AddPriceColumn: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("products")
            .field("price", .int, .required)
            .update()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("products").delete()
    }
}
