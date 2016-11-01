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
    
    @IBOutlet weak var mondayTableView: UITableView!
    @IBOutlet weak var tuesdayTableView: UITableView!
    @IBOutlet weak var wednesdayTableView: UITableView!
    @IBOutlet weak var thursdayTableView: UITableView!
    @IBOutlet weak var fridayTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StatusBarManager().setStatusBarBackgroundColor(color: UIColor(red:0.00, green:0.29, blue:0.39, alpha:1.0))
        // ステータスバーのスタイル変更を促す
        self.setNeedsStatusBarAppearanceUpdate();
        
        //各tableViewのスクロールを無効化
        mondayTableView.isScrollEnabled = false
        tuesdayTableView.isScrollEnabled = false
        wednesdayTableView.isScrollEnabled = false
        thursdayTableView.isScrollEnabled = false
        fridayTableView.isScrollEnabled = false
        //区切り線をなくす
//        mondayTableView.separatorColor = UIColor.lightGray
//        tuesdayTableView.separatorColor = UIColor.lightGray
//        wednesdayTableView.separatorColor = UIColor.lightGray
//        thursdayTableView.separatorColor = UIColor.lightGray
//        fridayTableView.separatorColor = UIColor.lightGray
        //選択不可に
        mondayTableView.allowsSelection = false
        tuesdayTableView.allowsSelection = false
        wednesdayTableView.allowsSelection = false
        thursdayTableView.allowsSelection = false
        fridayTableView.allowsSelection = false

        
//        mondayTableView.rowHeight = UITableViewAutomaticDimension
//        tuesdayTableView.rowHeight = UITableViewAutomaticDimension
//        wednesdayTableView.rowHeight = UITableViewAutomaticDimension
//        thursdayTableView.rowHeight = UITableViewAutomaticDimension
//        fridayTableView.rowHeight = UITableViewAutomaticDimension
        
        mondayTableView.dataSource = self
        tuesdayTableView.dataSource = self
        wednesdayTableView.dataSource = self
        thursdayTableView.dataSource = self
        fridayTableView.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得
//        if(tableView.tag == 0 ){
//      
//        }
        switch tableView.tag {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MonCustomCell") as! CustomTimeTableViewCellMon
          
            let realm = try! Realm()
            let saveModel = realm.objects(TimeTableSaveModel.self)
            // セルに値を設定
            cell.setCell(saveModel[(indexPath as NSIndexPath).row * 5].subjectName,roomN:saveModel[(indexPath as NSIndexPath).row * 5].room)
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TueCustomCell") as! CustomTimeTableViewCellTue
            let realm = try! Realm()
            let saveModel = realm.objects(TimeTableSaveModel.self)
            // セルに値を設定
            cell.setCell(saveModel[(indexPath as NSIndexPath).row * 5 + 1].subjectName,roomN:saveModel[(indexPath as NSIndexPath).row * 5 + 1].room)
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WedCustomCell") as! CustomTimeTableViewCellWed
            let realm = try! Realm()
            let saveModel = realm.objects(TimeTableSaveModel.self)
            // セルに値を設定
            cell.setCell(saveModel[(indexPath as NSIndexPath).row * 5 + 2].subjectName,roomN:saveModel[(indexPath as NSIndexPath).row * 5 + 2].room)
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThurCustomCell") as! CustomTimeTableViewCellThur
            let realm = try! Realm()
            let saveModel = realm.objects(TimeTableSaveModel.self)
            // セルに値を設定
            cell.setCell(saveModel[(indexPath as NSIndexPath).row * 5 + 3].subjectName,roomN:saveModel[(indexPath as NSIndexPath).row  * 5 + 3].room)
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriCustomCell") as! CustomTimeTableViewCellFri
            let realm = try! Realm()
            let saveModel = realm.objects(TimeTableSaveModel.self)
            // セルに値を設定
            cell.setCell(saveModel[(indexPath as NSIndexPath).row * 5 + 4].subjectName,roomN:saveModel[(indexPath as NSIndexPath).row * 5 + 4].room)
            return cell
        
        default:
            break

        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonCustomCell") as! CustomTimeTableViewCellMon
        let realm = try! Realm()
        let saveModel = realm.objects(TimeTableSaveModel.self)
        // セルに値を設定
        cell.setCell(saveModel[(indexPath as NSIndexPath).row].subjectName,roomN:saveModel[(indexPath as NSIndexPath).row].room)
        return cell
        
    }
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let realm = try! Realm()
//        print("realm.objects(SaveModel).count =\(realm.objects(SaveModel).count)")
//        return realm.objects(SaveModel).count
        return 4
        //        return array.count
    }
//    /// セルの個数を指定するデリゲートメソッド（必須）
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 4
//    }
//    
//    /// セルに値を設定するデータソースメソッド（必須）
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        // セルを取得
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MonCustomCell") as! CustomTimeTableViewCell
//        
//        let realm = try! Realm()
//        let saveModel = realm.objects(TimeTableSaveModel.self)
//        
//        // セルに値を設定
//        
//        cell.setCell(saveModel[(indexPath as NSIndexPath).row].subjectName,roomN:saveModel[(indexPath as NSIndexPath).row].room)
//        return cell
//    }
//    
    
    override var prefersStatusBarHidden : Bool {
        // trueの場合はステータスバー非表示
        return false;
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        // ステータスバーを白くする
        return UIStatusBarStyle.lightContent;
    }
    

}
