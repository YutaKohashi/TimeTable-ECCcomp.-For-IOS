//
//  NewsCourse.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/06.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import Himotoki

struct NewsCourse:Himotoki.Decodable {
    let courseName:String
    
    init(courseName:String) {
        self.courseName = courseName
    }
    
    static func decode(_ e: Extractor) throws -> NewsCourse {
        return try NewsCourse(courseName: e<|"name")
    }
}
