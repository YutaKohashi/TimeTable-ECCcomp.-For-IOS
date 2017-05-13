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
//        
//        var value:String = mLastResponseHtml.replacingOccurrences(of: "\r", with: "")
//        value = value.replacingOccurrences(of: "\n", with: "")
//        
//        //合計データを保存
//        var narrowHtml :String = GetValuesBase(">合計<","</tr>").narrowingValues(value)
//        narrowHtml = GetValuesBase().removeNBSP(narrowHtml)
//        narrowHtml = GetValuesBase().removePercent(narrowHtml)
//        let saveModel = SaveModel()
//        saveModel.subjectName = "合計"
//        saveModel.unit = GetValuesBase("id=\"ctl00_ContentPlaceHolder1_fmvSyuseki_lblTotalTani\">(.+?)<").getValues(narrowHtml)
//        saveModel.attendanceNumber = GetValuesBase("id=\"ctl00_ContentPlaceHolder1_fmvSyuseki_lblTotalShuseki\">(.+?)<").getValues(narrowHtml)
//        saveModel.absentNumber = GetValuesBase("id=\"ctl00_ContentPlaceHolder1_fmvSyuseki_lblTotalKesski\">(.+?)<").getValues(narrowHtml)
//        saveModel.lateNumber = GetValuesBase("id=\"ctl00_ContentPlaceHolder1_fmvSyuseki_lblTotalChikoku\">(.+?)<").getValues(narrowHtml)
//        saveModel.publicAbsentNumber1 = GetValuesBase("id=\"ctl00_ContentPlaceHolder1_fmvSyuseki_lblTotalKouketsu1\">(.+?)<").getValues(narrowHtml)
//        saveModel.publicAbsentNumber2 = GetValuesBase(" id=\"ctl00_ContentPlaceHolder1_fmvSyuseki_lblTotalKouketsu2\">(.+?)<").getValues(narrowHtml)
//        saveModel.attendanceRate = GetValuesBase("id=\"ctl00_ContentPlaceHolder1_fmvSyuseki_lblTotalShutsuritsu\">(.+?)<").getValues(narrowHtml)
//        saveModel.shortageNumber = GetValuesBase("id=\"ctl00_ContentPlaceHolder1_fmvSyuseki_lblTotalFusoku\">(.+?)<").getValues(narrowHtml)
//        //データを保存
//        try! realm.write {
//            realm.add(saveModel)
//        }
//        
//
//        narrowHtml = GetValuesBase("<table class=\"GridVeiwTable\"","</table>").narrowingValues(value)
//        //教科ごと
//        let results: [String] =  GetValuesBase("<tr>.*?</tr>").getGroupValues(narrowHtml)
//        
//        var item:String! = ""
//        var rowCount = 0
//        var firstRowFlg: Bool = true
//        
//        for row:String in results{
//            let col: [String] =  GetValuesBase("<td.*?</td>").getGroupValues(row)
//            
//            let saveModel = SaveModel()
//            
//            firstRowFlg = true
//            rowCount = 0
//            for td:String in col{
//                if(firstRowFlg){
//                    //教科名を取得
//                    saveModel.subjectName = GetValuesBase("<img(?:\\\".*?\\\"|\\'.*?\\'|[^\\'\\\"])*?>(.+?)</a>").getValues(td)
//                    firstRowFlg = false
//                    print("subjectName= \(saveModel.subjectName)")
//                }else{
//                    item = GetValuesBase("<font(?:\\\".*?\\\"|\\'.*?\\'|[^\\'\\\"])*?>(.+?)</font>").getValues(td)
//                    item = GetValuesBase().removeNBSP(item)
//                    item = GetValuesBase().removePercent(item)
//                    
//                    switch rowCount {
//                    case 1:
//                        saveModel.unit = item
//                        print("unit= \(item)")
//                    case 2:
//                        saveModel.attendanceNumber = item
//                        print("attendanceNumber= \(item)")
//                    case 3:
//                        saveModel.absentNumber = item
//                        print("absentNumber= \(item)")
//                    case 4:
//                        saveModel.lateNumber = item
//                        print("lateNumber= \(item)")
//                    case 5:
//                        saveModel.publicAbsentNumber1 = item
//                        print("publicAbsentNumber1= \(item)")
//                    case 6:
//                        saveModel.publicAbsentNumber2 = item
//                        print("publicAbsentNumber2= \(item)")
//                    case 7:
//                        saveModel.attendanceRate = item
//                        print("attendanceRate= \(item)")
//                    case 8:
//                        saveModel.shortageNumber = item
//                        print("shortageNumber= \(item)")
//                    default:
//                        print("default")
//                    }
//                }
//                rowCount+=1
//            }
//            
//            //データを保存
//            try! realm.write {
//                realm.add(saveModel)
//            }
//            print(" \("")")
//            print("------------------- \("")")
//            print(" \("")")
//        }
    }
    

//    
//    func saveTimeTable(_ realm:Realm ,mLastResponseHtml:String, names:[String]){
//        var value:String = mLastResponseHtml.replacingOccurrences(of: "\r", with: "")
//        value = value.replacingOccurrences(of: "\n", with: "")
//        //時間割まわりを抽出
//        let narrowHtml: String = GetValuesBase("<div id=\"timetable_col\" class=\"col\">","<div class=\"col\">").narrowingValues(value)
//        
//        //行ごと 1時限,2時限,3時限,4時限
//        let rowResults:[String] = GetValuesBase("<th class=\"term\">.*?</tr>").getGroupValues(narrowHtml)
//        
//        var rowNum = 0//行カウント
//        var teacherIndex = 0
//        var ignoreFlg :Bool = true
//        for row:String in rowResults{
//            // 1列目はヘッダのため無視
//            if(ignoreFlg){
//                ignoreFlg = false
//                continue
//            }
//            //列ごと mon,tue,wed,thur,fri
//            let col: [String] =  GetValuesBase("<td>.*?</td>").getGroupValues(row)
//            var colNum = 0 //列カウント
//            for td:String in col{
//                let saveModel = TimeTableItem()
//                var subject:String = ""
//                var room:String = ""
//                
//                if GetValuesBase("<li>").ContainsCheck(td){ 
//                    subject = GetValuesBase("<li>(.+?)</li>").getValues(td)
//                    room = GetValuesBase("<td>\\s*<ul>\\s*<li>.*?</li>\\s*<li>(.+?)</li>").getValues(td)
//                    //teacherName = teacherNames[teacherIndex]
//                    
//                    saveModel.subjectName = subject
//                    saveModel.teacherName =   names[teacherIndex] //teacherNameは空文字
//                    saveModel.room = room
//                    saveModel.rowNum = rowNum
//                    saveModel.colNum = colNum
//                    teacherIndex += 1
//                    
//                }else{
//                    //空のとき
//                    saveModel.rowNum = rowNum
//                    saveModel.colNum = colNum
//                }
//                
////                log(subject: subject,room: room, teacherName: teacherName,rowNum: rowNum,colNum: colNum)
//                
//                //データを保存
//                try! realm.write {
//                    realm.add(saveModel)
//                }
//                colNum+=1
//            }
//            //行カウントをインクリメント
//            rowNum+=1
//        }
//    }
//    
//
//    
//    func saveSchoolNews(_ realm:Realm ,mLastResponseHtml:String){
//        var value:String = mLastResponseHtml.replacingOccurrences(of: "\r", with: "")
//        value = value.replacingOccurrences(of: "\n", with: "")
//        
//        let narrowHtml:String = GetValuesBase("<div id=\"school_news_col\"","<div id=\"shcool_event_col\"").narrowingValues(value)
//        let rows:[String] = GetValuesBase("(<li>|<h3>).*?(</li>|</h3>)").getGroupValues(narrowHtml)
//        
//        for row:String in rows{
//            let saveModel:SchoolNewsItem = SchoolNewsItem()
//            
//            if(GetValuesBase("<p class=\"date\">").ContainsCheck(row)){
//                saveModel.title = GetValuesBase("<p class=\"title\"><a href=\"[^\"]*\">(.+?)<").getValues(row)
//                saveModel.date = GetValuesBase("<p class=\"date\">(.+?)</p>").getValues(row)
////                saveModel.uri = GetValuesBase("<a href=\"(.+?)\">").getValues(row)
//            } else {
////                saveModel.groupTitle = GetValuesBase("<h3>(.+?)</h3>").getValues(row)
//            }
//            
//            //データを保存
//            try! realm.write {
//                realm.add(saveModel)
//            }
//        }
//    }
//    
    
    
//    func saveTaninNews(_ realm:Realm ,mLastResponseHtml:String){
//        var value:String = mLastResponseHtml.replacingOccurrences(of: "\r", with: "")
//        value = value.replacingOccurrences(of: "\n", with: "")
//        
//        let narrowHtml:String = GetValuesBase("<h2>担任からのお知らせ</h2>","</ul>").narrowingValues(value)
//        let rows:[String] = GetValuesBase("<li>.*?</li>").getGroupValues(narrowHtml)
//        
//        for row:String in rows{
//            let saveModel = TaninNewsItem()
//            saveModel.title = GetValuesBase("<span class=\"title\"><a href=\"[^\"]*\">(.+?)<").getValues(row)
//            saveModel.date = GetValuesBase("<span class=\"date\">(.+?)</span>").getValues(row)
//            saveModel.uri = GetValuesBase("<a href=\"(.+?)\">").getValues(row)
//            
//            //データを保存
//            try! realm.write {
//                realm.add(saveModel)
//            }
//        }
//    }
//    
//    
//    
//    private func saveNews(_ realm:Realm ,mLastResponseHtml:String){
//        saveTaninNews(realm,mLastResponseHtml:mLastResponseHtml)
//        saveSchoolNews(realm,mLastResponseHtml: mLastResponseHtml)
//    }
//    
    private func log(subject:String,room:String,teacherName:String,rowNum:String,colNum:String){
    //*********************************************
    print("******************************")
    print("subject = " + subject)
    print("room = " + room)
    print("teacherName = " + teacherName)
    print("rowNum = " + String(rowNum))
    print("colNum = " + String(colNum))
    print("")
    print("")
    //*********************************************
    }
}
