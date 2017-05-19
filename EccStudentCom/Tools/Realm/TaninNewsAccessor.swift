//
//  TaninNewsAccessor.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/13.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class TaninNewsAccessor:AccessorBase, AccessorProtcol{
    static let sharedInstance = TaninNewsAccessor()
    private override init() {
        super.init()
    }
    
    func getAll() -> Results<TaninNewsItem>? {
        return realm.objects(TaninNewsItem.self)
    }
    
    func getByID(id:Int) -> TaninNewsItem? {
        let models = super.realm.objects(TaninNewsItem.self).filter("newsId = \(id)")
        if models.count > 0 {
            return models[0]
        } else {
            return nil
        }
    }
    
    func deleteAll(){
        let item = super.realm.objects(TaninNewsItem.self)
        item.forEach({ (model) in
            try! realm.write() {
                realm.delete(model)
            }
        })
    }
}
