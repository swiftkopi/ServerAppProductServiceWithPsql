import Fluent

struct AddUserIdColumn: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("products")
            .field("user_id", .uuid)
            .update()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("products")
            .field("user_id",.uuid)
            .delete()
    }
}
