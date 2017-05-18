//
//  TableViewController.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/09/25.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
import SpringIndicator

class TableViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var totalDataIndicatorView: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
//    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var totalUnitLabel: UILabel!
    @IBOutlet weak var attedanceRateLabel: UILabel!
    @IBOutlet weak var lostUnitLabel: UILabel!
    @IBOutlet weak var attendanceNumLabel: UILabel!
    @IBOutlet weak var abcentNumLabel: UILabel!
    @IBOutlet weak var emptyLabel: UILabel!
    
    let refreshControl :SpringIndicator.Refresher = SpringIndicator.Refresher()
    
    var items:Results<AttendanceRateItem>? = nil
    
    //    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //cellを選択不可に
        tableView.allowsSelection = false
        //区切り線をなくす 背景と同色
        tableView.separatorColor = UIColor(red:0.86, green:0.86, blue:0.86, alpha:1.0)
        
        //        print("realm.objects(SaveModel).count =\(realm.objects(SaveModel.self).count)")
        tableView.dataSource = self
        
        items = AttedanceRateAccessor.sharedInstance.getAll()
        self.updateEmptyLabelStatus()
        
        //トータルデータ
        self.setTotalData()
        
        //テーブルビューを引っ張ったときの呼び出しメソッドを登録する。
        refreshControl.addTarget(self, action: #selector(TableViewController.refreshTable(_:)), for: .valueChanged)
        refreshControl.indicator.lineColor = Util.getPrimaryColor()

        //テーブルビューコントローラーのプロパティにリフレッシュコントロールを設定する。
        self.tableView.addSubview(refreshControl)

    }
    
    //テーブルビュー引っ張り時の呼び出しメソッド
    func refreshTable(_ refreshControl: SpringIndicator.Refresher){
        //スクロール無効化
        self.tableView.isScrollEnabled = false
        
        //インターネットに接続されていないのときはアラート表示
        if !Util.isConnectedToNetwork(){
            DiagUtil.showWarningForInternet()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                refreshControl.endRefreshing()
            }
            self.tableView.isScrollEnabled = true
            return;
        }
        
        removeTotalData()
        
        //テーブル更新
        HttpConnector().request(type: .ATTENDANCE_RATE,
                                userId: PrefUtil.getSavedId(),
                                password: PrefUtil.getSavedPass())
        { (result) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

                self.items = AttedanceRateAccessor.sharedInstance.getAll()
                self.updateEmptyLabelStatus()
                
                //トータルデータをセット
                self.setTotalData()
                
                if (result){
                    //テーブルを再読み込みする。
                    self.tableView.reloadData()
                    refreshControl.endRefreshing()
                    self.tableView.isScrollEnabled = true
                    PrefUtil.saveLatestUpdateAttendanceRate(now: Util.getNow())
                    
                    if self.items == nil || self.items!.count == 0 {
                        DiagUtil.showSuccess(string: "更新しましたが\nデータがありませんでした")
                    } else {
                        DiagUtil.showSuccess(string: "更新しました")
                    }
                    
                    
                }else{
                    refreshControl.endRefreshing()
                    self.tableView.isScrollEnabled = true
                    DiagUtil.showError(string: "失敗しました")
                }
            }
        }
    }
    
    func setTotalData(){
        guard items != nil && items!.count != 0 else {
            return
        }
        print(items!.count)
        self.totalUnitLabel.text = items?[0].unit
        self.attedanceRateLabel.text = items?[0].attendanceRate
        self.lostUnitLabel.text = items?[0].shortageNumber
        self.attendanceNumLabel.text = items?[0].attendanceNumber
        self.abcentNumLabel.text = items?[0].absentNumber
    }
    
    func removeTotalData(){
        self.totalUnitLabel.text = ""
        self.attedanceRateLabel.text = ""
        self.lostUnitLabel.text = ""
        self.attendanceNumLabel.text = ""
        self.abcentNumLabel.text = ""
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// セルの個数を指定するデリゲートメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard items != nil else {
            return 0
        }
        return items!.count - 1
    }
    
    /// セルに値を設定するデータソースメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomTableViewCell
        
        var index:Int = indexPath.row
        index += 1
        
        let subjectName = items?[index].subjectName
        let unit = items?[index].unit
        let attendanceNumber = items?[index].attendanceNumber
        let lateNumber = items?[index].lateNumber
        let absentNumber = items?[index].absentNumber
        let publicAbsentNumber1 = items?[index].publicAbsentNumber1
        let publicAbsentNumber2 = items?[index].publicAbsentNumber2
        let attendanceRate = items?[index].attendanceRate
        let shortageNumber = items?[index].shortageNumber
        
        cell.setCell(subjectName!,
                     unitNum: unit!,
                     attendanceNum: attendanceNumber!,
                     absentNum: absentNumber!,
                     lateNum: lateNumber!,
                     pubAbsentnum1: publicAbsentNumber1!,
                     pubAbsentnum2: publicAbsentNumber2!,
                     attendanceRateNum: attendanceRate!,
                     shortageNum: shortageNumber!)
  
        return cell
    }
    
    private func updateEmptyLabelStatus(){
        if items != nil && items!.count >  0 {
            emptyLabel.isHidden = true
        } else {
            //　データなし
            emptyLabel.isHidden = false
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        // trueの場合はステータスバー非表示
        return false;
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        // ステータスバーを白くする
        return UIStatusBarStyle.lightContent;
    }
    
    func defaultColor() -> UIColor{
        return UIColor(red: 63 / 255.0, green: 63 / 255.0, blue: 63 / 255.0, alpha: 1.0)
    }
    
    func darkGreen() -> UIColor{
        return UIColor(red: 0 / 255.0, green: 86 / 255.0, blue: 96 / 255.0, alpha: 1.0)
    }
}
