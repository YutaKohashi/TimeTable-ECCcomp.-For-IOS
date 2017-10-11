//
//  NewsDetail.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/06.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import Himotoki

struct NewsDetail:Himotoki.Decodable{
    //　お知らせID
    let id:Int
    
    // お知らせのカテゴリ名
    let category:String
    
    // お知らせタイトル
    let title:String
    
    //お知らせ本文
    let body:String
    
    // 最終更新日
    let updatedAt:String
    
    // お知らせの作者名
    let author:String
    
    // 添付ファイルリスト
    let files:[NewsFile]
    
    //　お知らせ配信先コースリスト
    let courses:[NewsCourse]
    
    init(id:Int,
         category:String,
         title:String,
         body:String,
         updatedAt:String,
         author:String,
         files:[NewsFile],
         courses:[NewsCourse]) {
        self.id  = id
        self.category = category
        self.title = title
        self.body = body
        self.updatedAt = updatedAt
        self.author = author
        self.files = files
        self.courses = courses
    }
    
    static func decode(_ e: Extractor) throws -> NewsDetail {
        return try NewsDetail(
            id: e<|"id",
            category: e<|"category",
            title: e<|"title",
            body: e<|"body",
            updatedAt: e<|"updated_at",
            author: e<|"author",
            files: e<||"files",
            courses: e<||"courses"
        )
    }
    
}
