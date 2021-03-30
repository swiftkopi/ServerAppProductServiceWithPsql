import Fluent

struct FirstInitProduct: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("products")
            .id()
            .field("name", .string, .required)
            .field("descriptions", .string, .required)
            .field("price", .int, .required)
            .field("image_featured", .string, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("products").delete()
    }
}
