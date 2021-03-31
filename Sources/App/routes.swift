import Vapor
import Fluent

func routes(_ app: Application) throws {
    
    app.delete("api","v1", "product", ":product_id"){
        req -> EventLoopFuture<HTTPStatus> in
        
        Product.find(req.parameters.get("product_id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                product in
                product.delete(on: req.db)
                    .transform(to: .noContent)
            }
    }
    
    app.get("api","v1", "product","result"){
        req -> EventLoopFuture<[Product]> in
        
        guard let searchQuery = req.query[String.self, at :"query"] else { throw Abort(.badRequest) }
        
        return Product.query(on: req.db)
            .filter(\.$name ~~ searchQuery)
            .all()
         
            
        
       
            
    }

    let productsContoller =  ProductsController()
    
    try app.register(collection: productsContoller)
    
}
