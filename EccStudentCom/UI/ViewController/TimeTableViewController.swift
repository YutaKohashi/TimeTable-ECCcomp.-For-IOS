//
//  TImeTableViewController.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/10/30.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class TimeTableViewController: UIViewController, TimeTableDelegate{
    var refreshFlg:Bool = false
    
    @IBOutlet weak var bottomSheetView: UIView!
    @IBOutlet weak var bottomCloseButton: UIButton!
    
    //Labels on BottomSheetView
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet var masterView: UIView!
    
    @IBOutlet weak var timeTable: TimeTableView1!

    // セルの幅に対するセルの高さの割合
    private var cellHeightProportion :CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ステータスバーのスタイル変更を促す
        Util.setStatusBarBackgroundColor(color: Util.getPrimaryColor())
        self.setNeedsStatusBarAppearanceUpdate();
        
        // 通知の許可を求める
        // 通知を使用可能にする設定
        requestPermision()
       
        bottomSheetView.isHidden = true
        bottomCloseButton.isHidden = true
        bottomCloseButton.isEnabled = false
        
        timeTable.delegate = self
        self.bottomSheetView.frame.origin.y -= 150
        
        // dummy　-----------------------------------------------------------------------

        let timeTables:Results<TimeTableItem> = TimeTableAccessor.sharedInstance.getAll()!
        timeTable.setData(timeTableItems: timeTables)

         timeTable.setType(isEnable0gen: false  , isEnable5gen: false, isEnableSun: false, isEnableSat: false)
         // dummy　-----------------------------------------------------------------------
    }
    
    
    // timeTableViewのセルをタップしたときのイベント
    func onCellTap(timeTableItem: TimeTableItem) {
//        print(timeTable.id)
        BottomSheetViewBuilder().setContainer(view: timeTable).build().show()
        subjectLabel.text = timeTableItem.subjectName
        teacherLabel.text = timeTableItem.teacherName
        timeLabel.text = getTime(index: timeTableItem.rowNum)
//        setBottomSheet()
        setBottomSheet()
    }
    
    
    // MARK:　ステータスバー
    // ステータスバー ------------------------------------------------------------------------
    override var prefersStatusBarHidden : Bool {
        // trueの場合はステータスバー非表示
        return false;
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        // ステータスバーを白くする
        return UIStatusBarStyle.lightContent;
    }
    

    
    // ボトムシート ------------------------------------------------------------------------
    @IBAction func colseButtonTouch(_ sender: UIButton) {
        bottomSheetView.isHidden = true
        bottomCloseButton.isHidden = true
        bottomCloseButton.isEnabled = true
         fadeOutAnimation()
        subjectLabel.text = ""
        teacherLabel.text = ""
        timeLabel.text = ""
    }
//    //closeButton
//    @IBAction func bottomCloseButton(_ sender: AnyObject) {
//        
////        bottomCloseButton.isEnabled = false
//        bottomCloseButton.isHidden = true
////        fadeOutAnimation()
////        closeAnimation()
//        subjectLabel.text = ""
//        teacherLabel.text = ""
//        timeLabel.text = ""
//        
////    }
//    
//    func setBottomSheet(){
//        bottomSheetView.isHidden = false
//        bottomCloseButton.isHidden = false
//        bottomCloseButton.isEnabled = true
//        openAnimation()
//        fadeInAnimation()
//    }
    
    private func getTime(index:Int) -> String{
        switch index {
            case 0:
                return "07:30 ~ 09:00"
            case 1:
                return "09:15 ~ 10:45"
            case 2:
                return "11:00 ~ 12:30"
            case 3:
                return "13:30 ~ 15:00"
            case 4:
                return "15:15 ~ 16:45"
            case 5:
                return "17:00 ~ 18:30"
            default:
                return ""
        }
    }
    
    // アニメーション ------------------------------------------------------------------------
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
    
 
    // ------------------------------------------------------------------------
    
    private func requestPermision(){
        if #available(iOS 10.0, *) {
            // iOS 10
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
                if error != nil {
                    return
                }
                
                if granted {
                    // 通知許可
                } else {
                    // 通知拒否
                    // 通知の許可を求める趣旨のダイアログを出す
                    
                    
                }
            })
            
        } else {
            // iOS 9
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
}
