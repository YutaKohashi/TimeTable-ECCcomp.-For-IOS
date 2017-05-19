//
//  CalendarViewController.swift
//  EccStudentCom
//
//  Created by 小橋勇太 on 2017/03/20.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import UIKit
import FSCalendar
import RealmSwift

class CalendarViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    var dummyList = Array<ScheduleContainsItem>()
    var list = Array<Results<ScheduleContainsItem>?>()
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendarView, action: #selector(self.calendarView.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ステータスバー
        Util.setStatusBarBackgroundColor(color: Util.getPrimaryColor())
        self.setNeedsStatusBarAppearanceUpdate();
        
        
        // 本日を選択
        self.calendarView.select(Date())
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
//        self.calendarView.scope = .week
        
        // dummy --------------------------------
        for i in 0..<100 {
            let item = ScheduleContainsItem()
            item.text = "テキスト"
            item.day = i
            
            dummyList.append(item)
        }
        
        list = getSchedule();
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK:- UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendarView.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
    
    // TableView  -------------------------------------------------------
    
    
    // セルの個数を指定するデリゲートメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let l = list[0] else {
            return 0
        }
        
        return l.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarItemCell") as! CalendarItemCell
        
        
        guard let l = list[0] else {
            return cell
        }
        
        let day:String = String(l[indexPath.row].day) + "日"
        let text:String = l[indexPath.row].text
        
      
        
        cell.setCell(body: text, date: day)
        
        return cell
        
    }
    
    // MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let scope: FSCalendarScope = (indexPath.row == 0) ? .month : .week
            self.calendarView.setScope(scope, animated: true)
        }
    }
    
    
     // CalendarView  -------------------------------------------------------
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    // calendarセルのセレクトイベント
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        print("did select date \(self.dateFormatter.string(from: date))")
//        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
//        print("selected dates is \(selectedDates)")
//        if monthPosition == .next || monthPosition == .previous {
//            calendar.setCurrentPage(date, animated: true)
//        }
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: DateComponents(year: 2017, month: 4, day: 1))
        return date!
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: DateComponents(year: 2018, month: 3, day: 31))
        return date!
    }
    
    
    //  private  ------------------------------------------------------------------------
    
    
    func getSchedule() -> Array<Results<ScheduleContainsItem>?>{
        var list : Array<Results<ScheduleContainsItem>?> = Array<Results<ScheduleContainsItem>>()
        
        
        // ４月から３月の順にリストに格納する
        for i in 0 ..< 12 {
            let month:Int = getMonth(month: i)
            let l:Results<ScheduleContainsItem>? = ScheduleAccessor.sharedInstance.getByMonth(month: month)!
            list.append(l)

        }
        return list
    }
    
    private func getMonth(month:Int) -> Int {
        if (month >= 0 && month <= 8) {
            return month + 4
        } else {
            return month - 8
        }
    }
}
