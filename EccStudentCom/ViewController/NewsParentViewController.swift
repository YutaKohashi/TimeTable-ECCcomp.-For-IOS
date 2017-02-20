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

class NewsParentViewController:UIViewController, UITableViewDataSource , UITableViewDelegate{
    let realm = try! Realm()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let refreshControl = UIRefreshControl()
    
    var cellCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //区切り線をなくす
        tableView.separatorColor = UIColor(red:0.86, green:0.86, blue:0.86, alpha:1.0)
        
        tableView.dataSource = self
         tableView.delegate = self
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
                        self.cellCount = self.realm.objects(SchoolNewsItem.self).count - 1
                        
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
                        self.cellCount = self.realm.objects(TaninNewsItem.self).count - 1
                        
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
    
    var newsTitle:String = ""
    var html: String = ""
    var date:String = ""
    //　セルタップ時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //タップしたあとハイライトを消す
        tableView.deselectRow(at: indexPath, animated: false)
        var index:NSInteger = (indexPath as NSIndexPath).row
        index += 1
        var uri:String = ""
        // NewsDetailViewController へ遷移するために Segue を呼び出す
        if segmentedControl.selectedSegmentIndex  == 0 {
            let saveModel = realm.objects(SchoolNewsItem.self)
            if saveModel[index].groupTitle != "" {return}
            
            //インターネットに接続されていないのときはアラート表示
            if !ToolsBase().CheckReachability("google.com"){
                DialogManager().showWarningForInternet()
                refreshControl.endRefreshing()
                self.tableView.isScrollEnabled = true
                return;
            }
            
            uri = saveModel[index].uri
            newsTitle = saveModel[index].title
            date = saveModel[index].date
        } else {
            let saveModel = realm.objects(TaninNewsItem.self)
            //インターネットに接続されていないのときはアラート表示
            if !ToolsBase().CheckReachability("google.com"){
                DialogManager().showWarningForInternet()
                refreshControl.endRefreshing()
                self.tableView.isScrollEnabled = true
                return;
            }
            uri = saveModel[index].uri
            newsTitle = saveModel[index].title
            date = saveModel[index].date
        }
        DialogManager().showIndicator()
        HttpConnector().requestNewsDetail(userId: PreferenceManager.getSavedId(), password: PreferenceManager.getSavedId(), uri:uri,callback: { (cb) in
            if(cb.bool){
                self.html = cb.string
//                self.performSegue(withIdentifier: "toNewsDetailViewController",sender: nil)
                DispatchQueue.main.async(execute: {
                     DialogManager().hideIndicator()
                    let storyboard: UIStoryboard = self.storyboard!
                    let newsDetailVC: NewsDetailViewController = storyboard.instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
                    newsDetailVC.setTitle(str: self.newsTitle)
                    newsDetailVC.setDate(str: self.date)
                    newsDetailVC.setHtml(str: self.html)
                    self.present(newsDetailVC, animated: true, completion: nil)
                })
            } else {
                DialogManager().showError()
            }
        })
     
    }

    /// セルの個数を指定するデリゲートメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    
    /// セルに値を設定するデータソースメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentedControl.selectedSegmentIndex == 0 {
            // セルを取得
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
    
    // セグメントchanged
    @objc func selectedSegmentChanged(_ sender: UISegmentedControl, forEvent event: UIEvent){
//
        let myQueue = DispatchQueue(label: "com.example.serial-queue", attributes: [.serial, .qosUtility])
        
        let offset: CGPoint = CGPoint(x: self.tableView.contentOffset.x, y: -self.tableView.contentInset.top)
        self.tableView.setContentOffset(offset, animated: false )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if sender.selectedSegmentIndex  == 0{
                self.cellCount = self.realm.objects(SchoolNewsItem.self).count - 1
                self.tableView.reloadData()
                self.refreshControl.attributedTitle =
                    NSAttributedString(string:"最終更新日時 : " +
                        PreferenceManager.getLatestUpdateSchoolNews());
            } else {
                self.cellCount = self.realm.objects(TaninNewsItem.self).count - 1
                self.tableView.reloadData()
                self.refreshControl.attributedTitle =
                    NSAttributedString(string:"最終更新日時 : " +
                        PreferenceManager.getLatestUpdateTaninNews());
            }
            self.tableView.bounces = true
            self.tableView.isScrollEnabled = true
        }
    }

}
