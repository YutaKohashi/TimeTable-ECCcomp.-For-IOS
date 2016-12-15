//
//  HttpHelper.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/11/09.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import Foundation
import RealmSwift

class HttpHelper:HttpBase{
    
    let URL = RequestURL()
    let BODY = RequestBody()
    
    // MARK:時間割を取得
    func getTimeTable(_ userId :String,password:String,callback: @escaping (Bool) -> Void) -> Void {
        // 時間割
        self.requestTimeTable(userId, password: password,callback: {
            requestResult in
            
            if(requestResult.bool){
                
                let names = self.getTeacherNames(requestResult.string)
                
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
    func getAttendanceRate(_ userId :String,password:String,callback: @escaping (Bool) -> Void) -> Void {
        self.reequestAttendanseRate(userId, password: password) { (requestResult) in
            
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
    func getTimeTableAttendanceRate(_ userId :String,password:String,callback: @escaping (Bool) -> Void) -> Void {
        getTimeTable(userId, password: password) { (cb1) in
            if(cb1){
                self.getAttendanceRate(userId, password: password, callback:
                    { (cb2) in
                        callback(cb2)
                })
            }else{callback(cb1)}
        }
    }
    
    //先生名を取得するメソッド
    //連続GET
    func getTeacherNames(_ html:String) -> [String]{
        var names:[String] = []
        let urls:[String] = getTeacherURLs(html)
        let htmls:[String] = self.continuousRequest(urls, method: "GET")
        for html in htmls{
            names.append(getTeacherName(html))
        }
        
        return names
    }
    
    func getTeacherURLs(_ html:String) -> [String]{
        let urls:[String] = GetValuesBase("<a href=\"(.+?)\">投書<").getGroupValues(html)
        var result:[String] = []
        for url in urls{
            result.append(GetValuesBase("<a href=\"(.+?)\">投書<").getValues(url))
        }
        return result
    }
    
    func getTeacherName(_ html:String) -> String{
        var name = GetValuesBase("<h3>受信者</h3>\n*\\s*<p>(.+?)</p>").getValues(html)
        name = fixName(name)
        return name
    }
    
    //replace two more \s to one
    func fixName(_ name:String) -> String{
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
    fileprivate func requestTimeTable(_ userId :String,password:String,callback: @escaping (CallBackClass) -> Void) -> Void {
        httpGet(URL.ESC_TO_PAGE,
                requestBody:"" ,
                referer: URL.DEFAULT_REFERER,
                header: true)
        { (cb1) in
            if(cb1.bool){
                self.httpPost(self.URL.ESC_LOGIN,
                              requestBody: self.BODY.createPostDataForEscLogin(userId,
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
    
    // MARK:出席率を取得
    fileprivate func reequestAttendanseRate(_ userId :String,password:String,callback: @escaping (CallBackClass) -> Void) -> Void {
        httpGet(URL.YS_TO_PAGE,
                requestBody:"" ,
                referer: URL.DEFAULT_REFERER,
                header: true)
        { (cb1) in
            if(cb1.bool){
                self.httpPost(self.URL.YS_LOGIN,
                              requestBody: self.BODY.createPostDataForYSLogin(userId,
                                                                              password:password,
                                                                              mLastResponseHtml: cb1.string),
                              referer: self.URL.YS_TO_PAGE,
                              header: true)
                { (cb2) in
                    if(cb2.bool){
                        self.httpPost(self.URL.YS_TO_RATE_PAGE,
                                      requestBody: self.BODY.createPostDataForRatePage(cb2.string),
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
