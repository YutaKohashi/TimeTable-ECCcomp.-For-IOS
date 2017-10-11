//
//  TimeTable.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/06.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import Himotoki

struct TimeTable:Himotoki.Decodable{
    // 時間割ID。時間割を識別する為の固有番号
    let id:Int
    // 曜日 1:月 2:火 3:水 4:木 5:金 6:土 0: 日
    let week:Int
     // 時限
    let term:Int
    // コード。年度単位で一意
    let lessonCode:String
    // 科目名
    let lessonName:String
    // 教室名
    let room:String
    // 科目コース
    let course:String
    // 先生（配列）
    let teachers:[TeacherTimeTable]
    
    init(id:Int, week:Int, term:Int, lessonCode:String, lessonName:String, room:String, course:String, teachers:[TeacherTimeTable] ) {
        self.id = id
        self.week = week
        self.term = term
        self.lessonCode = lessonCode
        self.lessonName = lessonName
        self.room = room
        self.course = course
        self.teachers = teachers
    }
    
    static func decode(_ e: Extractor) throws -> TimeTable {
        return try TimeTable(id: e<|"id",
                             week: e<|"week",
                             term: e<|"term",
                             lessonCode: e<|"lesson_code",
                             lessonName: e<|"lesson_name",
                             room: e<|"room",
                             course: e<|"course",
                             teachers: e<||"teachers"
        )
    }
}
