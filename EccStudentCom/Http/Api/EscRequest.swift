//
//  EscRequest.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/05.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import APIKit
import Himotoki 

protocol EscRequest:Request{}

extension EscRequest{
    var baseURL:URL{
        return URL(string: API_BASE_URL)!
    }
}

extension EscRequest where Response:Decodable{
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try decodeValue(object)
    }
}

extension EscRequest{
    //　baseuURL ------------------------------------------------------
    var API_BASE_URL:String!{
        return "http://comp2.ecc.ac.jp/monster/v1/"
    }
    
    
    //　パス -----------------------------------------------------------
    
    // トークン取得
    var TOKEN_CREATE_PATH:String!{
        return "token/create"
    }
    // 時間割
    var TIME_TABLE_PATH:String!{
        return "timetable/find_by_code"
    }
    // お知らせ
    var NEWS_PATH:String!{
        return "notice/headline"
    }
    // お知らせ詳細
    var NEWS_DETAIL_PATH:String!{
        return  "notice/find"
    }
    //　スケジュール
    var SCHEDULE_PATH:String!{
        return "schedule/find"
    }
}
