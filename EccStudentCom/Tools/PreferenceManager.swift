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
    
    static fileprivate let LOGIN_KEY:String = "login" + "1.4.2"
    static fileprivate let LOGINED_KEY:String = "login" + "1.4.1" //一つ前のバージョンのログインキー
    
    static fileprivate let ID:String = "id"
    static fileprivate let PASS:String = "pass"
    static fileprivate let COLOR_PREF:String = "colorpref"
    static fileprivate let LATEST_UPDATE = "latest_upate"
    
    // MARK: -
    // MARK:ログインチェック
    static func loginCheck() -> Bool{
        
        let ud = UserDefaults.standard
        let bool : Bool = ud.bool(forKey: LOGIN_KEY)
        
        return bool
    }
    
    static func loginedCheck() -> Bool{
        let ud = UserDefaults.standard
        let bool : Bool = ud.bool(forKey: LOGINED_KEY)
        
        return bool
    }
    
    // MARK://ログインしたことを保存
    static func saveLoginState(_ bool:Bool){
        let ud = UserDefaults.standard
        ud.set(bool, forKey: LOGIN_KEY)
        ud.synchronize()
    }
    
    static func saveLoginedState(_ bool:Bool){
        let ud = UserDefaults.standard
        ud.set(bool, forKey: LOGINED_KEY)
        ud.synchronize()
    }
    
    // MARK:ログイン時に使用したid,passを保存
    static func saveIdPass(_ id:String,pass:String){
        let ud = UserDefaults.standard
        ud.set(id, forKey: ID)
        ud.set(pass, forKey: PASS)
        ud.synchronize()
    }
    
    // MARK: -
    // MARK:id,passを削除
    static func removeSavedIdPass(){
        let ud = UserDefaults.standard
        ud.removeObject(forKey: ID)
        ud.removeObject(forKey: PASS)
    }
    
    // MARK:saveされているIdを取得
    static func getSavedId() -> String{
        let ud = UserDefaults.standard
        return ud.object(forKey: ID)  as! String
    }
    
    // MARK:saveされているpassを取得
    static func getSavedPass() -> String{
        let ud = UserDefaults.standard
        return ud.object(forKey: PASS)  as! String
    }
    
    // MARK:ログインしたことを保存
    static func saveColorPref(_ bool:Bool){
        let ud = UserDefaults.standard
        ud.set(bool, forKey: COLOR_PREF)
        ud.synchronize()
    }
    
    // MARK: -
    // MARK:出席照会の色
    static func colorStatePref() -> Bool{
        let ud = UserDefaults.standard
        let bool : Bool = ud.bool(forKey: COLOR_PREF)
        
        return bool
    }
    
    // MARK: - 出席照会のアップデート情報
    static func saveLatestUpdateAttendanceRate(now : String){
        let ud = UserDefaults.standard
        ud.set(now, forKey: LATEST_UPDATE)
        ud.synchronize()
    }
    
    // get information with latest update
    static func getLatestUpdateAttendanceRate() -> String{
        let ud = UserDefaults.standard
        return ud.object(forKey: LATEST_UPDATE)  as! String
    }
}
