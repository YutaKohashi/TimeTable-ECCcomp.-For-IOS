//
//  SaveTableModel.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/09/29.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import Foundation
import RealmSwift


//保存するデータのモデルクラス
class SaveTableModel: Object {
    dynamic var subjectName :String = "" //教科名
    dynamic var roomNum :String = ""     //教室番号
    dynamic var teacherName :String = ""  //担当教師
}