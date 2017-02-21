//
//  NewsItem.swift
//  EccStudentCom
//
//  Created by 小橋勇太 on 2017/02/16.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import RealmSwift


//保存するデータのモデルクラス
class SchoolNewsItem: Object {
    dynamic var title :String = ""
    dynamic var date :String = ""
    dynamic var uri :String = ""
    
    dynamic var groupTitle:String = ""
    
}
