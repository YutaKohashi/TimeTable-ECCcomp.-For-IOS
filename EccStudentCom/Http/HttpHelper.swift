//
//  HttpHelper.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/11/09.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import Foundation
import RealmSwift

internal class HttpHelper:HttpBase{
    
    let URL = RequestURL()
    let BODY = RequestBody()
    
    /******************************************  public  ***********************************************************/
    
    // MARK:時間割を取得
    internal func getTimeTable(userId :String,password:String,callback: @escaping (Bool) -> Void) -> Void {
        EscApiManager.timeTableRequest(code: userId) { (callback1) in
            if(callback1.bool){
                
            }else {
                //トークン再取得
                EscApiManager.tokenRequest(userId: userId, password: password, callback: { (callback2) in
                    if(callback2.bool){
                        EscApiManager.timeTableRequest(code: userId, callback: { (callback3) in
                            if(callback3.bool){
                                // 時間割保存処理
                                
                                callback(true)
                            } else {
                                callback(false)
                            }
                        })
                    } else {
                        callback(false)
                    }
                })
            }
        }
    }
    
    // MARK:出席照会リスト
    func getAttendanceRate(userId :String,password:String,callback: @escaping (Bool) -> Void) -> Void {
        self.reequestAttendanseRate(userId: userId, password: password) { (requestResult) in
            
            if(requestResult.bool){
                //Realmをインスタンス化
                let realm = try! Realm()
                //一度データを削除
                let savemodels = realm.objects(SaveModel.self)
                savemodels.forEach({ (model) in
                    try! realm.write() {
                        realm.delete(model)
                    }
                })
                SaveManager().saveAttendanceRate(realm,mLastResponseHtml: requestResult.string)
            }
            callback(requestResult.bool)
        }
    }
    
    // MARK:時間割と出席照会を取得し保存するメソッド
    func getTimeTableAttendanceRate(userId :String,password:String,callback: @escaping (Bool) -> Void) -> Void {
        getTimeTable(userId: userId, password: password) { (cb1) in
            if(cb1){
                self.getAttendanceRate(userId: userId, password: password, callback:
                    { (cb2) in
                        callback(cb2)
                })
            }else{callback(cb1)}
        }
    }
    
    
    // MARK:学校からのお知らせ
    func getSchoolNews(userId:String, password:String, callback:@escaping(Bool) -> Void) -> Void{
        EscApiManager.schoolNewsRequest { (callback1) in
            if callback1.bool {
                // 学校からのお知らせを保存
                 callback(true)
            } else {
                EscApiManager.tokenRequest(userId: userId, password: password, callback: { (callback2) in
                    if callback2.bool {
                        EscApiManager.schoolNewsRequest(callback: { (callback3) in
                            if callback3.bool {
                                // 学校からのおしらせを保存
                                 callback(true)
                            } else {
                                callback(false)
                            }
                        })
                    } else {
                        callback(false)
                    }
                })
            }
        }
    }
    
    // MARK:担任からのお知らせ
    func getTaninNews(userId:String,password:String,callback:@escaping(Bool) -> Void) -> Void{
        EscApiManager.taninNewsRequest { (callback1) in
            if callback1.bool {
                // 学校からのお知らせを保存
                callback(true)
            } else {
                EscApiManager.tokenRequest(userId: userId, password: password, callback: { (callback2) in
                    if callback2.bool {
                        EscApiManager.taninNewsRequest(callback: { (callback3) in
                            if callback3.bool {
                                // 学校からのおしらせを保存
                                callback(true)
                            } else {
                                callback(false)
                            }
                        })
                    } else {
                        callback(false)
                    }
                })
            }
        }
    }
    
    // MARK:学校、担任からのお知らせ
    func getSchoolTaninNews(userId:String,password:String, callback:@escaping(Bool) -> Void) -> Void {
        getSchoolNews(userId: userId, password: password) { (cb1) in
            if(cb1){
                self.getTaninNews(userId: userId, password: password, callback: { (cb2) in
                    callback(cb2)
                })
            }else{
                callback(cb1)
            }
        }
    }
    
    // MARK:お知らせ詳細  
    func getNewsDetail(userId:String, password:String, newsId:Int,callback:@escaping(EscApiCallback<NewsDetailRoot>) -> Void) -> Void {
        EscApiManager.newsDetailRequest(newsId: newsId) { (callback1) in
            if callback1.bool {
                
            } else {
                EscApiManager.tokenRequest(userId: userId, password: password, callback: { (callback2) in
                    if callback2.bool {
                        EscApiManager.newsDetailRequest(newsId: newsId) { (callback3) in
                            if(callback3.bool){
                                callback(EscApiCallback<NewsDetailRoot>(response: callback3.response!, bool: true))
                            } else {
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
    
    /******************************************  private  ***********************************************************/
    
    // MARK:出席率を取得
    private func reequestAttendanseRate(userId :String,password:String,callback: @escaping (CallBackClass) -> Void) -> Void {
        httpGet(url: URL.YS_TO_PAGE,
                requestBody:"" ,
                referer: URL.DEFAULT_REFERER,
                header: true)
        { (cb1) in
            if(cb1.bool){
                self.httpPost(url: self.URL.YS_LOGIN,
                              requestBody: self.BODY.createPostDataForYSLogin(userId:userId,
                                                                              password:password,
                                                                              mLastResponseHtml: cb1.string),
                              referer: self.URL.YS_TO_PAGE,
                              header: true)
                { (cb2) in
                    if(cb2.bool){
                        self.httpPost(url: self.URL.YS_TO_RATE_PAGE,
                                      requestBody: self.BODY.createPostDataForRatePage(mLastResponseHtml: cb2.string),
                                      referer: self.URL.YS_LOGIN,
                                      header: false)
                        { (cb3) in
                            //正常に遷移できているか確認
                            if !GetValuesBase("教科名").ContainsCheck(cb3.string){
                                cb3.bool = false
                                callback(cb3)
                                print(cb3.string)
                                return;
                            }
                            callback(cb3)
                        }
                    }else{callback(cb2)} //false
                }
            }else{callback(cb1)} //false
        }
    }
}
