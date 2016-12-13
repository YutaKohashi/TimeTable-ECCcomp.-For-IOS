//
//  TImeTableViewController.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/10/30.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import UIKit
import RealmSwift
import KRProgressHUD

class TimeTableViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{
    
    var refreshFlg:Bool = false
    
    @IBOutlet weak var mondayTableView: UITableView!
    @IBOutlet weak var tuesdayTableView: UITableView!
    @IBOutlet weak var wednesdayTableView: UITableView!
    @IBOutlet weak var thursdayTableView: UITableView!
    @IBOutlet weak var fridayTableView: UITableView!
    
    @IBOutlet weak var bottomSheetView: UIView!
    @IBOutlet weak var bottomCloseButton: UIButton!
    
    //Labels in BottomSheetView
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet var masterView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StatusBarManager().setStatusBarBackgroundColor(color: UIColor(red:0.00, green:0.29, blue:0.39, alpha:1.0))
        // ステータスバーのスタイル変更を促す
        self.setNeedsStatusBarAppearanceUpdate();
        
        initTableView()
        bottomSheetView.isHidden = true
        bottomCloseButton.isHidden = true
        bottomCloseButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //TODO
        if(refreshFlg){
            mondayTableView.reloadData()
            tuesdayTableView.reloadData()
            wednesdayTableView.reloadData()
            thursdayTableView.reloadData()
            fridayTableView.reloadData()
            refreshFlg = false
        }
        
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //closeButton
    @IBAction func bottomCloseButton(_ sender: AnyObject) {
        
        bottomCloseButton.isEnabled = false
        
        fadeOutAnimation()
        closeAnimation()
        subjectLabel.text = ""
        teacherLabel.text = ""
        timeLabel.text = ""
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch tableView.tag {
        case 0:
            let cell = tableView.cellForRow(at: indexPath)as! CustomTimeTableViewCellMon
            if cell.getSubjectName().text == "" || cell.getSubjectName().text == nil{return}
            
            setBottomSheet()
            
            subjectLabel.text = cell.getSubjectName().text
            teacherLabel.text = cell.getTeacherName().text
            timeLabel.text = getTime(index: (indexPath as NSIndexPath).row)
            break
        case 1:
            let cell = tableView.cellForRow(at: indexPath)as! CustomTimeTableViewCellTue
            if cell.getSubjectName().text == "" || cell.getSubjectName().text == nil {return}
            
             setBottomSheet()
            
            subjectLabel.text = cell.getSubjectName().text
            teacherLabel.text = cell.getTeacherName().text
            timeLabel.text = getTime(index: (indexPath as NSIndexPath).row)
            break
        case 2:
            let cell = tableView.cellForRow(at: indexPath)as! CustomTimeTableViewCellWed
            if cell.getSubjectName().text == "" || cell.getSubjectName().text == nil {return}
            
             setBottomSheet()
            
            subjectLabel.text = cell.getSubjectName().text
            teacherLabel.text = cell.getTeacherName().text
            timeLabel.text = getTime(index: (indexPath as NSIndexPath).row)
            break
        case 3:
            let cell = tableView.cellForRow(at: indexPath)as! CustomTimeTableViewCellThur
            if cell.getSubjectName().text == "" || cell.getSubjectName().text == nil {return}
            
            setBottomSheet()
            
            subjectLabel.text = cell.getSubjectName().text
            teacherLabel.text = cell.getTeacherName().text
            timeLabel.text = getTime(index: (indexPath as NSIndexPath).row)
            break
        case 4:
            let cell = tableView.cellForRow(at: indexPath)as! CustomTimeTableViewCellFri
            if cell.getSubjectName().text == "" || cell.getSubjectName().text == nil {return}
            
            setBottomSheet()
            subjectLabel.text = cell.getSubjectName().text
            teacherLabel.text = cell.getTeacherName().text
            timeLabel.text = getTime(index: (indexPath as NSIndexPath).row)
            break
        default:
            break
        }
    }
    
    func setBottomSheet(){
        bottomSheetView.isHidden = false
        bottomCloseButton.isHidden = false
        openAnimation()
        fadeInAnimation()
    }
    
    private let ANIM_SPEED = 0.3
    
    func openAnimation(){
        UIView.animate(withDuration: ANIM_SPEED, animations: {
            self.bottomSheetView.frame.origin.y = 150
            self.bottomCloseButton.isEnabled = true
        })
    }
    
    func closeAnimation(){
        UIView.transition(with: bottomSheetView,
                          duration: 0.1,
                          options: .transitionCrossDissolve,
                          animations: {() -> Void in
            self.bottomSheetView.isHidden = true
            }, completion: { _ in })
    }
    
    func fadeInAnimation(){
        UIView.animate(withDuration: ANIM_SPEED) { () -> Void in
            self.bottomCloseButton.alpha = 1.0
        }
    }
    func fadeOutAnimation(){
        UIView.animate(withDuration: ANIM_SPEED) { () -> Void in
            self.bottomCloseButton.alpha = 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var subjectName:String = ""
        var roomNumber:String = ""
        var teacherName:String = ""
        switch tableView.tag {
            
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MonCustomCell") as! CustomTimeTableViewCellMon
            
            let realm = try! Realm()
            let saveModel = realm.objects(TimeTableSaveModel.self)
            subjectName = saveModel[(indexPath as NSIndexPath).row * 5].subjectName
            roomNumber = saveModel[(indexPath as NSIndexPath).row * 5].room
            teacherName = saveModel[(indexPath as NSIndexPath).row * 5].teacherName
            // セルに値を設定
            cell.setCell(subjectName,roomN:roomNumber,name: teacherName)
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TueCustomCell") as! CustomTimeTableViewCellTue
            let realm = try! Realm()
            let saveModel = realm.objects(TimeTableSaveModel.self)
            
            subjectName = saveModel[(indexPath as NSIndexPath).row * 5 + 1].subjectName
            roomNumber = saveModel[(indexPath as NSIndexPath).row * 5 + 1].room
            teacherName = saveModel[(indexPath as NSIndexPath).row * 5 + 1].teacherName
            // セルに値を設定
            cell.setCell(subjectName,roomN:roomNumber,name: teacherName)
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WedCustomCell") as! CustomTimeTableViewCellWed
            let realm = try! Realm()
            let saveModel = realm.objects(TimeTableSaveModel.self)
            subjectName = saveModel[(indexPath as NSIndexPath).row * 5 + 2].subjectName
            roomNumber = saveModel[(indexPath as NSIndexPath).row * 5 + 2].room
            teacherName = saveModel[(indexPath as NSIndexPath).row * 5 + 2].teacherName
            // セルに値を設定
            cell.setCell(subjectName,roomN:roomNumber,name: teacherName)
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThurCustomCell") as! CustomTimeTableViewCellThur
            let realm = try! Realm()
            let saveModel = realm.objects(TimeTableSaveModel.self)
            subjectName = saveModel[(indexPath as NSIndexPath).row * 5 + 3].subjectName
            roomNumber = saveModel[(indexPath as NSIndexPath).row  * 5 + 3].room
            teacherName = saveModel[(indexPath as NSIndexPath).row  * 5 + 3].teacherName
            // セルに値を設定
            cell.setCell(subjectName,roomN:roomNumber,name: teacherName)
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriCustomCell") as! CustomTimeTableViewCellFri
            let realm = try! Realm()
            let saveModel = realm.objects(TimeTableSaveModel.self)
            subjectName = saveModel[(indexPath as NSIndexPath).row * 5 + 4].subjectName
            roomNumber = saveModel[(indexPath as NSIndexPath).row * 5 + 4].room
            teacherName = saveModel[(indexPath as NSIndexPath).row * 5 + 4].teacherName
            // セルに値を設定
            cell.setCell(subjectName,roomN:roomNumber,name: teacherName)
            
            return cell
            
        default:
            break
        }
        
        //ここは通らない
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonCustomCell") as! CustomTimeTableViewCellMon
        return cell
    }
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override var prefersStatusBarHidden : Bool {
        // trueの場合はステータスバー非表示
        return false;
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        // ステータスバーを白くする
        return UIStatusBarStyle.lightContent;
    }
    
    // TableViewを初期化
    func initTableView(){
        //各tableViewのスクロールを無効化
        mondayTableView.isScrollEnabled = false
        tuesdayTableView.isScrollEnabled = false
        wednesdayTableView.isScrollEnabled = false
        thursdayTableView.isScrollEnabled = false
        fridayTableView.isScrollEnabled = false
        
        mondayTableView.dataSource = self
        tuesdayTableView.dataSource = self
        wednesdayTableView.dataSource = self
        thursdayTableView.dataSource = self
        fridayTableView.dataSource = self
        
        //タップ時にセルの位置を取得するのに必要
        mondayTableView.delegate = self
        tuesdayTableView.delegate = self
        wednesdayTableView.delegate = self
        thursdayTableView.delegate = self
        fridayTableView.delegate = self
    }
    
    func getTime(index:Int) -> String{
        switch index {
        case 0:
            return "09:15 ~ 10:45"
        case 1:
            return "11:00 ~ 12:30"
        case 2:
            return "13:30 ~ 15:00"
        case 3:
            return "15:15 ~ 16:45"
        case 3:
            return "17:00 ~ 18:30"
        default:
            return ""
        }
    }
}
