//
//  File.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/06.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import Himotoki
/**
 * トークンを扱うモデル
 */
struct Token:Decodable{
    // 認証成功CD00001 / 認証失敗ER00001
    let code:String
    // アクセストークン
    let token:String
     // トークンの使用期限
    let expire:String
    
    init(code:String, token:String, expire:String) {
        self.code = code
        self.token = token
        self.expire = expire
    }
    
    static func decode(_ e: Extractor) throws -> Token {
        return try Token(code: e<|"code",
                         token: e<|"token",
                         expire: e<|"expire")
    }
}
