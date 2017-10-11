//
//  NewsArray.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/06.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import Himotoki


struct NewsArray :Himotoki.Decodable{
    // API正常実行
    let code:String
     // お知らせArray
    let newsArray:[NewsItem]
    
    init(code:String,newsArray:[NewsItem]) {
        self.code = code
        self.newsArray = newsArray
    }
    
    static func decode(_ e: Extractor) throws -> NewsArray {
        return try NewsArray(code: e<|"code",
                             newsArray: e<||"notices"
        )
    }
}
