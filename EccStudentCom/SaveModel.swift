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
class SaveModel: Object {
    dynamic var subjectName :String = ""
    dynamic var unit :String = ""
    dynamic var attendanceNumber :String = ""
    dynamic var absentNumber :String = ""
    dynamic var lateNumber :String = ""
    dynamic var publicAbsentNumber1 :String = ""
    dynamic var publicAbsentNumber2 :String = ""
    dynamic var attendanceRate :String = ""
    dynamic var shortageNumber :String = ""
}