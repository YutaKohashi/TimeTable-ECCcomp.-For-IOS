//
//  RootTimeTable.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/06.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import Himotoki

struct RootTimeTable:Decodable {
    
    let code:String
    let timeTables:[TimeTable]

    
    init(code:String, timeTables:[TimeTable]) {
        self.code = code
        self.timeTables = timeTables
    }
    
    static func decode(_ e: Extractor) throws -> RootTimeTable {
        return try RootTimeTable(
            code: e<|"code" ,
            timeTables: e<||"timetable"
        )
    }
}
