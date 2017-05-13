//
//  AccessorBase.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/10.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import RealmSwift
import Realm


/// RealmデータベースへのAccessorはこのclassを継承する。
class AccessorBase {
    
    let realm: Realm
    
    /// コンストラクタ
    init() {
        // Realmオブジェクト生成
        realm = try! Realm()
    }
    
    /// データをUpdateする
    /// - parameter data: データ
    /// - returns: true: 成功
    func set(data: Object) -> Bool {
        do {
            try realm.write {
                realm.add(data, update: true)   //プライマリキーで上書きする
            }
            return true
        } catch {
            print("\n--Error! AccessorBase#set")
        }
        return false
    }
    
    
    /// データをDeleteする
    /// - parameter data: データ
    /// - returns: true: 成功
    func delete(data: Object) -> Bool {
        do {
            try realm.write {
                realm.delete(data)
            }
            return true
        } catch {
            print("\n--Error! AccessorBase#delete")
        }
        return false
    }
}
