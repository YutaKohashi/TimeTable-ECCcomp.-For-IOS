//
//  NewsParentViewController.swift
//  EccStudentCom
//
//  Created by 小橋勇太 on 2017/02/17.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import UIKit
//import RealmSwift
import KRProgressHUD

class NewsParentViewController:UIViewController, UITableViewDataSource , UITableViewDelegate{
    
//    let realm = try! Realm()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var taninTableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let refreshControl = UIRefreshControl()
    let taninRefreshControl = UIRefreshControl()
    
    var taninNewsItems: Array<TaninNewsItem>!
    var schoolNewsItems:Array<SchoolNewsItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //　デフォルト値を設定
        PreferenceManager.setTaninSchoolDefaultUpdate()
        
        //　デリゲートデータ・ソースを設定
        // tableviewにrefreshcontrolを設定
        initRefreshContorol()
        initTableView()
        
     
        // 初期値
        taninTableView.isHidden = true
        segmentedControl.selectedSegmentIndex = 0
        
        schoolNewsItems = loadSchoolItems()
        taninNewsItems = loadTaninItems()
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
                        self.schoolNewsItems = self.loadSchoolItems()
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
        }
        else
        {   //担任から
            //スクロール無効化
            self.taninTableView.isScrollEnabled = false
            HttpConnector().request(type: .NEWS_TEACHER, userId: PreferenceManager.getSavedId(), password: PreferenceManager.getSavedPass()) { (result) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if result {
                        //テーブルを再読み込みする。
                        self.taninNewsItems = self.loadTaninItems()
                        self.taninTableView.reloadData()
                        refreshControl.endRefreshing()
                        self.taninTableView.isScrollEnabled = true
                        
                        refreshControl.attributedTitle =
                            NSAttributedString(string:"最終更新日時 : " +
                                ToolsBase().getNow());
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
    
    var newsTitle:String? = ""
    var html: String? = ""
    var date:String? = ""
    //　セルタップ時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //タップしたあとハイライトを消す
        tableView.deselectRow(at: indexPath, animated: false)
        let index:NSInteger = (indexPath as NSIndexPath).row
        var uri:String? = ""
        
//        if tableView.tag == 0 {
//            // 学校から
////            if schoolNewsItems?[index].groupTitle != "" {return}
////            uri = schoolNewsItems?[index].uri
//            newsTitle = schoolNewsItems?[index].title
//            date = schoolNewsItems?[index].date
//            
//
//        }
//        else
//        {   // 担任から
//            uri = taninNewsItems?[index].uri
//            newsTitle = taninNewsItems?[index].title
//            date = taninNewsItems?[index].date
//            
//        }
        newsTitle = taninNewsItems?[index].title
        date = taninNewsItems?[index].date
        
        //インターネットに接続されていないのときはアラート表示
        if !ToolsBase().CheckReachability("google.com"){
            DialogManager().showWarningForInternet()
            refreshControl.endRefreshing()
            self.tableView.isScrollEnabled = true
            self.taninTableView.isScrollEnabled = true
            return;
        }
      
        if(uri == nil || uri == ""){
            DialogManager().showError()
            return
        }
        
        DialogManager().showIndicator()
//        HttpConnector().requestNewsDetail(userId: PreferenceManager.getSavedId(), password: PreferenceManager.getSavedId(), newsId:uri!,callback: { (cb) in
//            if(cb.bool){
//                self.html = cb.string
////                self.performSegue(withIdentifier: "toNewsDetailViewController",sender: nil)
//                DispatchQueue.main.async(execute: {
//                     DialogManager().hideIndicator()
//                    let storyboard: UIStoryboard = self.storyboard!
//                    let newsDetailVC: NewsDetailViewController = storyboard.instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
//                    newsDetailVC.setTitle(str: self.newsTitle!)
//                    newsDetailVC.setDate(str: self.date!)
//                    newsDetailVC.setHtml(str: self.html!)
//                    self.present(newsDetailVC, animated: true, completion: nil)
//                })
//            } else {
//                DialogManager().showError()
//            }
//        })
     
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
        if tableView.tag == 0 {
            // セルを取得
            index = (indexPath as NSIndexPath).row
            
            let title = schoolNewsItems?[index].title
            let date = schoolNewsItems?[index].date
//            let uri = schoolNewsItems?[index].uri
//            let groupTitle = schoolNewsItems?[index].groupTitle
//            if title ==  "" {
//                // タイトル
//                let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTitleCell") as! NewsTitleCell
//                cell.setCell(groupTitle!)
//                cell.selectionStyle = .none
//                return cell
//            } else {
//                // 記事
//                let cell = tableView.dequeueReusableCell(withIdentifier: "NewsItemCell") as! NewsItemCell
//                cell.setCell(title!, date: date!, uri: uri!)
//                
//                return cell
//            }
            // 記事
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsItemCell") as! NewsItemCell
//            cell.setCell(title!, date: date!, uri: uri!)
            
            return cell
        }
        else
        {
            index = (indexPath as NSIndexPath).row
            
            let title = taninNewsItems?[index].title
            let date = taninNewsItems?[index].date
//            let uri = taninNewsItems?[index].uri
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsItemCell") as! NewsItemCell
//            cell.setCell(title!, date: date!, uri: uri!)
            return cell
        }
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
    
    private func loadSchoolItems() -> Array<SchoolNewsItem>{
//        let results: Results<SchoolNewsItem>! =  realm.objects(SchoolNewsItem.self)
//        let results: Results<SchoolNewsItem>
//        var items:Array<SchoolNewsItem> = Array(results)
        var items:Array<SchoolNewsItem> = []
//        if items.count == 0 {
//            let item = SchoolNewsItem()
//            item.title = "データがありません。スワイプして更新してください。"
//            items.append(item)
//        }
       return items
    }
    
    private func loadTaninItems() -> Array<TaninNewsItem>{
//        let results: Results<TaninNewsItem>! =  realm.objects(TaninNewsItem.self)
//        let results: Results<TaninNewsItem>
//        var items:Array<TaninNewsItem> = Array(results)
        var items:Array<TaninNewsItem> =  []
//        if items.count == 0 {
//            let item = TaninNewsItem()
//            item.title = "データがありません。スワイプして更新してください。"
//            items.append(item)
//        }
        
        return items
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
        refreshControl.tintColor = UIColor.gray
        //テーブルビューを引っ張ったときの呼び出しメソッドを登録する。
        refreshControl.addTarget(self, action: #selector(NewsParentViewController.refreshTable(_:)), for: .valueChanged)
        
        
        refreshControl.attributedTitle =
            NSAttributedString(string:"最終更新日時 : " +
                PreferenceManager.getLatestUpdateSchoolNews());
        
        
        
        taninRefreshControl.tintColor = UIColor.gray
        taninRefreshControl.addTarget(self, action: #selector(NewsParentViewController.refreshTable(_:)), for: .valueChanged)
        
        taninRefreshControl.attributedTitle =
            NSAttributedString(string:"最終更新日時 : " +
                PreferenceManager.getLatestUpdateTaninNews());
        
    }
    

}
