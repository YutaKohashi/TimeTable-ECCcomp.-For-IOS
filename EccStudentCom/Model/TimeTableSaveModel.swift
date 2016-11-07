//
//  TimeTableSaveModel.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/10/30.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import Foundation
import RealmSwift


//保存するデータのモデルクラス
class TimeTableSaveModel: Object {
    dynamic var subjectName :String = ""
    dynamic var room :String = ""
    dynamic var teacherName :String = ""
    dynamic var rowNum = 0
    dynamic var colNum = 0
}
