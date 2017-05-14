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

class TimeTableViewController: UIViewController, TimeTableDelegate{
    var refreshFlg:Bool = false
    
    // 時間割CollectionView
//    @IBOutlet weak var timeTableCollectionView: UICollectionView!
    
    @IBOutlet weak var bottomSheetView: UIView!
    @IBOutlet weak var bottomCloseButton: UIButton!
    
    //Labels on BottomSheetView
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet var masterView: UIView!
    
    @IBOutlet weak var timeTable: TimeTableView1!
    
    //　アイテムマージンを0にしてセルマージンを2.0にする
//    private let cellMargin : CGFloat = 0.0
//    private var itemCount:Int = 0
//    private var colCount:Int = 5
    
    // セルの幅に対するセルの高さの割合
    private var cellHeightProportion :CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StatusBarManager().setStatusBarBackgroundColor(color: UIColor(red:0.00, green:0.29, blue:0.39, alpha:1.0))
        // ステータスバーのスタイル変更を促す
        self.setNeedsStatusBarAppearanceUpdate();

        bottomSheetView.isHidden = true
        bottomCloseButton.isHidden = true
        bottomCloseButton.isEnabled = false
        
        timeTable.delegate = self
        
        
        // dummy　-----------------------------------------------------------------------

        let timeTables:Results<TimeTableItem> = TimeTableAccessor.sharedInstance.getAll()!
        timeTable.setData(timeTableItems: timeTables)

         timeTable.setType(isEnable0gen: false, isEnable5gen: false, isEnableSun: false, isEnableSat: false)
         // dummy　-----------------------------------------------------------------------
    }
    
    
    // timeTableViewのセルをタップしたときのイベント
    func onCellTap(timeTable: TimeTable) {
        print(timeTable.id)
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
    func setBottomSheet(){
        bottomSheetView.isHidden = false
        bottomCloseButton.isHidden = false
        bottomCloseButton.isEnabled = true
//        openAnimation()
        fadeInAnimation()
    }
    
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
    
    private let ANIM_SPEED = 0.3
    
    private func openAnimation(){
        UIView.animate(withDuration: ANIM_SPEED, animations: {
            self.bottomSheetView.frame.origin.y = 150
            self.bottomCloseButton.isEnabled = true
        })
    }
    
    private func closeAnimation(){
        UIView.transition(with: bottomSheetView,
                          duration: 0.1,
                          options: .transitionCrossDissolve,
                          animations: {() -> Void in
                            self.bottomSheetView.isHidden = true
        }, completion: { _ in })
    }
    
    private  func fadeInAnimation(){
        UIView.animate(withDuration: ANIM_SPEED) { () -> Void in
            self.bottomCloseButton.alpha = 1.0
        }
    }
    private func fadeOutAnimation(){
        UIView.animate(withDuration: ANIM_SPEED) { () -> Void in
            self.bottomCloseButton.alpha = 0.0
        }
    }
    
}
