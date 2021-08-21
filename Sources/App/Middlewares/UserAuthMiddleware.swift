import Vapor

final class UserAuthMiddleware: Middleware {
    
    let authHostname: String = Environment.get("AUTH_HOSTNAME")!
    let authPort: Int = Int(Environment.get("AUTH_PORT")!)!
    
    
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        
        guard let token = request.headers.bearerAuthorization else {
            return request.eventLoop.future(error: Abort(.unauthorized))
        }
        
        //debug
        print("\n", "TOKEN", token, "\n")
        
        return request
            .client
            .post("http://\(authHostname):\(authPort)/user/auth/authenticate", beforeSend: { authRequest in
                
                //debug
                print("\n","AUTH_REQUEST",authRequest,"\n")
                
                try authRequest.content.encode(AuthenticateData(token: token.token))
            })
        
            .flatMapThrowing { response in
                guard response.status == .ok else {
                    if response.status == .unauthorized {
                        throw Abort (.unauthorized)
                    } else {
                        throw Abort (.internalServerError)
                    }
                }
                
                let user = try response.content.decode(User.self)
                
                //debug
                print("\n","RESPONSE:\n", response,"\n")
                print("\n","USER:", user,"\n")
              
                request.auth.login(user)
            }
            
            .flatMap {
                return next.respond(to: request)
            }
    }
}

struct AuthenticateData: Content {
    let token: String
}


