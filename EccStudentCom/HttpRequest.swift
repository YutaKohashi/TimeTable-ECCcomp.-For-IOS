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

class HttpRequest:HttpRequestBase{
    
    // MARK:時間割と出席照会を取得し保存するメソッド
    func reequestTimeTableAttendanseRate(idTextField :UITextField,passwordTextField:UITextField,callback: @escaping (Bool) -> Void) -> Void {
        
        // 時間割
        self.requestTimeTable(idTextField: idTextField, passwordTextField: passwordTextField,callback: {
            requestResult in
            if(requestResult.bool){
                
                //保存処理
                let realmSwift = try! Realm()
                SaveManager().saveTimeTable(realmSwift, mLastResponseHtml: requestResult.string)
                
                //　出席照会
                self.reequestAttendanseRate(idTextField: idTextField, passwordTextField: passwordTextField,callback: {
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
                        saveManager.saveIdPass(idTextField.text!, pass: passwordTextField.text!)
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
