//
//  EscApiManager.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/06.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import APIKit

class EscApiManager{
    fileprivate static var token:String = ""
    
    // トークンリクエスト
    static func tokenRequest(userId:String, password:String, callback: @escaping (EscApiCallback<Token>) -> Void) -> Void {
        let request = TokenRequest(username: userId, pass: password)
        Session.send(request) { result in
            switch(result){
            case .success(let response):
                self.token = response.token
                callback(EscApiCallback<Token>(response:response, bool:true))
            case .failure( _):
                callback(EscApiCallback<Token>(bool: false))
            }
        }
    }
    
    
    // MARK:時間割を取得するメソッド
    static func timeTableRequest(code:String, callback: @escaping (EscApiCallback<RootTimeTable>) -> Void) -> Void {
        let request = TimeTableRequest(token: self.token, code:code)
        Session.send(request) { result in
            switch result {
            case .success(let rootTimeTable):
                callback(EscApiCallback<RootTimeTable>(response: rootTimeTable,bool: true))
            case .failure( _):
                callback(EscApiCallback<RootTimeTable>(bool: false))
            }
        }
    }
    
    // MARK:学校からのお知らせ
    static func schoolNewsRequest(callback: @escaping (EscApiCallback<NewsArray>) -> Void) -> Void {
        let request = NewsRequest(token: self.token, type: NewsRequest.NewsType.school , limit: 100)
        Session.send(request) { result in
            switch result{
                case .success(let newsArray):
                    callback(EscApiCallback<NewsArray>(response: newsArray, bool: true))
                case .failure( _):
                   callback(EscApiCallback<NewsArray>(bool: false))
            }
        }
    }
    
    // MARK:担任からのお知らせ
    static func taninNewsRequest(callback: @escaping (EscApiCallback<NewsArray>) -> Void) -> Void {
        let request = NewsRequest(token: self.token, type: NewsRequest.NewsType.tanin , limit: 100)
        Session.send(request) { result in
            switch result{
            case .success(let newsArray):
                callback(EscApiCallback<NewsArray>(response: newsArray, bool: true))
            case .failure( _):
                callback(EscApiCallback<NewsArray>(bool: false))
            }
        }
    }
    
    // MARK: お知らせ詳細
    static func newsDetailRequest(newsId:Int, callback: @escaping (EscApiCallback<NewsDetailRoot>) -> Void) -> Void {
        let request = NewsDetailRequest(token: self.token, newsId: newsId)
        Session.send(request) { result in
            switch result{
            case .success(let newsDetailRoot):
                callback(EscApiCallback<NewsDetailRoot>(response: newsDetailRoot, bool: true))
            case .failure( _):
                callback(EscApiCallback<NewsDetailRoot>(bool: false))
            }
        }
    }
    
    // MARK: スケジュール
    static func scheduleRequest(year:Int, month:Int, callback: @escaping (EscApiCallback<ScheduleRoot>) -> Void) -> Void {
        let request = ScheduleRequest(token: self.token, year:year, month: month)
        Session.send(request) { result in
            switch result{
            case .success(let scheduleRoot):
                callback(EscApiCallback<ScheduleRoot>(response: scheduleRoot, bool: true))
            case .failure( _):
                callback(EscApiCallback<ScheduleRoot>(bool: false))
            }
        }
    }
}

struct EscApiCallback<T>{
    var response:T?
    var bool:Bool
    
    init(bool:Bool){
        response = nil
        self.bool = bool
    }
    init(response:T, bool:Bool) {
        self.response = response
        self.bool = bool
    }
}
