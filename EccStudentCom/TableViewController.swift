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

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //cellを選択不可に
        tableView.allowsSelection = false
        //区切り線をなくす
        tableView.separatorColor = UIColor.clear
        
        let realm = try! Realm()
        print("realm.objects(SaveModel).count =\(realm.objects(SaveModel.self).count)")
        tableView.dataSource = self
        
        //リフレッシュコントロールを作成する。
        let refresh = UIRefreshControl()
        
        //インジケーターの下に表示する文字列を設定する。
        refresh.attributedTitle = NSAttributedString(string: "更新中")
        //インジケーターの色を設定する。
        refresh.tintColor = UIColor.gray
        //テーブルビューを引っ張ったときの呼び出しメソッドを登録する。
        refresh.addTarget(self, action: #selector(TableViewController.refreshTable(_:)), for: .valueChanged)
        //テーブルビューコントローラーのプロパティにリフレッシュコントロールを設定する。
        self.tableView.addSubview(refresh)
    }
    
    //テーブルビュー引っ張り時の呼び出しメソッド
    func refreshTable(_ refreshControl: UIRefreshControl){
        //スクロール無効化
        self.tableView.isScrollEnabled = false
        
        //インターネットに接続されていないのときはアラート表示
        if !ToolsBase().CheckReachability("google.com"){
            //            ToolsBase().showToast("インターネットに接続されていません", isShortLong: true)
            DialogManager().showWarningForInternet()
             refreshControl.endRefreshing()
            self.tableView.isScrollEnabled = true
            return;
        }
        
        //テーブル更新
        HttpRequest().refreshAttendanseRate(userId: SaveManager().getSavedId(), password: SaveManager().getSavedPass(),callback: {
            requestResultBool in
            if (requestResultBool){
                //テーブルを再読み込みする。
                self.tableView.reloadData()
                refreshControl.endRefreshing()
                self.tableView.isScrollEnabled = true
            }else{
                refreshControl.endRefreshing()
                self.tableView.isScrollEnabled = true
            }
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        // DBファイルのfileURLを取得
        if let fileURL = Realm.Configuration.defaultConfiguration.fileURL {
            try! FileManager.default.removeItem(at: fileURL)
        }
    }
    
    /// セルの個数を指定するデリゲートメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        print("realm.objects(SaveModel).count =\(realm.objects(SaveModel.self).count)")
        return realm.objects(SaveModel.self).count
//        return array.count
    }
    
    /// セルに値を設定するデータソースメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomTableViewCell
        
        let realm = try! Realm()
        let saveModel = realm.objects(SaveModel.self)
        
        let subjectName = saveModel[(indexPath as NSIndexPath).row].subjectName
        let unit = saveModel[(indexPath as NSIndexPath).row].unit
        let attendanceNumber = saveModel[(indexPath as NSIndexPath).row].attendanceNumber
        let lateNumber = saveModel[(indexPath as NSIndexPath).row].lateNumber
        let absentNumber = saveModel[(indexPath as NSIndexPath).row].absentNumber
        let publicAbsentNumber1 = saveModel[(indexPath as NSIndexPath).row].publicAbsentNumber1
        let publicAbsentNumber2 = saveModel[(indexPath as NSIndexPath).row].publicAbsentNumber2
        let attendanceRate = saveModel[(indexPath as NSIndexPath).row].attendanceRate
        let shortageNumber = saveModel[(indexPath as NSIndexPath).row].shortageNumber
        
        cell.setCell(subjectName,
                     unitNum: unit,
                     attendanceNum: attendanceNumber,
                     absentNum: absentNumber,
                     lateNum: lateNumber,
                     pubAbsentnum1: publicAbsentNumber1,
                     pubAbsentnum2: publicAbsentNumber2,
                     attendanceRateNum: attendanceRate,
                     shortageNum: shortageNumber)
        
        if(Int(attendanceRate)! < 75){
            //cell.backgroundColor = UIColor.darkGray
            cell.attendanceRate.textColor = defaultColor()
        }else if(Int(attendanceRate)! < 80){
            cell.attendanceRate.textColor = UIColor.red
            //cell.backgroundColor = nil
        }else if(Int(attendanceRate)! < 90){
            cell.attendanceRate.textColor = darkGreen()
            //cell.backgroundColor = nil
        }else{
            //cell.backgroundColor = UIColor.darkGray
            cell.attendanceRate.textColor = defaultColor()
        }
        
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
