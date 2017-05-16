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
                let tkn:String? = response.token
                if tkn == nil {
                    callback(EscApiCallback<Token>(bool: false))
                } else {
                    if response.code == EscApiConst.ERROR_AUTH {
                        callback(EscApiCallback<Token>(bool: false))
                    } else {
                        self.token = tkn!
                        callback(EscApiCallback<Token>(response:response, bool:true))
                    }
                }
            case .failure( _):
                callback(EscApiCallback<Token>(bool: false))
            }
        }
    }
    
    
    // MARK:時間割を取得するメソッド
    static func timeTableRequest(userId:String, password:String , callback: @escaping (EscApiCallback<RootTimeTable>) -> Void) -> Void {
        var request = TimeTableRequest(token: self.token, code:userId)
        Session.send(request) { result in
            switch result {
            case .success(let rootTimeTable):
                if rootTimeTable.code == EscApiConst.SUCCESS_AUTH {
                    callback(EscApiCallback<RootTimeTable>(response: rootTimeTable,bool: true))
                }  else if rootTimeTable.code == EscApiConst.ERROR_EXPIRED_TOKEN || rootTimeTable.code == EscApiConst.ERROR_INVALID_TOKEN {
                    self.tokenRequest(userId: userId, password: password, callback: { (callback1) in
                        if callback1.bool {
                            request = TimeTableRequest(token: self.token, code:userId)
                            Session.send(request) { result in
                                switch result{
                                case .success(let rootTimeTable1):
                                    if rootTimeTable1.code == EscApiConst.SUCCESS_AUTH {
                                        callback(EscApiCallback<RootTimeTable>(response: rootTimeTable1,bool: true))
                                    } else {
                                        callback(EscApiCallback<RootTimeTable>(bool: false))
                                    }
                                case .failure( _):
                                    callback(EscApiCallback<RootTimeTable>(bool: false))
                                }
                            }
                        } else {
                            callback(EscApiCallback<RootTimeTable>(bool: false))
                        }
                    })
                } else {
                    callback(EscApiCallback<RootTimeTable>(bool: false))
                }
            case .failure( _):
                self.tokenRequest(userId: userId, password: password, callback: { (callback1) in
                    if callback1.bool {
                        request = TimeTableRequest(token: self.token, code:userId)
                        Session.send(request) { result in
                            switch result{
                            case .success(let rootTimeTable2):
                                if rootTimeTable2.code == EscApiConst.SUCCESS_AUTH {
                                    callback(EscApiCallback<RootTimeTable>(response: rootTimeTable2,bool: true))
                                } else {
                                    callback(EscApiCallback<RootTimeTable>(bool: false))
                                }
                            case .failure( _):
                                callback(EscApiCallback<RootTimeTable>(bool: false))
                            }
                        }
                    } else {
                        callback(EscApiCallback<RootTimeTable>(bool: false))
                    }
                })

            }
        }
    }
    
    // MARK:学校からのお知らせ
    static func schoolNewsRequest(userId:String, password:String , callback: @escaping (EscApiCallback<NewsArray>) -> Void) -> Void {
        var request = NewsRequest(token: self.token, type: NewsRequest.NewsType.school , limit: 100)
        Session.send(request) { result in
            switch result{
            case .success(let newsArray):
                if newsArray.code == EscApiConst.SUCCESS_AUTH {
                    //　成功
                    callback(EscApiCallback<NewsArray>(response: newsArray, bool: true))
                }  else if newsArray.code == EscApiConst.ERROR_EXPIRED_TOKEN || newsArray.code == EscApiConst.ERROR_INVALID_TOKEN {
                    self.tokenRequest(userId: userId, password: password, callback: { (callback1) in
                        if callback1.bool {
                            request = NewsRequest(token: self.token, type: NewsRequest.NewsType.school , limit: 100)
                            Session.send(request) { result in
                                switch result{
                                case .success(let newsArray):
                                    if newsArray.code == EscApiConst.SUCCESS_AUTH {
                                        //　成功
                                        callback(EscApiCallback<NewsArray>(response: newsArray, bool: true))
                                    } else {
                                        callback(EscApiCallback<NewsArray>(bool: false))
                                    }
                                case .failure( _):
                                    callback(EscApiCallback<NewsArray>(bool: false))
                                }
                            }
                        } else {
                            callback(EscApiCallback<NewsArray>(bool: false))
                        }
                    })
                } else {
                    callback(EscApiCallback<NewsArray>(bool: false))
                }
            case .failure( _):
                self.tokenRequest(userId: userId, password: password, callback: { (callback1) in
                    if callback1.bool {
                        request = NewsRequest(token: self.token, type: NewsRequest.NewsType.school , limit: 100)
                        Session.send(request) { result in
                            switch result{
                            case .success(let newsArray):
                                if newsArray.code == EscApiConst.SUCCESS_AUTH {
                                    //　成功
                                    callback(EscApiCallback<NewsArray>(response: newsArray, bool: true))
                                } else {
                                    callback(EscApiCallback<NewsArray>(bool: false))
                                }
                            case .failure( _):
                                callback(EscApiCallback<NewsArray>(bool: false))
                            }
                        }
                    } else {
                        callback(EscApiCallback<NewsArray>(bool: false))
                    }
                })
            }
        }
    }
    
    // MARK:担任からのお知らせ
    static func taninNewsRequest(userId:String, password:String ,callback: @escaping (EscApiCallback<NewsArray>) -> Void) -> Void {
        var request = NewsRequest(token: self.token, type: NewsRequest.NewsType.tanin , limit: 100)
        Session.send(request) { result in
            switch result{
            case .success(let newsArray):
                if newsArray.code == EscApiConst.SUCCESS_AUTH {
                    // 成功
                    callback(EscApiCallback<NewsArray>(response: newsArray, bool: true))
                } else if newsArray.code == EscApiConst.ERROR_EXPIRED_TOKEN || newsArray.code == EscApiConst.ERROR_INVALID_TOKEN {
                    self.tokenRequest(userId: userId, password: password, callback: { (callback1) in
                        if callback1.bool {
                            request = NewsRequest(token: self.token, type: NewsRequest.NewsType.tanin , limit: 100)
                            Session.send(request) { result in
                                switch result{
                                case .success(let newsArray):
                                    if newsArray.code == EscApiConst.SUCCESS_AUTH {
                                        //　成功
                                        callback(EscApiCallback<NewsArray>(response: newsArray, bool: true))
                                    } else {
                                        callback(EscApiCallback<NewsArray>(bool: false))
                                    }
                                case .failure( _):
                                    callback(EscApiCallback<NewsArray>(bool: false))
                                }
                            }
                        } else {
                            callback(EscApiCallback<NewsArray>(bool: false))
                        }
                    })
                } else {
                    callback(EscApiCallback<NewsArray>(bool: false))
                }
            case .failure( _):
                self.tokenRequest(userId: userId, password: password, callback: { (callback1) in
                    if callback1.bool {
                        request = NewsRequest(token: self.token, type: NewsRequest.NewsType.tanin , limit: 100)
                        Session.send(request) { result in
                            switch result{
                            case .success(let newsArray):
                                if newsArray.code == EscApiConst.SUCCESS_AUTH {
                                    //　成功
                                    callback(EscApiCallback<NewsArray>(response: newsArray, bool: true))
                                } else {
                                    callback(EscApiCallback<NewsArray>(bool: false))
                                }
                            case .failure( _):
                                callback(EscApiCallback<NewsArray>(bool: false))
                            }
                        }
                    } else {
                        callback(EscApiCallback<NewsArray>(bool: false))
                    }
                })
            }
        }
    }
    
    // MARK: お知らせ詳細
    static func newsDetailRequest(userId:String, password:String ,newsId:Int, callback: @escaping (EscApiCallback<NewsDetailRoot>) -> Void) -> Void {
        var request = NewsDetailRequest(token: self.token, newsId: newsId)
        Session.send(request) { result in
            switch result{
            case .success(let newsDetailRoot):
                if newsDetailRoot.code != EscApiConst.SUCCESS_AUTH  {
                    self.tokenRequest(userId: userId, password: password, callback: { (callback1) in
                        if callback1.bool {
                            request = NewsDetailRequest(token: self.token, newsId: newsId)
                            Session.send(request){ result in
                                switch result {
                                case .success(let newsDetailRoot):
                                    if newsDetailRoot.code == EscApiConst.SUCCESS_AUTH {
                                        callback(EscApiCallback<NewsDetailRoot>(response: newsDetailRoot, bool: true))
                                    } else {
                                        callback(EscApiCallback<NewsDetailRoot>(bool: false))
                                    }
                                    
                                case .failure( _):
                                    callback(EscApiCallback<NewsDetailRoot>(bool: false))
                                }
                            }
                        } else {
                            callback(EscApiCallback<NewsDetailRoot>(bool: false))
                        }
                    })
                    
                } else {
                    // success
                    callback(EscApiCallback<NewsDetailRoot>(response: newsDetailRoot, bool: true))
                }
            case .failure( _):
                self.tokenRequest(userId: userId, password: password, callback: { (callback1) in
                    if callback1.bool {
                        request = NewsDetailRequest(token: self.token, newsId: newsId)
                        Session.send(request){ result in
//                            print(result.error? ?? "")
                            switch result {
                            case .success(let newsDetailRoot):
                                if newsDetailRoot.code == EscApiConst.SUCCESS_AUTH {
                                    callback(EscApiCallback<NewsDetailRoot>(response: newsDetailRoot, bool: true))
                                } else {
                                    callback(EscApiCallback<NewsDetailRoot>(bool: false))
                                }
                                
                            case .failure( _):
                                callback(EscApiCallback<NewsDetailRoot>(bool: false))
                            }
                        }
                    } else {
                        callback(EscApiCallback<NewsDetailRoot>(bool: false))
                    }
                })
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
