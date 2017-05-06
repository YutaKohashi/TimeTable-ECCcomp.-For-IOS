//
//  TeacherTimeTable.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/06.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import Himotoki

struct TeacherTimeTable :Decodable{
    // 先生名字
    let firstName:String
    // 先生名前
    let familyName:String
    // 1: メイン 0: チューター
    let category:Int
    
    init(firstName:String, familyName:String, category:Int) {
        self.firstName = firstName
        self.familyName = familyName
        self.category = category
    }
    
    static func decode(_ e: Extractor) throws -> TeacherTimeTable {
        return try TeacherTimeTable(
            firstName: e<|"first_name",
            familyName: e<|"family_name",
            category: e<|"category"
        )
    }
}
