//
//  DialogManager.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/10/30.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import Foundation
import KRProgressHUD

class DialogManager{
    
    func showIndicator(){
        KRProgressHUD.show(progressHUDStyle: .white,
                           maskType: .black,
                           activityIndicatorStyle: .color(UIColor.blue, UIColor.blue),
                           message: "お待ち下さい")
    }
    
    func hideIndicator(){
        KRProgressHUD.dismiss()
    }
    
    func showError(){
        KRProgressHUD.showError(progressHUDStyle: .whiteColor,maskType: .black)
        let sec:Double = 4
        let delay = sec * Double(NSEC_PER_SEC)
        let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            KRProgressHUD.dismiss()
        })
    }
    
    func showSuccess(){
        KRProgressHUD.showSuccess(progressHUDStyle: .whiteColor,
                                  maskType: .black)
        
        let sec:Double = 3
        let delay = sec * Double(NSEC_PER_SEC)
        let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            KRProgressHUD.dismiss()
        })
    }
    
    func showWarningForInternet(){
        KRProgressHUD.showWarning(progressHUDStyle: .whiteColor,
                                  maskType: .black,
                                  message:"インターネット未接続")
        
        let sec:Double = 4
        let delay = sec * Double(NSEC_PER_SEC)
        let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            KRProgressHUD.dismiss()
        })
    }
    
    func showWarningForTextField(){
        KRProgressHUD.showWarning(progressHUDStyle: .whiteColor,
                                  maskType: .black,
                                  message:"未入力")
        
        let sec:Double = 4
        let delay = sec * Double(NSEC_PER_SEC)
        let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            KRProgressHUD.dismiss()
        })
    }
}
