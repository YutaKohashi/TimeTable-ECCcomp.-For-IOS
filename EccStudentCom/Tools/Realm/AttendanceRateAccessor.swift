//
//  AttendanceRateAccessor.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/13.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class AttedanceRateAccessor:AccessorBase, AccessorProtcol{
    
    static let sharedInstance = AttedanceRateAccessor()
    private override init() {
        super.init()
    }
    
    func getAll() -> Results<AttendanceRateItem>? {
        return realm.objects(AttendanceRateItem.self)
    }
    
    func getByID(id:Int) -> AttendanceRateItem? {
        let models = super.realm.objects(AttendanceRateItem.self).filter("id = '\(id)'")
        if models.count > 0 {
            return models[0]
        } else {
            return nil
        }
    }

    func deleteAll(){

        let item = super.realm.objects(AttendanceRateItem.self)
        item.forEach({ (model) in
            try! realm.write() {
                realm.delete(model)
            }
        })
    }
}
