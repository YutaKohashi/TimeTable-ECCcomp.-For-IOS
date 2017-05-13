//
//  TimeTableAccessor.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/10.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import RealmSwift

class TimeTableAccessor:AccessorBase, AccessorProtcol {
    
    static let sharedInstance = TimeTableAccessor()
    private override init() {
        super.init()
    }
    
    func getAll() -> Results<TimeTableItem>? {
        return realm.objects(TimeTableItem.self)
    }
    
    func getByID(id:Int) -> TimeTableItem? {
        let models = super.realm.objects(TimeTableItem.self).filter("id = '\(id)'")
        if models.count > 0 {
            return models[0]
        } else {
            return nil
        }
    }
    
    func getByColRow(col:Int, row:Int) -> TimeTableItem? {
        let models = super.realm.objects(TimeTableItem.self).filter("rowNum = '\(row)' AND colNum = '\(col)'")
        if models.count > 0 {
            return models[0]
        } else {
            return nil
        }
    }
    
    
    func deleteAll(){
        let item = super.realm.objects(TimeTableItem.self)
        item.forEach({ (model) in
            try! realm.write() {
                realm.delete(model)
            }
        })
    }
}
