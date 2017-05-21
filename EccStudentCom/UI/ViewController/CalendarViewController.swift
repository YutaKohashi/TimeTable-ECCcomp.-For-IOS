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

class CalendarViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate, FSCalendarDelegateAppearance  {
    
    private let BUDGE_COLOR = UIColor(hue: 0.5139, saturation: 1, brightness: 0.7, alpha: 1.0)
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    var list = Array<Results<ScheduleContainsItem>?>()
    
    var items:Results<ScheduleContainsItem>?
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
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
        self.calendarView.clipsToBounds = true
        self.calendarView.appearance.headerDateFormat = DateFormatter.dateFormat(fromTemplate: "MMM", options: 0, locale: Locale(identifier: "ja"))
        self.calendarView.locale = Locale(identifier: "en")
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        //        self.calendarView.scope = .week
        
        // データベースからスケジュールを取得
        list = getSchedule();
        
        // tableviewに現在の月のスケジュールを反映
        let calendar = Calendar.current
        let month = calendar.component(.month, from: Date())
        items = list[getIndexFromMonth(month: month)]
        
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
        guard let l = items else {
            return 0
        }
        
        return l.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarItemCell") as! CalendarItemCell
        
        guard let l = items else {
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
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollingEnd()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollingEnd()
    }
    
    func scrollingEnd() {
        //enter code here
        print("scroll end")
//        guard let indexPaths:[IndexPath] = tableView.indexPathsForVisibleRows else {
//            return
//        }
        
        // TODO : ---------------------------
//        let indexPath:IndexPath = indexPaths[0]
//        
//        let date:Date = calendarView.currentPage
//        let calendar = Calendar(identifier: .gregorian)
//        let date2 = calendar.date(from: DateComponents(year: calendar.component(.year, from: date),
//                                                       month:  calendar.component(.month, from: date),
//                                                       day: indexPath.row + 1))
//        calendarView.select(date2, scrollToDate: true)
        // TODO : ---------------------------
    }
    
    
    
    
    // CalendarView  -------------------------------------------------------
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print(self.dateFormatter.string(from: calendar.currentPage))
        let date = calendar.currentPage
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        
        items = list[getIndexFromMonth(month: month)]
        tableView.reloadData()
        
        let day = Int(calendar.component(.day, from: date))
        let i = IndexPath(row: day - 1, section: 0)
        if items != nil && items!.count > day - 1 {
             tableView.scrollToRow(at: i, at: .top, animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    // calendarセルのセレクトイベント
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        do {
//            let calendar = Calendar.current
//            let day = Int(calendar.component(.day, from: date))
//            let i = IndexPath(row: day - 1, section: 0)
//            try tableView.scrollToRow(at: i, at: .top, animated: true)
//        }catch{
//            
//        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let key = self.dateFormatter.string(from: date)
        let item:ScheduleContainsItem? =  ScheduleAccessor.sharedInstance.getByID(id: key)
        
        guard item != nil else {
            return nil
        }
        
        guard item!.text.isEmpty else {
            return BUDGE_COLOR
        }
        
        return nil
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
    
    
    private func getSchedule() -> Array<Results<ScheduleContainsItem>?>{
        var list : Array<Results<ScheduleContainsItem>?> = Array<Results<ScheduleContainsItem>>()
        
        
        // ４月から３月の順にリストに格納する
        for i in 0 ..< 12 {
            let month:Int = getMonthFromIndex(index: i)
            var l:Results<ScheduleContainsItem>? = ScheduleAccessor.sharedInstance.getByMonth(month: month)
            if l == nil {
                
            }
            list.append(l)
            
        }
        return list
    }
    
    private func getMonthFromIndex(index:Int) -> Int {
        if (index >= 0 && index <= 8) {
            return index + 4
        } else {
            return index - 8
        }
    }
    
    private func getIndexFromMonth(month:Int) -> Int {
        if (month >= 4 && month <= 12) {
            return month - 4
        } else {
            return month + 8
        }
    }
}
