//
//  ScheduleAccessor.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/17.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//
import Foundation
import RealmSwift
import Realm

class ScheduleAccessor:AccessorBase, AccessorProtcol{
    
    static let sharedInstance = ScheduleAccessor()
    private override init() {
        super.init()
    }
    
    func getAll() -> Results<ScheduleContainsItem>? {
        return realm.objects(ScheduleContainsItem.self)
    }
    
    func getByMonth(month:Int) -> Results<ScheduleContainsItem>?{
         let models = super.realm.objects(ScheduleContainsItem.self).filter("month = \(month)").sorted(byKeyPath: "day", ascending: true)
        if models.count > 0 {
            return models
        } else {
            return nil
        }
    }
    
    func getByID(id:String) -> ScheduleContainsItem? {
        let models = super.realm.objects(ScheduleContainsItem.self).filter("yearMonthDay = '\(id)'")
        if models.count > 0 {
            return models[0]
        } else {
            return nil
        }
    }
    
    func deleteAll(){
        let item = super.realm.objects(ScheduleContainsItem.self)
        item.forEach({ (model) in
            try! realm.write() {
                realm.delete(model)
            }
        })
    }
}
