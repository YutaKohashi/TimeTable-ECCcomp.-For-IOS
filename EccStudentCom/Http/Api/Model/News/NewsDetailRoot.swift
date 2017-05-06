//
//  NewsDetailRoot.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/06.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import Himotoki

struct NewsDetailRoot:Decodable{
    
    let code:String
    let newsDetail:NewsDetail
    
    init(code:String, newsDetail:NewsDetail) {
        self.code = code
        self.newsDetail = newsDetail
    }
    
    static func decode(_ e: Extractor) throws -> NewsDetailRoot {
        return try NewsDetailRoot(code: e<|"code", newsDetail: e<|"notice")
    }
}
