//
//  NewsItem.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/06.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import Himotoki

struct NewsItem :Himotoki.Decodable{
    
    //お知らせのID
    let id:Int
     // お知らせのカテゴリ名
    let category:String
     // お知らせのタイトル名
    let title:String
    // お知らせ本文
    let body:String
    // 最終更新日
    let updatedDate:String
    // 最終更新時間
    let updatedTime:String
    // お知らせの作者名
    let author:String
    
    init(id:Int,
         category:String,
         title:String,
         body:String,
         updatedDate:String,
         updatedTime:String,
         author:String) {
        self.id = id
        self.category = category
        self.title = title
        self.body = body
        self.updatedDate = updatedDate
        self.updatedTime = updatedTime
        self.author = author
    }
    
    static func decode(_ e: Extractor) throws -> NewsItem {
        return try NewsItem(
            id: e<|"id",
            category: e<|"category",
            title: e<|"title",
            body: e<|"body",
            updatedDate: e<|"updated_date",
            updatedTime: e<|"updated_time",
            author: e<|"author")
    }
}
