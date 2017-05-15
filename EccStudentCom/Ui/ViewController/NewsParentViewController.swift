//
//  NewsParentViewController.swift
//  EccStudentCom
//
//  Created by 小橋勇太 on 2017/02/17.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
import KRProgressHUD
import SpringIndicator

class NewsParentViewController:UIViewController, UITableViewDataSource , UITableViewDelegate{
    
//    let realm = try! Realm()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var taninTableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    
//    @IBOutlet weak var taninEmptyView: UIView!
//    @IBOutlet weak var schoolEmptyView: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let refreshControl:SpringIndicator.Refresher = SpringIndicator.Refresher()
    let taninRefreshControl :SpringIndicator.Refresher = SpringIndicator.Refresher()
    
    var taninNewsItems: Results<TaninNewsItem>!
    var schoolNewsItems:Results<SchoolNewsItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //　デフォルト値を設定
        PreferenceManager.setTaninSchoolDefaultUpdate()
        
        //　デリゲートデータ・ソースを設定
        // tableviewにrefreshcontrolを設定
        initRefreshContorol()
        initTableView()
//        taninEmptyView.isHidden = true
//        schoolEmptyView.isHidden = true
     
        // 初期値
        taninTableView.isHidden = true
        segmentedControl.selectedSegmentIndex = 0
        
        schoolNewsItems = SchoolNewsAccessor.sharedInstance.getAll()
        print(schoolNewsItems.count)
        taninNewsItems = TaninNewsAccessor.sharedInstance.getAll()
    }
    
    //テーブルビュー引っ張り時の呼び出しメソッド
    func refreshTable(_ refreshControl: UIRefreshControl){
        //インターネットに接続されていないのときはアラート表示
        if !ToolsBase().CheckReachability("google.com"){
            DialogManager().showWarningForInternet()
            refreshControl.endRefreshing()
            self.tableView.isScrollEnabled = true
            self.taninTableView.isScrollEnabled = true
            return
        }
        
        if segmentedControl.selectedSegmentIndex == 0 {
            //学校から
            //スクロール無効化
            self.tableView.isScrollEnabled = false
            HttpConnector().request(type: .NEWS_SCHOOL, userId: PreferenceManager.getSavedId(), password: PreferenceManager.getSavedPass()) { (result) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if result {
                        //テーブルを再読み込みする。
                        self.schoolNewsItems = SchoolNewsAccessor.sharedInstance.getAll()
                        self.tableView.reloadData()
                        refreshControl.endRefreshing()
                        self.tableView.isScrollEnabled = true
                        
//                        refreshControl.attributedTitle =
//                            NSAttributedString(string:"最終更新日時 : " +
//                                ToolsBase().getNow());
                        PreferenceManager.saveLatestUpdateASchoolNews(now: ToolsBase().getNow())
                        //                        DialogManager().showSuccess()
                        ToastView.showText(text: "更新しました")
                    } else {
                        refreshControl.endRefreshing()
                        self.tableView.isScrollEnabled = true
                        //                        DialogManager().showError()
                    }
                }
            }
        }
        else
        {   //担任から
            //スクロール無効化
            self.taninTableView.isScrollEnabled = false
            HttpConnector().request(type: .NEWS_TEACHER, userId: PreferenceManager.getSavedId(), password: PreferenceManager.getSavedPass()) { (result) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if result {
                        //テーブルを再読み込みする。
                        self.taninNewsItems = TaninNewsAccessor.sharedInstance.getAll()
                        self.taninTableView.reloadData()
                        refreshControl.endRefreshing()
                        self.taninTableView.isScrollEnabled = true
                        
//                        refreshControl.attributedTitle =
//                            NSAttributedString(string:"最終更新日時 : " +
//                                ToolsBase().getNow());
                        PreferenceManager.saveLatestUpdateTaninNews(now: ToolsBase().getNow())
                        //                        DialogManager().showSuccess()
                    } else {
                        refreshControl.endRefreshing()
                        self.taninTableView.isScrollEnabled = true
                        //                        DialogManager().showError()
                    }
                }
            }

        }
    }
    
   
    //　セルタップ時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //タップしたあとハイライトを消す
        tableView.deselectRow(at: indexPath, animated: false)
        let index:NSInteger = (indexPath as NSIndexPath).row
        
        var newsTitle:String! = ""
        var date:String! = ""
        var newsId:Int! = -1
        
        if tableView.tag == 0 {
            newsTitle = schoolNewsItems?[index].title
            date = schoolNewsItems?[index].date
            newsId = schoolNewsItems?[index].newsId
        } else {
            newsTitle = taninNewsItems?[index].title
            date = taninNewsItems?[index].date
            newsId = taninNewsItems?[index].newsId
        }
        
        //インターネットに接続されていないのときはアラート表示
        
        guard ToolsBase().CheckReachability("google.com") else {
            DialogManager().showWarningForInternet()
            refreshControl.endRefreshing()
            self.tableView.isScrollEnabled = true
            self.taninTableView.isScrollEnabled = true
            return;
        }
      
        if(newsId == nil){
            DialogManager().showError()
            return
        }
        
        let storyboard: UIStoryboard = self.storyboard!
        let newsDetailVC: NewsDetailViewController = storyboard.instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
        newsDetailVC.setTitle(str: newsTitle!)
        newsDetailVC.setDate(str: date!)
        newsDetailVC.setNewsId(int: newsId)
        self.present(newsDetailVC, animated: true, completion: nil)

     
    }

    /// セルの個数を指定するデリゲートメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag  == 0 {
            return schoolNewsItems.count
        } else {
            return taninNewsItems.count
        }
    }
    
    var index:NSInteger = 0
    /// セルに値を設定するデータソースメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得
        index = indexPath.row
        
        let title :String = schoolNewsItems![index].title
        let date :String = schoolNewsItems![index].date
        let newsId :String  = String(schoolNewsItems![index].newsId)
        let from:String = schoolNewsItems![index].from
        
        // 記事
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsItemCell") as! NewsItemCell
        cell.setCell(title, date: date, newsId: newsId, from:from)
        
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // セグメントchanged
    @objc func selectedSegmentChanged(_ sender: UISegmentedControl, forEvent event: UIEvent){
        if sender.selectedSegmentIndex  == 0{
            taninTableView.isHidden = true
            tableView.isHidden = false
        }
        else
        {
            taninTableView.isHidden = false
            tableView.isHidden = true
        }
    }

    
    // MARK:tableviewを設定
    private func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        taninTableView.dataSource = self
        taninTableView.delegate = self
        
         self.tableView.addSubview(refreshControl)
        self.taninTableView.addSubview(taninRefreshControl)
        
        tableView.estimatedRowHeight = 74
        tableView.rowHeight = UITableViewAutomaticDimension
        taninTableView.estimatedRowHeight = 74
        taninTableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    // MARK:refreshcontrolを設定
    private func initRefreshContorol() {
        //リフレッシュコントロールを作成する。
        //インジケーターの色を設定する。
        refreshControl.tintColor = UIColor(red:0.86, green:0.86, blue:0.86, alpha:1.0)
        //テーブルビューを引っ張ったときの呼び出しメソッドを登録する。
        refreshControl.addTarget(self, action: #selector(NewsParentViewController.refreshTable(_:)), for: .valueChanged)
        
        
//        refreshControl.attributedTitle =
//            NSAttributedString(string:"最終更新日時 : " +
//                PreferenceManager.getLatestUpdateSchoolNews());
//        
//        
        
        taninRefreshControl.tintColor = UIColor(red:0.86, green:0.86, blue:0.86, alpha:1.0)
        taninRefreshControl.addTarget(self, action: #selector(NewsParentViewController.refreshTable(_:)), for: .valueChanged)
        
//        taninRefreshControl.attributedTitle =
//            NSAttributedString(string:"最終更新日時 : " +
//                PreferenceManager.getLatestUpdateTaninNews());
        
    }
    

}
