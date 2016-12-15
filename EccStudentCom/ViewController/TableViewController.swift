//
//  TableViewController.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/09/25.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import UIKit
import RealmSwift
import KRProgressHUD

class TableViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var totalDataIndicatorView: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var totalUnitLabel: UILabel!
    @IBOutlet weak var attedanceRateLabel: UILabel!
    @IBOutlet weak var lostUnitLabel: UILabel!
    @IBOutlet weak var attendanceNumLabel: UILabel!
    @IBOutlet weak var abcentNumLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //cellを選択不可に
        tableView.allowsSelection = false
        //区切り線をなくす
        tableView.separatorColor = UIColor.clear
        
        let realm = try! Realm()
        print("realm.objects(SaveModel).count =\(realm.objects(SaveModel.self).count)")
        tableView.dataSource = self
        
        //トータルデータ
        self.setTotalData()
        
        //リフレッシュコントロールを作成する。
        let refresh = UIRefreshControl()
        
        //インジケーターの下に表示する文字列を設定する。
        refresh.attributedTitle =
            NSAttributedString(string:"最終更新日時 : " +
                PreferenceManager.getLatestUpdateAttendanceRate());
        
        //インジケーターの色を設定する。
        refresh.tintColor = UIColor.gray
        //テーブルビューを引っ張ったときの呼び出しメソッドを登録する。
        refresh.addTarget(self, action: #selector(TableViewController.refreshTable(_:)), for: .valueChanged)
        //テーブルビューコントローラーのプロパティにリフレッシュコントロールを設定する。
        self.tableView.addSubview(refresh)
        
        self.indicator.isHidden = true
    }
    
    //テーブルビュー引っ張り時の呼び出しメソッド
    func refreshTable(_ refreshControl: UIRefreshControl){
        //スクロール無効化
        self.tableView.isScrollEnabled = false
        
        //インターネットに接続されていないのときはアラート表示
        if !ToolsBase().CheckReachability("google.com"){
            DialogManager().showWarningForInternet()
            refreshControl.endRefreshing()
            self.tableView.isScrollEnabled = true
            return;
        }
        
        removeTotalData()
        self.indicator.isHidden = false
        self.indicator.startAnimating()
        //テーブル更新
        HttpConnector().request(.attendance_RATE,
                                userId: PreferenceManager.getSavedId(),
                                password: PreferenceManager.getSavedPass())
        { (result) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.indicator.isHidden = true
                self.indicator.stopAnimating()
                
                //トータルデータをセット
                self.setTotalData()
                
                if (result){
                    //テーブルを再読み込みする。
                    self.tableView.reloadData()
                    refreshControl.endRefreshing()
                    self.tableView.isScrollEnabled = true
                    
                    refreshControl.attributedTitle =
                        NSAttributedString(string:"最終更新日時 : " +
                             ToolsBase().getNow());
                    PreferenceManager.saveLatestUpdateAttendanceRate(ToolsBase().getNow())
                    
                }else{
                    refreshControl.endRefreshing()
                    self.tableView.isScrollEnabled = true
                    
                }
            }
        }
    }
    
    func setTotalData(){
        let realm = try! Realm()
        let saveModel = realm.objects(SaveModel.self)
        
        self.totalUnitLabel.text = saveModel[0].unit
        self.attedanceRateLabel.text = saveModel[0].attendanceRate
        self.lostUnitLabel.text = saveModel[0].shortageNumber
        self.attendanceNumLabel.text = saveModel[0].attendanceNumber
        self.abcentNumLabel.text = saveModel[0].absentNumber
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
        // DBファイルのfileURLを取得
        if let fileURL = Realm.Configuration.defaultConfiguration.fileURL {
            try! FileManager.default.removeItem(at: fileURL)
        }
    }
    
    /// セルの個数を指定するデリゲートメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        print("realm.objects(SaveModel).count =\(realm.objects(SaveModel.self).count)")
        return realm.objects(SaveModel.self).count - 1
    }
    
    /// セルに値を設定するデータソースメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomTableViewCell
        
        let realm = try! Realm()
        let saveModel = realm.objects(SaveModel.self)
        
        var index:NSInteger = (indexPath as NSIndexPath).row
        index += 1
        
        let subjectName = saveModel[index].subjectName
        let unit = saveModel[index].unit
        let attendanceNumber = saveModel[index].attendanceNumber
        let lateNumber = saveModel[index].lateNumber
        let absentNumber = saveModel[index].absentNumber
        let publicAbsentNumber1 = saveModel[index].publicAbsentNumber1
        let publicAbsentNumber2 = saveModel[index].publicAbsentNumber2
        let attendanceRate = saveModel[index].attendanceRate
        let shortageNumber = saveModel[index].shortageNumber
        
        cell.setCell(subjectName,
                     unitNum: unit,
                     attendanceNum: attendanceNumber,
                     absentNum: absentNumber,
                     lateNum: lateNumber,
                     pubAbsentnum1: publicAbsentNumber1,
                     pubAbsentnum2: publicAbsentNumber2,
                     attendanceRateNum: attendanceRate,
                     shortageNum: shortageNumber)
        
        //        if(Int(attendanceRate)! < 75){
        //            //cell.backgroundColor = UIColor.darkGray
        //            cell.attendanceRate.textColor = defaultColor()
        //        }else if(Int(attendanceRate)! < 80){
        //            cell.attendanceRate.textColor = UIColor.red
        //            //cell.backgroundColor = nil
        //        }else if(Int(attendanceRate)! < 90){
        //            cell.attendanceRate.textColor = darkGreen()
        //            //cell.backgroundColor = nil
        //        }else{
        //            //cell.backgroundColor = UIColor.darkGray
        //            cell.attendanceRate.textColor = defaultColor()
        //        }
        
        return cell
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
