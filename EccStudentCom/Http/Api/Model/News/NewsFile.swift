//
//  NewsFile.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/06.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import Himotoki

struct NewsFile:Decodable {
    
    let id:Int
    let fileName:String
    
    init(id:Int, fileName:String) {
        self.id = id
        self.fileName = fileName
    }
    
    static func decode(_ e: Extractor) throws -> NewsFile {
        return try NewsFile(id: e<|"id", fileName: e<|"name")
    }
}
