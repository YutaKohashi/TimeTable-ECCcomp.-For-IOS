//
//  NewsParentViewController.swift
//  EccStudentCom
//
//  Created by 小橋勇太 on 2017/02/17.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import UIKit
import RealmSwift
import KRProgressHUD

class NewsParentViewController:UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let refreshControl = UIRefreshControl()
    
    var cellCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //区切り線をなくす
        tableView.separatorColor = UIColor(red:0.86, green:0.86, blue:0.86, alpha:1.0)
        let realm = try! Realm()
        tableView.dataSource = self
        
        //リフレッシュコントロールを作成する。
        
        //インジケーターの色を設定する。
        refreshControl.tintColor = UIColor.gray
        //テーブルビューを引っ張ったときの呼び出しメソッドを登録する。
        refreshControl.addTarget(self, action: #selector(NewsParentViewController.refreshTable(_:)), for: .valueChanged)
        
        //　デフォルト値を設定
        PreferenceManager.setTaninSchoolDefaultUpdate()
        
        refreshControl.attributedTitle =
            NSAttributedString(string:"最終更新日時 : " +
                PreferenceManager.getLatestUpdateSchoolNews());
        
        //テーブルビューコントローラーのプロパティにリフレッシュコントロールを設定する。
        self.tableView.addSubview(refreshControl)
        
        cellCount = realm.objects(SchoolNewsItem.self).count - 1
//        self.indicator.isHidden = true
        tableView.estimatedRowHeight = 74
        tableView.rowHeight = UITableViewAutomaticDimension
        
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
        
        if segmentedControl.selectedSegmentIndex == 0 {
            HttpConnector().request(type: .NEWS_SCHOOL, userId: PreferenceManager.getSavedId(), password: PreferenceManager.getSavedPass()) { (result) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if result {
                        //テーブルを再読み込みする。
                        let realm = try! Realm()
                        self.cellCount = realm.objects(SchoolNewsItem.self).count - 1
                        
                        self.tableView.reloadData()
                        refreshControl.endRefreshing()
                        self.tableView.isScrollEnabled = true
                        
                        refreshControl.attributedTitle =
                            NSAttributedString(string:"最終更新日時 : " +
                                ToolsBase().getNow());
                        PreferenceManager.saveLatestUpdateASchoolNews(now: ToolsBase().getNow())
//                        DialogManager().showSuccess()
                    } else {
                        refreshControl.endRefreshing()
                        self.tableView.isScrollEnabled = true
//                        DialogManager().showError()
                    }
                }
            }
        } else {
            HttpConnector().request(type: .NEWS_TEACHER, userId: PreferenceManager.getSavedId(), password: PreferenceManager.getSavedPass()) { (result) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if result {
                        //テーブルを再読み込みする。
                        let realm = try! Realm()
                        self.cellCount = realm.objects(TaninNewsItem.self).count - 1
                        
                        self.tableView.reloadData()
                        refreshControl.endRefreshing()
                        self.tableView.isScrollEnabled = true
                        
                        refreshControl.attributedTitle =
                            NSAttributedString(string:"最終更新日時 : " +
                                ToolsBase().getNow());
                        PreferenceManager.saveLatestUpdateTaninNews(now: ToolsBase().getNow())
//                        DialogManager().showSuccess()
                    } else {
                        refreshControl.endRefreshing()
                        self.tableView.isScrollEnabled = true
//                        DialogManager().showError()
                    }
                }
            }
        }
    }

    /// セルの個数を指定するデリゲートメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let realm = try! Realm()
//        print("realm.objects(SaveModel).count =\(realm.objects(AttendanceRate.self).count)")
//        return realm.objects(SchoolNewsItem.self).count - 1
        return cellCount
    }
    
    /// セルに値を設定するデータソースメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentedControl.selectedSegmentIndex == 0 {
            // セルを取得
            let realm = try! Realm()
            let saveModel = realm.objects(SchoolNewsItem.self)
            var index:NSInteger = (indexPath as NSIndexPath).row
            index += 1
        
            let title = saveModel[index].title
            let date = saveModel[index].date
            let uri = saveModel[index].uri
            let groupTitle = saveModel[index].groupTitle
        
            if title == "" {
                // タイトル
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTitleCell") as! NewsTitleCell
                cell.setCell(groupTitle)
                cell.selectionStyle = .none
                return cell
            } else {
                // 記事
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewsItemCell") as! NewsItemCell
                cell.setCell(title, date: date, uri: uri)
                
                return cell
            }
        } else {
            let realm = try! Realm()
            let saveModel = realm.objects(TaninNewsItem.self)
            var index:NSInteger = (indexPath as NSIndexPath).row
            index += 1
            
            let title = saveModel[index].title
            let date = saveModel[index].date
            let uri = saveModel[index].uri
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsItemCell") as! NewsItemCell
            cell.setCell(title, date: date, uri: uri)
            
            return cell

        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func selectedSegmentChanged(_ sender: UISegmentedControl, forEvent event: UIEvent) {
        let realm = try! Realm()
        if sender.selectedSegmentIndex  == 0{
            cellCount = realm.objects(SchoolNewsItem.self).count - 1
            self.tableView.reloadData()
            refreshControl.attributedTitle =
                NSAttributedString(string:"最終更新日時 : " +
                    PreferenceManager.getLatestUpdateSchoolNews());
        } else {
            cellCount = realm.objects(TaninNewsItem.self).count - 1
            self.tableView.reloadData()
            refreshControl.attributedTitle =
                NSAttributedString(string:"最終更新日時 : " +
                     PreferenceManager.getLatestUpdateTaninNews());
        }
    }
}
