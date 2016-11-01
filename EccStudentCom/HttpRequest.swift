//
//  HttpRequest.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/10/31.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import Foundation
import UIKit

class HttpRequest:HttpRequestBase{
    
    // 時間割と出席照会を取得し保存するメソッド
    func reequestTimeTableAttendanseRate(idTextField :UITextField,passwordTextField:UITextField,callback: @escaping (Bool) -> Void) -> Void {
        
        // 時間割
        self.requestTimeTable(idTextField: idTextField, passwordTextField: passwordTextField,callback: {
            requestResultBool in
            if(requestResultBool){
                //　出席照会
                self.reequestAttendanseRate(idTextField: idTextField, passwordTextField: passwordTextField,callback: {
                    requestResultBool in
                    callback(requestResultBool)
                 })
            }else{
                //失敗
                callback(false)
            }
        })
    }
}
