import Vapor
import Fluent

final class Product: Model {
    
static let schema = "products"

    @ID
    var id : UUID?
    
    @Field(key:"name")
    var name: String
    
    @Field(key: "descriptions")
    var descriptions: String
    
    @Field(key:"price")
    var price : Int
    
    @Field(key: "image_featured")
    var image_featured: String
    
    @Field(key: "sku")
    var sku : String?
    
    @Field(key: "stock")
    var stock: Float?
    
    @Field(key: "categories_id")
    var categories_id : UUID?
    
    @Field(key: "varian_id")
    var varian_id: UUID?
    
    @Field(key: "topping_id")
    var topping_id: UUID?
    
    @Field(key: "image_galleries_id")
    var image_galleries_id: UUID?
    
    
    
    init() {}
    
    init(id: UUID? = nil, name: String, descriptions:String, price: Int, image_featured: String, sku: String, stock: Float, categories_id: UUID, varian_id: UUID, topping_id: UUID, image_galleries_id: UUID) {
        self.id = id
        self.name = name
        self.descriptions = descriptions
        self.price = price
        self.image_featured = image_featured
        self.sku = sku
        self.stock = stock
        self.categories_id = categories_id
        self.varian_id = varian_id
        self.topping_id = topping_id
        self.image_galleries_id = image_galleries_id
        
    }
}

extension Product: Content{}


final class UpdateCategoryID: Content, Codable {
    var categories_id: UUID
    
    init(categories_id: UUID){
        self.categories_id = categories_id
    }
}

