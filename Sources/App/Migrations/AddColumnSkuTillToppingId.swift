import Fluent

struct AddColumnSkuTillToppingId: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
      database.schema("products")
            .field("sku", .string)
            .field("stock", .int  )
            .field("categories_id", .uuid )
            .field("varian_id", .uuid )
            .field("topping_id", .uuid )
            .field("image_galleries_id", .uuid)
            .unique(on: "sku")
            .unique(on: "categories_id")
            .unique(on: "varian_id")
            .unique(on: "topping_id")
            .unique(on: "image_galleries_id")
            .update()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("products").delete()
    }
}
