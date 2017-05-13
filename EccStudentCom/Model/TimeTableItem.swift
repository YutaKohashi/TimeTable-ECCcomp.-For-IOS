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
class TimeTableItem: Object {
    
    dynamic var id:Int = 0
    
    dynamic var subjectName :String = ""
    dynamic var room :String = ""
    dynamic var teacherName :String = ""
    
    dynamic var subjectNameOrigin :String = ""
    dynamic var roomOrigin :String = ""
    dynamic var teacherNameOrigin :String = ""
    
    dynamic var rowNum = 0
    dynamic var colNum = 0
    
    // プライマリキーを設定
    override static func primaryKey() -> String? {
        return "id"
    }
//    
//    static func create() -> TimeTableItem {
//        let item = TimeTableItem()
//        item.id = lastId()
//        return item
//    }
//    
//    static func lastId() -> Int {
//        if let user = realm.objects(TimeTableItem).last {
//            return user.id + 1
//        } else {
//            return 1
//        }
//    }
//    func update(method: (() -> Void)) {
//        try! User.realm.write {
//            method()
//        }
//    }
    
}
