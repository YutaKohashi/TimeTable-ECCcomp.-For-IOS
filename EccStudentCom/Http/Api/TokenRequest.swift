//
//  TokenRequest.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/06.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import APIKit
import Himotoki

/**
 トークンを取得するAPI
 */
struct TokenRequest:EscRequest{
    typealias Response = Token
    
    var method: HTTPMethod{
        return .post
    }
    
    var path:String{
        return TOKEN_CREATE_PATH
    }
    
    var queryParameters: [String : Any]? {
        return ["username":self.username,"pass": self.pass]
    }
    
    let username:String
    let pass:String
    
    init(username:String ,pass: String) {
        self.username = username
        self.pass = pass
    }
    
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try decodeValue(object)
    }

}
