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
    
    func showToast(message:String,isShortLong:Bool){
    }
    
    func CheckReachability(host_name:String)->Bool{
        
        let reachability = SCNetworkReachabilityCreateWithName(nil, host_name)!
        var flags = SCNetworkReachabilityFlags.ConnectionAutomatic
        if !SCNetworkReachabilityGetFlags(reachability, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    //テキストフィールドに値が入力されているか
    func loginCheck() -> Bool{
        
        let ud = NSUserDefaults.standardUserDefaults()
        let bool : Bool = ud.boolForKey("login") ?? false
        
        return bool
        
    }

}

