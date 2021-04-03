import Vapor
import Fluent

struct ProductsController: RouteCollection{
    func boot(routes: RoutesBuilder) throws {
        
        let productRouteGroup = routes.grouped("product")
        
        // Query Routes
        productRouteGroup.get(":product_id", use: readOneHandler)
        productRouteGroup.get(use: readAllHandler)
        productRouteGroup.get("result", use: searchHandler)
        productRouteGroup.get("count", use: countHandler)
        
        let authProductRouteGroup = routes.grouped(UserAuthMiddleware(authHostname: "localhost" ))
        
        authProductRouteGroup.post(use: createHandler)
        authProductRouteGroup.put("product_id", use: updateHandler)
        authProductRouteGroup.delete("product_id", use: deleteHandler)

      
    }
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<Product>{
        
        let product = try req.content.decode(Product.self)
        
        return product.save(on: req.db).map{ product }
    }
    
    
    func updateHandler(_ req: Request) throws -> EventLoopFuture<Product> {
        
        let updateProduct = try req.content.decode(Product.self)
        
        return Product.find(req.parameters.get("product_id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{
                product in
                product.descriptions = updateProduct.descriptions
                product.name = updateProduct.name
                product.price = updateProduct.price
                product.image_featured = updateProduct.image_featured
                
                return product.save(on: req.db).map{product}
            }
    }
    
    func deleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        
        Product.find(req.parameters .get("product_id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{
                product in
                product.delete(on: req.db)
                    .transform(to: .noContent)
            }
    }
    
    
    // Query Functions
    func readAllHandler(_ req: Request) throws -> EventLoopFuture<[Product]> {
        Product.query(on: req.db).sort(\.$name, .ascending).all()
    }
    
    func readOneHandler(_ req: Request) throws -> EventLoopFuture<Product> {
        Product.find(req.parameters.get("product_id"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func searchHandler(_ req: Request) throws -> EventLoopFuture<[Product]> {
    
    guard let searchQuery = req.query[String.self, at: "search_query"] else { throw Abort(.badRequest)}
        
        return Product.query(on: req.db)
            .filter(\.$name ~~ searchQuery)
            .all()
    }
    
    func countHandler(_ req: Request) throws -> EventLoopFuture<Int> {
        
        Product.query(on: req.db).count()
     
        
    }
    
    
    
}



