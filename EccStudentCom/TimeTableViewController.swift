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
        
        //選択不可に
        mondayTableView.allowsSelection = false
        tuesdayTableView.allowsSelection = false
        wednesdayTableView.allowsSelection = false
        thursdayTableView.allowsSelection = false
        fridayTableView.allowsSelection = false

        mondayTableView.dataSource = self
        tuesdayTableView.dataSource = self
        wednesdayTableView.dataSource = self
        thursdayTableView.dataSource = self
        fridayTableView.dataSource = self
        
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
        // Dispose of any resources that can be recreated.
        
    }
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var subjectName:String = ""
        var roomNumber:String = ""
        
        switch tableView.tag {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MonCustomCell") as! CustomTimeTableViewCellMon
          
            let realm = try! Realm()
            let saveModel = realm.objects(TimeTableSaveModel.self)
            subjectName = saveModel[(indexPath as NSIndexPath).row * 5].subjectName
            roomNumber = saveModel[(indexPath as NSIndexPath).row * 5].room
            // セルに値を設定
            cell.setCell(subjectName,roomN:roomNumber)
    
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TueCustomCell") as! CustomTimeTableViewCellTue
            let realm = try! Realm()
            let saveModel = realm.objects(TimeTableSaveModel.self)
            
            subjectName = saveModel[(indexPath as NSIndexPath).row * 5 + 1].subjectName
            roomNumber = saveModel[(indexPath as NSIndexPath).row * 5 + 1].room
            // セルに値を設定
            cell.setCell(subjectName,roomN:roomNumber)
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WedCustomCell") as! CustomTimeTableViewCellWed
            let realm = try! Realm()
            let saveModel = realm.objects(TimeTableSaveModel.self)
            subjectName = saveModel[(indexPath as NSIndexPath).row * 5 + 2].subjectName
            roomNumber = saveModel[(indexPath as NSIndexPath).row * 5 + 2].room
            // セルに値を設定
            cell.setCell(subjectName,roomN:roomNumber)
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThurCustomCell") as! CustomTimeTableViewCellThur
            let realm = try! Realm()
            let saveModel = realm.objects(TimeTableSaveModel.self)
            subjectName = saveModel[(indexPath as NSIndexPath).row * 5 + 3].subjectName
            roomNumber = saveModel[(indexPath as NSIndexPath).row  * 5 + 3].room
            // セルに値を設定
            cell.setCell(subjectName,roomN:roomNumber)
            
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriCustomCell") as! CustomTimeTableViewCellFri
            let realm = try! Realm()
            let saveModel = realm.objects(TimeTableSaveModel.self)
            subjectName = saveModel[(indexPath as NSIndexPath).row * 5 + 4].subjectName
            roomNumber = saveModel[(indexPath as NSIndexPath).row * 5 + 4].room
            // セルに値を設定
            cell.setCell(subjectName,roomN:roomNumber)
            

            return cell
        
        default:
            break

        }
        
        //ここは通らない
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonCustomCell") as! CustomTimeTableViewCellMon
        return cell
        
    }
    
    func warningColor(){
    
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
    

}
