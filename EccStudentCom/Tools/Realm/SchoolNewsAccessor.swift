//
//  SchoolNewsAccessor.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/13.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class SchoolNewsAccessor:AccessorBase, AccessorProtcol{
    static let sharedInstance = SchoolNewsAccessor()
    private override init() {
        super.init()
    }
    
    func getAll() -> Results<SchoolNewsItem>? {
        return realm.objects(SchoolNewsItem.self)
    }
    
    func getByID(id:Int) -> SchoolNewsItem? {
        let models = super.realm.objects(SchoolNewsItem.self).filter("newsId = '\(id)'")
        if models.count > 0 {
            return models[0]
        } else {
            return nil
        }
    }
    
    func deleteAll(){
        let item = super.realm.objects(SchoolNewsItem.self)
        item.forEach({ (model) in
            try! realm.write() {
                realm.delete(model)
            }
        })
    }
}
