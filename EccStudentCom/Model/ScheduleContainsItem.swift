//
//  ScheduleItem.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/17.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import RealmSwift

class ScheduleContainsItem:Object {
    
    dynamic var yearMonthDay:String = ""
    dynamic var year:Int = 0
    dynamic var month:Int = 0
    dynamic var day:Int = 0
    
    dynamic var text:String = ""
    dynamic var originalTxt:String = ""
    
    // プライマリキーを設定
    override static func primaryKey() -> String? {
        return "yearMonthDay"
    }
}
