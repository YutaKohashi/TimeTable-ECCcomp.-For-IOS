//
//  ScheduleRequest.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/05.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import APIKit
import Himotoki

struct ScheduleRequest:EscRequest {
    typealias Response = ScheduleRoot
    
    var method: HTTPMethod{
        return .get
    }
    
    var path:String{
        return SCHEDULE_PATH
    }
    
    var queryParameters: [String : Any]? {
        return ["token":self.token,"year": self.year, "month" : self.month]
    }
    
    let token:String
    let year:Int
    let month:Int
    
    init(token:String ,year: Int, month :Int) {
        self.token = token
        self.year = year
        self.month = month
    }
}
