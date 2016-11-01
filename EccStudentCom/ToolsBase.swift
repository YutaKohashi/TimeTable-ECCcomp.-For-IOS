//
//  ToolsBase.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/09/26.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit
import KRProgressHUD


class ToolsBase{
    
    init(){
        
    }
    
    func showToast(_ message:String,isShortLong:Bool){
    }
    
    func CheckReachability(_ host_name:String)->Bool{
        
        let reachability = SCNetworkReachabilityCreateWithName(nil, host_name)!
        var flags = SCNetworkReachabilityFlags.connectionAutomatic
        if !SCNetworkReachabilityGetFlags(reachability, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    //テキストフィールドに値が入力されているか
    func loginCheck() -> Bool{
        
        let ud = UserDefaults.standard
        let bool : Bool = ud.bool(forKey: "login") 
        
        return bool
        
    }
    
    //テキストフィールドチェック
    func checkTextFiled(idTextField:UITextField,passwordTextField:UITextField) -> Bool{
        var flg:Bool = false
        let num = idTextField.text?.characters.count
        if num == 0{
            flg = true
        }
        let num2 = passwordTextField.text?.characters.count
        if num2 == 0{
            flg = true
        }
        return flg
    }

}

