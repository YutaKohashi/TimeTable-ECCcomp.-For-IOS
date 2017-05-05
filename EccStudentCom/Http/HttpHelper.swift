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
        // 時間割
        self.requestTimeTable(userId: userId, password: password,callback: {
            requestResult in
            
            if(requestResult.bool){
                
                let names = self.getTeacherNames(html: requestResult.string)
                
                //保存処理
                let realmSwift = try! Realm()
                //データを削除
                let savemodels = realmSwift.objects(TimeTableSaveModel.self)
                savemodels.forEach({ (model) in
                    try! realmSwift.write() {
                        realmSwift.delete(model)
                    }
                })
                SaveManager().saveTimeTable(realmSwift,mLastResponseHtml: requestResult.string,names:names)
            }
            callback(requestResult.bool)
        })
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
        self.requestNews(userId: userId, passoword: password) { (cb1) in
            if(cb1.bool){
                let realm = try! Realm()
                let saveModels = realm.objects(SchoolNewsItem.self)
                saveModels.forEach({ (model) in
                    try! realm.write() {
                        realm.delete(model)
                    }
                })
                
                SaveManager().saveSchoolNews(realm, mLastResponseHtml: cb1.string)
            }
            callback(cb1.bool)
        }
    }
    
    // MARK:担任からのお知らせ
    func getTaninNews(userId:String,password:String,callback:@escaping(Bool) -> Void) -> Void{
        self.requestNews(userId: userId, passoword: password) { (cb1) in
            if(cb1.bool){
                let realm = try! Realm()
                let saveModels = realm.objects(TaninNewsItem.self)
                saveModels.forEach({ (model) in
                    try! realm.write() {
                        realm.delete(model)
                    }
                })
                
                SaveManager().saveTaninNews(realm, mLastResponseHtml: cb1.string)
            }
            callback(cb1.bool)
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
    func getNewsDetail(userId:String, password:String, uri:String,callback:@escaping(CallBackClass) -> Void) -> Void {
        self.requestNewsDetail(userId:userId,password:password, uri:uri, callback:{(cb1) in
            callback(cb1)
        })
    }
    
    /******************************************  private  ***********************************************************/
    
    //先生名を取得するメソッド
    //連続GET
    private func getTeacherNames(html:String) -> [String]{
        var names:[String] = []
        let urls:[String] = getTeacherURLs(html: html)
        let htmls:[String] = self.continuousRequest(urls: urls, method: "GET")
        for html in htmls{
            names.append(getTeacherName(html: html))
        }
        
        return names
    }
    
    private func getTeacherURLs(html:String) -> [String]{
        let urls:[String] = GetValuesBase("<a href=\"(.+?)\">投書<").getGroupValues(html)
        var result:[String] = []
        for url in urls{
            result.append(GetValuesBase("<a href=\"(.+?)\">投書<").getValues(url))
        }
        return result
    }
    
    private func getTeacherName(html:String) -> String{
        var name = GetValuesBase("<h3>受信者</h3>\n*\\s*<p>(.+?)</p>").getValues(html)
        name = fixName(name:name)
        return name
    }
    
    //replace two more \s to one
    private func fixName(name:String) -> String{
        var fixedname = name.replacingOccurrences(of:"      ", with: " ")
        fixedname = fixedname.replacingOccurrences(of:"      ", with: " ")
        fixedname = fixedname.replacingOccurrences(of:"     ", with: " ")
        fixedname = fixedname.replacingOccurrences(of:"    ", with: " ")
        fixedname = fixedname.replacingOccurrences(of:"   ", with: " ")
        fixedname = fixedname.replacingOccurrences(of:"  ", with: " ")
        return fixedname
    }
    
    // MARK: -
    // MARK:時間割を取得
    private func requestTimeTable(userId :String,password:String,callback: @escaping (CallBackClass) -> Void) -> Void {
        self.loginToESCuserId(userId: userId, password: password, callback: {(requestResult) in
            callback(requestResult)
        })
    }
    
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
    
    // MARK:NEWSページへ遷移するメソッド
    private func requestNews(userId:String,passoword:String, callback: @escaping (CallBackClass) -> Void) -> Void {
        self.loginToESCuserId(userId: userId, password: passoword, callback: {(requestResult) in
            callback(requestResult)
        })
    }
    
    private func requestNewsDetail(userId:String,password:String,uri:String, callback: @escaping (CallBackClass) -> Void) -> Void {
        self.loginToESCuserId(userId: userId, password: password, callback: {(requestResult) in
            if requestResult.bool{
                self.httpGet(url:uri,
                        requestBody: "",
                        referer: self.URL.ESC_LOGIN,
                        header:true){(cb1) in
                            callback(cb1)
                }
            } else {
                callback(requestResult)
            }
        })
    }
    
    
    // MARK:EccStudentCommunicationにログインするメソッド
    private func loginToESCuserId(userId:String,password:String,callback: @escaping (CallBackClass) -> Void) -> Void {
        httpGet(url: URL.ESC_TO_PAGE,
                requestBody:"" ,
                referer: URL.DEFAULT_REFERER,
                header: true)
        { (cb1) in
            if(cb1.bool){
                self.httpPost(url: self.URL.ESC_LOGIN,
                              requestBody: self.BODY.createPostDataForEscLogin(userId: userId,
                                                                               passwrod: password,
                                                                               mLastResponseHtml: cb1.string),
                              referer: self.URL.ESC_TO_PAGE,
                              header: true)
                { (cb2) in
                    callback(cb2)
                }
            }else{callback(cb1)} //false
        }
    }
}
