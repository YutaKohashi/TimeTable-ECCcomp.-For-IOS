//
//  Util.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/12.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import UIKit

class Util {
    
    
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
    
}
