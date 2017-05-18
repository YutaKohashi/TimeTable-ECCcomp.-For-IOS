//
//  ScheduleItem.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/06.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import Himotoki

struct ScheduleItem:Decodable{
    
    let date:String // Stringだとprimarykeyになれる
    let year:Int
    let month:Int
    let day:Int
    let week:Int
    let body:String
    
    init(date:String,
         year:Int,
         month:Int,
         day:Int,
         week:Int,
         body:String) {
        self.date = date
        self.year = year
        self.month = month
        self.day = day
        self.week = week
        self.body = body
    }
    
    static func decode(_ e: Extractor) throws -> ScheduleItem {        
        return try ScheduleItem(
            date: e<|"date",
            year: e<|"year",
            month: e<|"month",
            day: e<|"day",
            week: e<|"week",
            body: e<|"body"
        )
    }
}
