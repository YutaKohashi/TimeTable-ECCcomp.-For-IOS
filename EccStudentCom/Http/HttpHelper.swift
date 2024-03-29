//
//  HttpHelper.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/11/09.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import Foundation
import RealmSwift

internal class HttpHelper:HttpBase{
    
    let URL = RequestURL()
    let BODY = RequestBody()
    
    /******************************************  public  ***********************************************************/
    
    // MARK:時間割を取得
    internal func getTimeTable(userId :String,password:String,callback: @escaping (Bool) -> Void) -> Void {
        EscApiManager.timeTableRequest(userId:userId,password: password) { (callback1) in
            if(callback1.bool){
                DispatchQueue.main.async {
                    TimeTableAccessor.sharedInstance.deleteAll()
                    let timeTableItems :[TimeTableItem] = self.rootTimeTableToTimeTableItemCollection(rootTimeTable: callback1.response)
                    for item in timeTableItems {
                        let result:Bool =  TimeTableAccessor.sharedInstance.set(data: item)
                        if(!result) {
                            callback(false)
                            return
                        }
                    }
                    callback(true)
                }
            }else {
                callback(false)
            }
        }
    }
    
    // MARK:出席照会リスト
    func getAttendanceRate(userId :String,password:String,callback: @escaping (Bool) -> Void) -> Void {
        self.reequestAttendanseRate(userId: userId, password: password) { (requestResult) in
            // "Realm accessed from incorrect thread."対策
            if(requestResult.bool){
                DispatchQueue.main.async {
                    AttedanceRateAccessor.sharedInstance.deleteAll()
                    let items:[AttendanceRateItem] = self.attendanceResponseToAttendanceRateItemCollection(html: requestResult.string)
                    for item in items {
                        guard AttedanceRateAccessor.sharedInstance.set(data: item) else {
                            callback(false)
                            return
                        }
                    }
                    
                    callback(true)
                }
            } else {
                callback(false)
            }
            
        }
    }
    
    // MARK:時間割と出席照会を取得し保存するメソッド
    func getTimeTableAttendanceRate(userId :String,password:String,callback: @escaping (Bool) -> Void) -> Void {
        getTimeTable(userId: userId, password: password) { (cb1) in
            if(cb1){
                self.getAttendanceRate(userId: userId, password: password, callback:
                    { (cb2) in
                        callback(cb2)
                })
            }else{callback(cb1)}
        }
    }
    
    
    // MARK:学校からのお知らせ
    func getSchoolNews(userId:String, password:String, callback:@escaping(Bool) -> Void) -> Void{
        EscApiManager.schoolNewsRequest(userId: userId, password: password) { (callback1) in
            if callback1.bool {
                // 学校からのお知らせを保存
                DispatchQueue.main.async {
                    SchoolNewsAccessor.sharedInstance.deleteAll()
                    let items:[SchoolNewsItem] = self.responceToSchoolNewsItems(newsArray: callback1.response!)
                    for item in items {
                        guard SchoolNewsAccessor.sharedInstance.set(data: item) else {
                            callback(false)
                            return
                        }
                    }
                    callback(true)
                }
                
            } else {
                callback(false)
            }
        }
    }
    
    // MARK:担任からのお知らせ
    func getTaninNews(userId:String,password:String,callback:@escaping(Bool) -> Void) -> Void{
        EscApiManager.taninNewsRequest (userId: userId, password: password){ (callback1) in
            if callback1.bool {
                // 担任からのお知らせを保存
                DispatchQueue.main.async {
                    TaninNewsAccessor.sharedInstance.deleteAll()
                    let items:[TaninNewsItem] = self.responceToTaninNewsItems(newsArray: callback1.response!)
                    for item in items {
                        guard TaninNewsAccessor.sharedInstance.set(data: item) else {
                            callback(false)
                            return
                        }
                    }
                    callback(true)
                }
            } else {
                callback(false)
            }
        }
        
        
    }
    
    // MARK:学校、担任からのお知らせ
    func getSchoolTaninNews(userId:String,password:String, callback:@escaping(Bool) -> Void) -> Void {
        getSchoolNews(userId: userId, password: password) { (cb1) in
            if(cb1){
                self.getTaninNews(userId: userId, password: password, callback: { (cb2) in
                    callback(cb2)
                })
            }else{
                callback(cb1)
            }
        }
    }
    
    // MARK:お知らせ詳細
    func getNewsDetail(userId:String, password:String, newsId:Int,callback:@escaping(EscApiCallback<NewsDetailRoot>) -> Void) -> Void {
        EscApiManager.newsDetailRequest(userId:userId, password:password ,newsId: newsId) { (callback1) in
            if callback1.bool {
                callback(EscApiCallback<NewsDetailRoot>(response: callback1.response!, bool: true))
            } else {
                callback(EscApiCallback<NewsDetailRoot>(bool: false))
            }
        }
    }
    
    
    // MARK:スケジュール
    func getSchedule(userId:String, password:String, callback:@escaping(Bool) -> Void) -> Void{

        EscApiManager.scheduleRequestAll(userId: userId, password: password) { (callback1 ) in
            if callback1.bool {
                // 保存処理
                DispatchQueue.main.async {
                    ScheduleAccessor.sharedInstance.deleteAll()
                    let scheduleRootList:[ScheduleRoot] = callback1.response!
                    scheduleRootList.forEach({ (scheduleRoot) in
                        guard let items:[ScheduleContainsItem] = self.scheduleRootToScheduleContainsItemList(scheduleRoot: scheduleRoot) else {
                            callback(false)
                            return
                        }
                        
                        for item in items {
                            guard ScheduleAccessor.sharedInstance.set(data: item) else {
                                callback(false)
                                return
                            }
                        }
                        
                    })
                    callback(true)
                }
                
                
            } else {
                callback(false)
            }
        }
    }
    
    
    
    /******************************************  private  ***********************************************************/
    
    // MARK:出席率を取得
    private func reequestAttendanseRate(userId :String,password:String,callback: @escaping (CallBackClass) -> Void) -> Void {
        httpGet(url: URL.YS_TO_PAGE,
                requestBody:"" ,
                referer: URL.DEFAULT_REFERER,
                header: true)
        { (cb1) in
            if(cb1.bool){
                self.httpPost(url: self.URL.YS_LOGIN,
                              requestBody: self.BODY.createPostDataForYSLogin(userId:userId,
                                                                              password:password,
                                                                              mLastResponseHtml: cb1.string),
                              referer: self.URL.YS_TO_PAGE,
                              header: true)
                { (cb2) in
                    if(cb2.bool){
                        self.httpPost(url: self.URL.YS_TO_RATE_PAGE,
                                      requestBody: self.BODY.createPostDataForRatePage(mLastResponseHtml: cb2.string),
                                      referer: self.URL.YS_LOGIN,
                                      header: false)
                        { (cb3) in
                            //正常に遷移できているか確認
                            if !GetValuesBase("教科名").ContainsCheck(cb3.string){
                                cb3.bool = false
                                callback(cb3)
                                print(cb3.string)
                                return;
                            }
                            callback(cb3)
                        }
                    }else{callback(cb2)} //false
                }
            }else{callback(cb1)} //false
        }
    }
    
    
    // RootTimeTableからTimeTableItemコレクションを生成する
    private func rootTimeTableToTimeTableItemCollection(rootTimeTable:RootTimeTable!) -> [TimeTableItem]{
        var timeTableItems:[TimeTableItem] = []
        
        // 42 = 6 × 7 (0〜５限、　日〜土)
        for i in 0..<42 {
            let row = i / 7
            let col = i % 7
            
            ////            let item:TimeTableItem = TimeTableItem()
            let timeTable:TimeTable? = getTimeTable(col: col, row: row, timeTables: rootTimeTable.timeTables)
            //
            let timeTableItem:TimeTableItem = TimeTableItem()
            timeTableItem.colNum = col
            timeTableItem.rowNum = row
            timeTableItem.id = i
            
            if(timeTable == nil){
                
            } else {
                timeTableItem.room = timeTable!.room
                timeTableItem.roomOrigin = timeTable!.room
                timeTableItem.subjectName = timeTable!.lessonName
                timeTableItem.subjectNameOrigin = timeTable!.lessonName
                
                // TODO:先生名を作成するメソッドを作成
                let name = createTeacherName(list: timeTable!.teachers)
                timeTableItem.teacherName = name
                timeTableItem.teacherNameOrigin = name
                
                timeTableItem.id = i
            }
            timeTableItems.append(timeTableItem)
        }
        
        return timeTableItems
    }
    
    private func getTimeTable(col:Int, row:Int,timeTables:[TimeTable]) -> TimeTable?{
        for timeTable in timeTables {
            if(timeTable.term == row && timeTable.week == col){
                return timeTable
            }
        }
        return nil
    }
    
    private func createTeacherName(list:[TeacherTimeTable]?) -> String {
        var name:String = ""
        
        guard list != nil && list!.count > 0 else {
            return name
        }
        
        list!.forEach { (teacherTimeTable) in
            name += teacherTimeTable.familyName + " " + teacherTimeTable.firstName + " , "
        }
        if name.characters.count > 1 {
            return String(name.characters.dropLast(1))
        } else {
            return name
        }
    }
    
    
    
    
    private func attendanceResponseToAttendanceRateItemCollection(html:String) -> [AttendanceRateItem]{
        var items:[AttendanceRateItem] = []
        var id:Int = 0
        
        var value:String = html.replacingOccurrences(of: "\r", with: "")
        value = value.replacingOccurrences(of: "\n", with: "")
        
        
        //合計データを保存
        var narrowHtml :String = GetValuesBase(">合計<","</tr>").narrowingValues(value)
        narrowHtml = GetValuesBase().removeNBSP(narrowHtml)
        narrowHtml = GetValuesBase().removePercent(narrowHtml)
        let saveModel = AttendanceRateItem()
        saveModel.id = id
        id+=1
        saveModel.subjectName = "合計"
        saveModel.unit = GetValuesBase("id=\"ctl00_ContentPlaceHolder1_fmvSyuseki_lblTotalTani\">(.+?)<").getValues(narrowHtml)
        saveModel.attendanceNumber = GetValuesBase("id=\"ctl00_ContentPlaceHolder1_fmvSyuseki_lblTotalShuseki\">(.+?)<").getValues(narrowHtml)
        saveModel.absentNumber = GetValuesBase("id=\"ctl00_ContentPlaceHolder1_fmvSyuseki_lblTotalKesski\">(.+?)<").getValues(narrowHtml)
        saveModel.lateNumber = GetValuesBase("id=\"ctl00_ContentPlaceHolder1_fmvSyuseki_lblTotalChikoku\">(.+?)<").getValues(narrowHtml)
        saveModel.publicAbsentNumber1 = GetValuesBase("id=\"ctl00_ContentPlaceHolder1_fmvSyuseki_lblTotalKouketsu1\">(.+?)<").getValues(narrowHtml)
        saveModel.publicAbsentNumber2 = GetValuesBase(" id=\"ctl00_ContentPlaceHolder1_fmvSyuseki_lblTotalKouketsu2\">(.+?)<").getValues(narrowHtml)
        saveModel.attendanceRate = GetValuesBase("id=\"ctl00_ContentPlaceHolder1_fmvSyuseki_lblTotalShutsuritsu\">(.+?)<").getValues(narrowHtml)
        saveModel.shortageNumber = GetValuesBase("id=\"ctl00_ContentPlaceHolder1_fmvSyuseki_lblTotalFusoku\">(.+?)<").getValues(narrowHtml)
        
        items.append(saveModel)
        
        
        narrowHtml = GetValuesBase("<table class=\"GridVeiwTable\"","</table>").narrowingValues(value)
        //教科ごと
        let results: [String] =  GetValuesBase("<tr>.*?</tr>").getGroupValues(narrowHtml)
        
        var item:String! = ""
        var rowCount = 0
        var firstRowFlg: Bool = true
        
        for row:String in results{
            let col: [String] =  GetValuesBase("<td.*?</td>").getGroupValues(row)
            
            let saveModel = AttendanceRateItem()
            saveModel.id = id
            id+=1
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
                    item = GetValuesBase().removeNBSP(item)
                    item = GetValuesBase().removePercent(item)
                    
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
                        // E休
                        break
                    case 8:
                        saveModel.attendanceRate = item
                        print("attendanceRate= \(item)")
                    case 9:
                        saveModel.shortageNumber = item
                        print("shortageNumber= \(item)")
                    default:
                        print("default")
                    }
                }
                rowCount+=1
            }
            
            //            //データを保存
            //            try! realm.write {
            //                realm.add(saveModel)
            //            }
            items.append(saveModel)
            print(" \("")")
            print("------------------- \("")")
            print(" \("")")
        }
        
        return items
    }
    
    private func responceToSchoolNewsItems(newsArray:NewsArray) -> [SchoolNewsItem]{
        var items:[SchoolNewsItem] = []
        
        let array:[NewsItem] = newsArray.newsArray
        
        array.forEach { (newsItem) in
            let item:SchoolNewsItem = SchoolNewsItem()
            item.newsId = newsItem.id
            item.title = newsItem.title
            item.from = newsItem.category
            item.date = newsItem.updatedDate
            
            items.append(item)
        }
        
        return items
    }
    
    private func responceToTaninNewsItems(newsArray:NewsArray) -> [TaninNewsItem]{
        var items:[TaninNewsItem] = []
        
        let array:[NewsItem] = newsArray.newsArray
        
        array.forEach { (newsItem) in
            let item:TaninNewsItem = TaninNewsItem()
            item.newsId = newsItem.id
            item.title = newsItem.title
            item.from = newsItem.category
            item.date = newsItem.updatedDate
            
            items.append(item)
        }
        
        return items
    }
    
    private func scheduleRootToScheduleContainsItemList(scheduleRoot:ScheduleRoot?) -> [ScheduleContainsItem]? {
        let categories:[ScheduleCategory]? = scheduleRoot?.schedules
        guard (categories != nil) && categories!.count != 0 else {
            return nil
        }
        
        var items:[ScheduleContainsItem] = []
        for scheduleItem:ScheduleItem in categories![0].details {
            let scheduleContainsItem = ScheduleContainsItem()
            scheduleContainsItem.year = scheduleItem.year
            scheduleContainsItem.month = scheduleItem.month
            scheduleContainsItem.day = scheduleItem.day
            scheduleContainsItem.text = scheduleItem.body
            scheduleContainsItem.originalTxt = scheduleItem.body
            scheduleContainsItem.yearMonthDay = scheduleItem.date
            
            items.append(scheduleContainsItem)
        }
        
        return items
    }
}
