//
//  HttpConnector.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/11/09.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import Foundation

class HttpConnector{
    
    private let HELPER = HttpHelper()
   
    // リクエストタイプ
    enum `RequestType`: Int {
        case TIME_TABLE
        case ATTENDANCE_RATE
        case TIME_ATTEND
        case NEWS_SCHOOL
        case NEWS_TEACHER
        case NEWS_SCHOOL_TEACHER
    }
    
    //時間割　出席率を取得するメソッド
    func request(type:RequestType,userId :String,password:String,callback: @escaping (Bool) -> Void) -> Void{
        
        switch type{
        case .TIME_TABLE:
            HELPER.getTimeTable(userId: userId, password: password, callback: { (bool) in
                callback(bool)
            })
            break
            
        case .ATTENDANCE_RATE:
            HELPER.getAttendanceRate(userId: userId, password: password, callback: { (bool) in
                callback(bool)
            })
            break
            
        case .TIME_ATTEND:
            HELPER.getTimeTableAttendanceRate(userId: userId, password: password, callback: { (bool) in
                callback(bool)
            })
            break
        case .NEWS_SCHOOL:
            HELPER.getSchoolNews(userId: userId, password: password, callback: { (bool) in
                callback(bool)
            })
            break
        case .NEWS_TEACHER:
            HELPER.getTaninNews(userId:userId,password:password, callback: {(bool) in
                callback(bool)
            })
            break
        case .NEWS_SCHOOL_TEACHER:
            HELPER.getSchoolTaninNews(userId:userId,password:password, callback: {(bool) in
                callback(bool)
            })
            break
        }
    }
}
