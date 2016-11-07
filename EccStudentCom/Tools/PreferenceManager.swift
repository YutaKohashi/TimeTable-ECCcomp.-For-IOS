//
//  PreferenceManager.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/11/06.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import Foundation

//設定関連の処理
class PreferenceManager{
    
    fileprivate let LOGIN_KEY:String = "login" + "1.2.0"
    
    // MARK: -
    // MARK:ログインチェック
    func loginCheck() -> Bool{
        
        let ud = UserDefaults.standard
        let bool : Bool = ud.bool(forKey: LOGIN_KEY)
        
        return bool
        
    }
    
    // MARK://ログインしたことを保存
    func saveLoginState(_ bool:Bool){
        let ud = UserDefaults.standard
        ud.set(bool, forKey: LOGIN_KEY)
        ud.synchronize()
    }
    
    // MARK:ログイン時に使用したid,passを保存
    func saveIdPass(_ id:String,pass:String){
        let ud = UserDefaults.standard
        ud.set(id, forKey: "id")
        ud.set(pass, forKey: "pass")
        ud.synchronize()
    }
    
    // MARK: -
    // MARK:id,passを削除
    func removeSavedIdPass(){
        let ud = UserDefaults.standard
        ud.removeObject(forKey: "id")
        ud.removeObject(forKey: "pass")
    }
    
    // MARK:saveされているIdを取得
    func getSavedId() -> String{
        let ud = UserDefaults.standard
        return ud.object(forKey: "id")  as! String
    }
    
    // MARK:saveされているpassを取得
    func getSavedPass() -> String{
        let ud = UserDefaults.standard
        return ud.object(forKey: "pass")  as! String
    }
    
    // MARK:ログインしたことを保存
    func saveColorPref(_ bool:Bool){
        let ud = UserDefaults.standard
        ud.set(bool, forKey: "colorpref")
        ud.synchronize()
    }
    
    // MARK: -
    // MARK:出席照会の色
    func colorStatePref() -> Bool{
        let ud = UserDefaults.standard
        let bool : Bool = ud.bool(forKey: "colorpref")
        
        return bool
    }
    
    
    
}
