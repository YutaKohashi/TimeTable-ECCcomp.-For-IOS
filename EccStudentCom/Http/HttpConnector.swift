//
//  HttpConnector.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/11/09.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import Foundation

class HttpConnector{
    
    fileprivate let HELPER = HttpHelper()
   
    // リクエストタイプ
    enum `RequestType`: Int {
        case time_TABLE
        case attendance_RATE
        case time_ATTEND
    }
    
    //時間割　出席率を取得するメソッド
    func request(_ type:RequestType,userId :String,password:String,callback: @escaping (Bool) -> Void) -> Void{
        
        switch type{
        case .time_TABLE:
            HELPER.getTimeTable(userId, password: password, callback: { (bool) in
                callback(bool)
            })
            break
            
        case .attendance_RATE:
            HELPER.getAttendanceRate(userId, password: password, callback: { (bool) in
                callback(bool)
            })
            break
            
        case .time_ATTEND:
            HELPER.getTimeTableAttendanceRate(userId, password: password, callback: { (bool) in
                callback(bool)
            })
        }
    }
}
