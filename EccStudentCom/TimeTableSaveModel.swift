//
//  TimeTableSaveModel.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/10/29.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import Foundation
import RealmSwift


//保存するデータのモデルクラス
class TimeTableSaveModel: Object {
    dynamic var subjectName :String = ""
    dynamic var classRoom :String = ""
    dynamic var teacherName :String = ""
    dynamic var dayOfWeek :UInt = 0
    dynamic var lessonNum :UInt = 0
}
