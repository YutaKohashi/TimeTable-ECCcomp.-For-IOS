//
//  HttpRequest.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/10/31.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

//このクラスではHttpRequestBaseをラップする
//Save処理はここに記述
//ダイアログは参照元で記述
class HttpRequest:HttpRequestBase{
    
    // MARK:時間割を競って画面から更新updateTimetable
    func updateTimetable(userId :String,password:String,callback: @escaping (Bool) -> Void) -> Void {
        
        // 時間割（クロージャ）
        self.requestTimeTable(userId: userId, password: password,callback: {
            requestResult in
            //成功時のみ
            if(requestResult.bool){
                //保存処理
                //Realmをインスタンス化
                let realmSwift = try! Realm()
                //一度データを削除
                let savemodels = realmSwift.objects(TimeTableSaveModel)
                savemodels.forEach({ (model) in
                    try! realmSwift.write() {
                        realmSwift.delete(model)
                    }
                })
                
                SaveManager().saveTimeTable(realmSwift, mLastResponseHtml: requestResult.string)
            }
            callback(requestResult.bool)
        })
    }
    
    // MARK:時間割と出席照会を取得し保存するメソッド
    func reequestTimeTableAttendanseRate(userId :String,password:String,callback: @escaping (Bool) -> Void) -> Void {
        
        // 時間割
        self.requestTimeTable(userId: userId, password: password,callback: {
            requestResult in
            if(requestResult.bool){
                
                //保存処理
                let realmSwift = try! Realm()
                SaveManager().saveTimeTable(realmSwift, mLastResponseHtml: requestResult.string)
                
                //　出席照会
                self.reequestAttendanseRate(userId: userId, password: password,callback: {
                    requestResult in
                    
                    //成功時のみ保存処理
                    if(requestResult.bool){
                        let realm = try! Realm()
                        //出席率をデータベースへ保存
                        let saveManager = SaveManager()
                        saveManager.saveAttendanceRate(realm, mLastResponseHtml: requestResult.string)
                        //ログインしたことを保存
                        saveManager.saveLoginState(true)
                        //passIdを保存
                        saveManager.saveIdPass(userId, pass: password)
                    }
                    
                    
                    callback(requestResult.bool)
                 })
            }else{
                //失敗
                callback(false)
            }
        })
    }
}
