//
//  NewsDetailRequest.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/06.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import APIKit
import Himotoki

/**
 お知らせの詳細を取得する為のAPI
 */
struct NewsDetailRequest :EscRequest{
    
    typealias Response = NewsDetailRoot
    
    var method: HTTPMethod{
        return .get
    }
    
    var path:String{
        return NEWS_DETAIL_PATH
    }
    
    var queryParameters: [String : Any]? {
        return ["token":self.token, "id" : self.newsId]
    }
    
    let token:String
    let newsId:Int
    
    init(token:String , newsId:Int) {
        self.token = token
        self.newsId = newsId
    }
}
