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
    
    init() {}
    
    init(id: UUID? = nil, name: String, descriptions:String, price: Int, image_featured: String) {
        self.id = id
        self.name = name
        self.descriptions = descriptions
        self.price = price
        self.image_featured = image_featured
    }
}

extension Product: Content{}

