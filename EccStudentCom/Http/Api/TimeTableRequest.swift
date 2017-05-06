//
//  TimeTableRequest.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/05.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import APIKit
import Himotoki

struct TimeTableRequest:EscRequest{

    typealias Response = RootTimeTable
    
    var method: HTTPMethod{
        return .get
    }
    
    var path:String{
        return TIME_TABLE_PATH
    }

    var queryParameters: [String : Any]? {
        return ["token":self.token,"code": self.code]
    }
    
    let token:String
    let code:String
    
    init(token:String ,code: String) {
        self.token = token
        self.code = code
    }
}
