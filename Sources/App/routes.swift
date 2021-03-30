import Vapor

func routes(_ app: Application) throws {
   
    app.post("api", "v1", "product") { req -> EventLoopFuture<Product> in
    
        let product = try req.content.decode(Product.self)
        
        return product.save(on: req.db).map{ product }
        
    }
    
    app.put("api", "v1", "product", ":product_id"){
        req -> EventLoopFuture<Product> in
        
        let updateProduct = try req.content.decode(Product.self)
        
        return Product.find(req.parameters.get("product_id"), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMap{
                product in
                product.descriptions = updateProduct.descriptions
                product.name = updateProduct.name
                product.price = updateProduct.price
                product.image_featured = updateProduct.image_featured
            
                return product.save(on: req.db).map{product}
            }
    }
    
    app.get("api", "v1", "product"){ req -> EventLoopFuture<[Product]> in
        
        Product.query(on: req.db).sort(\.$name, .ascending).all()
    }
    
    app.get("api", "v1", "product", ":product_id"){
        req -> EventLoopFuture<Product> in
        
        Product.find(req.parameters.get("product_id"), on: req.db)
        
            .unwrap(or: Abort(.notFound))
    }
    
   
  
}
