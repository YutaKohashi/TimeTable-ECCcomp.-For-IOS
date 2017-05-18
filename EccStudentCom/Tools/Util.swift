//
//  Util.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/12.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit

class Util {
    
    static func isConnectedToNetwork()->Bool{
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    // MARK:テキストフィールドチェック
    static func checkTextFiled(idTextField:UITextField,passwordTextField:UITextField) -> Bool{
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
    
    static func getNow() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let string = formatter.string(from: now)
        
        return string
    }
    
    
    // 実行している端末のタイプを取得するメソッド
    public static func getDeviceType() -> DeviceType{
        var size:Int = 0
        let myBoundSize: CGSize = UIScreen.main.bounds.size
        if isLandscape() {
            size = Int(myBoundSize.width)
        } else {
            size = Int(myBoundSize.height)
        }
//        let myBoundSizeStr: String = "Bounds width: \(myBoundSize.width) height: \(myBoundSize.height)"
        switch(size){
        case 1366:
            return .iPadPro
        case 1024:
            return .iPad
        case 736:
            return .iPhone7sPlus
        case 667:
            return .iPhone7
        case 568:
            return .iPhone5
        default:
            return .undifined
        }
    }
    
    // デバイスのタイプを定義
    public enum DeviceType {
        case iPadPro
        case iPad
        case iPhone5
        case iPhone7
        case iPhone7sPlus
        case undifined
    }
    
    
    public static func isLandscape() -> Bool {
        return UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)
    }
    
    public static func getPrimaryColor() -> UIColor{
        return UIColor(hue: 0.5444, saturation: 0.99, brightness: 0.39, alpha: 1.0)
    }
    
    public static func setStatusBarBackgroundColor(color: UIColor) {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }

}
