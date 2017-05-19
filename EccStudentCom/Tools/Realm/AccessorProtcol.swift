//
//  AccessProtocol.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/10.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import RealmSwift

// RealmデータベースへのAccessorはこのProtcolを実装する

protocol AccessorProtcol {
    associatedtype ObjectType: Object
    
//    func getByID(id: Int) -> ObjectType?
    
    func getAll() -> Results<ObjectType>?
    
    func set(data: Object) -> Bool
    
    func delete(data: Object) -> Bool
}
