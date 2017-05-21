//
//  PreferenceManager.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/11/06.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import Foundation

//設定関連の処理
class PrefUtil{
    static let NOW_VERSION:String = "2.0.0"
    static fileprivate let LOGIN_KEY:String = "login" + "2.0.0"
    static fileprivate let LOGINED_KEY:String = "login" + "1.4.2" //一つ前のバージョンのログインキー
    
    static fileprivate let ID:String = "id"
    static fileprivate let PASS:String = "pass"
    static fileprivate let COLOR_PREF:String = "colorpref"
    static fileprivate let LATEST_UPDATE = "latest_upate"
    static fileprivate let TANIN_NEWS_LATEST_UPDATE = "tanin_news_latest_upate"
    static fileprivate let SCHOOL_NEWS_LATEST_UPDATE = "shool_news_latest_upate"
    static fileprivate let NOTIFY_NEWS_TITLE = "notify_news_title"
    static fileprivate let NOTIFY_NEWS_DATE = "notify_news_date"
    static fileprivate let NOTIFY_NEWS_NEWSID = "notify_news_newsid"
    
    
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
    
    // MARK: - 学校からのお知らせのアップデート情報
    static func saveLatestUpdateASchoolNews(now : String){
        let ud = UserDefaults.standard
        ud.set(now, forKey: SCHOOL_NEWS_LATEST_UPDATE)
        ud.synchronize()
    }
    
    // get information with latest update
    static func getLatestUpdateSchoolNews() -> String{
        let ud = UserDefaults.standard
        return ud.object(forKey: SCHOOL_NEWS_LATEST_UPDATE) as! String
    }
    
    // MARK: - 担任からのお知らせのアップデート情報
    static func saveLatestUpdateTaninNews(now : String){
        let ud = UserDefaults.standard
        ud.set(now, forKey: TANIN_NEWS_LATEST_UPDATE)
        ud.synchronize()
    }
    
    // get information with latest update
    static func getLatestUpdateTaninNews() -> String{
        let ud = UserDefaults.standard
       return ud.object(forKey: TANIN_NEWS_LATEST_UPDATE)  as! String
    }
    
    
    static func setTaninSchoolDefaultUpdate(){
        let ud = UserDefaults.standard
        ud.register(defaults: [SCHOOL_NEWS_LATEST_UPDATE: "-/-/- -:-"])
        ud.register(defaults: [TANIN_NEWS_LATEST_UPDATE: "-/-/- -:-"])
        ud.synchronize()
    }
    
    // -----------------------------------------------------------------------------
    
    static func setNotifyNewsTitle(title:String){
        let ud = UserDefaults.standard
        ud.set(title, forKey: NOTIFY_NEWS_TITLE)
        ud.synchronize()
    }
    
    static func setNotifyNewsDate(date:String){
        let ud = UserDefaults.standard
        ud.set(date, forKey: NOTIFY_NEWS_DATE)
        ud.synchronize()
    }
    
    static func setNotifyNewsId(newsId:Int){
        let ud = UserDefaults.standard
        ud.set(newsId, forKey: NOTIFY_NEWS_NEWSID)
        ud.synchronize()
    }
    
    static func getNotifyNewsTItle() -> String {
        let ud = UserDefaults.standard
        return ud.object(forKey: NOTIFY_NEWS_TITLE) as! String
    }
    
    static func getNotifyNewsDate() -> String {
        let ud = UserDefaults.standard
        return ud.object(forKey: NOTIFY_NEWS_DATE) as! String
    }
    
    static func getNotifyNewsNewsId() -> Int {
        let ud = UserDefaults.standard
        return ud.object(forKey: NOTIFY_NEWS_NEWSID) as! Int
    }
}
