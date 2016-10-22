//
//  SaveManager.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/09/27.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import Foundation
import RealmSwift

class SaveManager{
    
    func saveAttendanceRate(_ realm:Realm ,mLastResponseHtml:String){
        
        var value:String = mLastResponseHtml.replacingOccurrences(of: "\r", with: "")
        value = value.replacingOccurrences(of: "\n", with: "")
        //                    print("value = \(value)")
        let narrowHtml :String = GetValuesBase("<table class=\"GridVeiwTable\"","</table>").narrowingValues(value)
        
        //教科ごと
        let results: [String] =  GetValuesBase("<tr>.*?</tr>").getGroupValues(narrowHtml)
        
        var item:String! = ""
        var rowCount = 0
        var firstRowFlg: Bool = true
        
        for row:String in results{
            let col: [String] =  GetValuesBase("<td.*?</td>").getGroupValues(row)
            
            let saveModel = SaveModel()
            
            firstRowFlg = true
            rowCount = 0
            for td:String in col{
                if(firstRowFlg){
                    //教科名を取得
                    saveModel.subjectName = GetValuesBase("<img(?:\\\".*?\\\"|\\'.*?\\'|[^\\'\\\"])*?>(.+?)</a>").getValues(td)
                    firstRowFlg = false
                    print("subjectName= \(saveModel.subjectName)")
                }else{
                    item = GetValuesBase("<font(?:\\\".*?\\\"|\\'.*?\\'|[^\\'\\\"])*?>(.+?)</font>").getValues(td)
                    item = self.removeNBSP(item)
                    item = self.removePercent(item)
                    
                    switch rowCount {
                    case 1:
                        saveModel.unit = item
                        print("unit= \(item)")
                    case 2:
                        saveModel.attendanceNumber = item
                        print("attendanceNumber= \(item)")
                    case 3:
                        saveModel.absentNumber = item
                        print("absentNumber= \(item)")
                    case 4:
                        saveModel.lateNumber = item
                        print("lateNumber= \(item)")
                    case 5:
                        saveModel.publicAbsentNumber1 = item
                        print("publicAbsentNumber1= \(item)")
                    case 6:
                        saveModel.publicAbsentNumber2 = item
                        print("publicAbsentNumber2= \(item)")
                    case 7:
                        saveModel.attendanceRate = item
                        print("attendanceRate= \(item)")
                    case 8:
                        saveModel.shortageNumber = item
                        print("shortageNumber= \(item)")
                    default:
                        print("default")
                        
                    }
                    
                }
                rowCount+=1
            }
            
            //データを保存
            try! realm.write {
                realm.add(saveModel)
            }
            print(" \("")")
            print("------------------- \("")")
            print(" \("")")
            
        }
    }
    
    func saveLoginState(_ bool:Bool){
        //ログインしたことを保存
        let ud = UserDefaults.standard
        ud.set(bool, forKey: "login")
        ud.synchronize()
    }
    
    //ログイン時に使用したid,passを保存
    func saveIdPass(_ id:String,pass:String){
        let ud = UserDefaults.standard
        ud.set(id, forKey: "id")
        ud.set(pass, forKey: "pass")
        ud.synchronize()
    }
    
    //id,passを削除
    func removeSavedIdPass(){
        let ud = UserDefaults.standard
        ud.removeObject(forKey: "id")
        ud.removeObject(forKey: "pass")
    }
    
    //saveされているIdを取得
    func getSavedId() -> String{
        let ud = UserDefaults.standard
        return ud.object(forKey: "id")  as! String
    }
    
    //saveされているpassを取得
    func getSavedPass() -> String{
        let ud = UserDefaults.standard
        return ud.object(forKey: "pass")  as! String
    }
    
    func removePercent(_ str:String) -> String{
        return str.replacingOccurrences(of: "%", with: "")
    }
    func removeNBSP(_ str:String)->String{
        return str.replacingOccurrences(of: "&nbsp;", with: "0")
    }
    
}
