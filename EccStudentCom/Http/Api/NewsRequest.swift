//
//  NewsRequest.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/05.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import APIKit
import Himotoki

/*
 * お知らせのヘッドラインを取得する為のAPI
 * ヘッドラインの取得件数の最大値。最大100 未設定の場合は10
 */
struct NewsRequest:EscRequest{
    
    typealias Response = NewsArray
    
    var method: HTTPMethod{
        return .get
    }
    
    var path:String{
        return NEWS_PATH
    }
    
    var queryParameters: [String : Any]? {
        return ["token":self.token,"type": self.type.rawValue, "limit" : self.limit]
    }
    
    let token:String
    let type:NewsType
    let limit:Int
    
    init(token:String ,type: NewsType, limit:Int) {
        self.token = token
        self.type = type
        self.limit = limit
    }

    enum NewsType :Int{
        case school = 1 // 学校から
        case tanin = 2  // 担任から
    }
}
