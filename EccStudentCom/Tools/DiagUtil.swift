//
//  DialogManager.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/10/30.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import Foundation
import SVProgressHUD

class DiagUtil{
    
    static func showIndicator(){
        //        KRProgressHUD.show(progressHUDStyle: .white,
        //                           maskType: .black,
        //                           activityIndicatorStyle: .color(UIColor.blue, UIColor.blue),
        //                           message: "お待ち下さい")
        showIndicator(string : "")
    }
    
    static func showIndicator(string :String){
       self.initSVProgressHUD()
        SVProgressHUD.show()
        SVProgressHUD.setStatus(string)
    }
    
    static func hideIndicator(){
        SVProgressHUD.dismiss()
        
    }
    
    static func showError(){
        showError(string : "")
    }
    
    static func showError(string:String){
        self.initSVProgressHUD()
        SVProgressHUD.showError(withStatus: string)
        
        let sec:Double = 1.4
        let delay = sec * Double(NSEC_PER_SEC)
        let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            SVProgressHUD.dismiss()
        })
    }
    
    
    
    
    static func showSuccess(){

        showSuccess(string:"")
    }
    
    static func showSuccess(string:String){
        self.initSVProgressHUD()
        SVProgressHUD.showSuccess(withStatus: string)
        
        let sec:Double = 1.3
        let delay = sec * Double(NSEC_PER_SEC)
        let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            SVProgressHUD.dismiss()
        })
    }
    
    static func showWarningForInternet(){
        self.initSVProgressHUD()
        SVProgressHUD.showInfo(withStatus:"インターネット未接続")
        
        
        let sec:Double = 2
        let delay = sec * Double(NSEC_PER_SEC)
        let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            SVProgressHUD.dismiss()
        })
    }
    
    static func showWarningForTextField(){
        self.initSVProgressHUD()
        SVProgressHUD.showInfo(withStatus: "未入力項目があります")
        
        let sec:Double = 2
        let delay = sec * Double(NSEC_PER_SEC)
        let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            SVProgressHUD.dismiss()
        })
    }
    
    private static func initSVProgressHUD(){
        SVProgressHUD.setBackgroundColor(UIColor(hue: 0, saturation: 0, brightness: 0.32, alpha: 1.0))
        SVProgressHUD.setForegroundColor(UIColor.white)
    }
}
