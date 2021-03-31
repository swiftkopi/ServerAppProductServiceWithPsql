import Vapor
import Fluent

func routes(_ app: Application) throws {

    let productsContoller =  ProductsController()
    
    try app.register(collection: productsContoller)
    
}
