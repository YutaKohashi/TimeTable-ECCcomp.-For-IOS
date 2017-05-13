//
//  SaveModel.swift
//  esc
//
//  Created by YutaKohashi on 2016/09/22.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import Foundation
import RealmSwift


//保存するデータのモデルクラス
// 出席照会のデータを扱うオブジェクト
class AttendanceRateItem: Object {
    dynamic var id:Int = 0
    
    dynamic var subjectName :String = ""
    dynamic var unit :String = ""
    dynamic var attendanceNumber :String = ""
    dynamic var absentNumber :String = ""
    dynamic var lateNumber :String = ""
    dynamic var publicAbsentNumber1 :String = ""
    dynamic var publicAbsentNumber2 :String = ""
    dynamic var attendanceRate :String = ""
    dynamic var shortageNumber :String = ""
    
    // プライマリキーを設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
