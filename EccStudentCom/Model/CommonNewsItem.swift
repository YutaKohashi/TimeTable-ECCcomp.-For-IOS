//
//  File.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/13.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import RealmSwift

class CommonNewsItem :Object{
    dynamic var newsId:Int = 0
    dynamic var title :String = ""
    dynamic var from:String = ""
    dynamic var date :String = ""
    
    // プライマリキーを設定
    override static func primaryKey() -> String? {
        return "newsId"
    }
}
