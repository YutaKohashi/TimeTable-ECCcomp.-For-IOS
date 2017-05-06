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
            case .success(let token):
                callback(EscApiCallback<Token>(response:token, bool:true))
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
