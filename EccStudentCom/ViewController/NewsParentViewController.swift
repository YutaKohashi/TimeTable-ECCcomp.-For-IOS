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
    
    var taninNewsItems: Array<TaninNewsItem>!
    var schoolNewsItems:Array<SchoolNewsItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //区切り線をなくす
//        tableView.separatorColor = UIColor(red:0.86, green:0.86, blue:0.86, alpha:1.0)
//        tableView.separatorColor = UIColor.white
        
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
        
        schoolNewsItems = loadSchoolItems()
        taninNewsItems = loadTaninItems()
        
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
        } else {
            HttpConnector().request(type: .NEWS_TEACHER, userId: PreferenceManager.getSavedId(), password: PreferenceManager.getSavedPass()) { (result) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if result {
                        //テーブルを再読み込みする。
                        self.taninNewsItems = self.loadTaninItems()
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
    
    var newsTitle:String? = ""
    var html: String? = ""
    var date:String? = ""
    //　セルタップ時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //タップしたあとハイライトを消す
        tableView.deselectRow(at: indexPath, animated: false)
        var index:NSInteger = (indexPath as NSIndexPath).row
        var uri:String? = ""
        // NewsDetailViewController へ遷移するために Segue を呼び出す
        if segmentedControl.selectedSegmentIndex  == 0 {
            if schoolNewsItems?[index].groupTitle != "" || (schoolNewsItems?[index].dummyFlg)!  {return}
            
            //インターネットに接続されていないのときはアラート表示
            if !ToolsBase().CheckReachability("google.com"){
                DialogManager().showWarningForInternet()
                refreshControl.endRefreshing()
                self.tableView.isScrollEnabled = true
                return;
            }
            
            uri = schoolNewsItems?[index].uri
            newsTitle = schoolNewsItems?[index].title
            date = schoolNewsItems?[index].date
        } else {
              if (taninNewsItems?[index].dummyFlg)!  {return}
            //インターネットに接続されていないのときはアラート表示
            if !ToolsBase().CheckReachability("google.com"){
                DialogManager().showWarningForInternet()
                refreshControl.endRefreshing()
                self.tableView.isScrollEnabled = true
                return;
            }
            uri = taninNewsItems?[index].uri
            newsTitle = taninNewsItems?[index].title
            date = taninNewsItems?[index].date
        }
        
        if(uri == nil || uri == ""){
            DialogManager().showError()
            return
        }
        DialogManager().showIndicator()
        HttpConnector().requestNewsDetail(userId: PreferenceManager.getSavedId(), password: PreferenceManager.getSavedId(), uri:uri!,callback: { (cb) in
            if(cb.bool){
                self.html = cb.string
//                self.performSegue(withIdentifier: "toNewsDetailViewController",sender: nil)
                DispatchQueue.main.async(execute: {
                     DialogManager().hideIndicator()
                    let storyboard: UIStoryboard = self.storyboard!
                    let newsDetailVC: NewsDetailViewController = storyboard.instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
                    newsDetailVC.setTitle(str: self.newsTitle!)
                    newsDetailVC.setDate(str: self.date!)
                    newsDetailVC.setHtml(str: self.html!)
                    self.present(newsDetailVC, animated: true, completion: nil)
                })
            } else {
                DialogManager().showError()
            }
        })
     
    }

    /// セルの個数を指定するデリゲートメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return schoolNewsItems.count
        } else {
            return taninNewsItems.count
        }
    }
    
    var index:NSInteger = 0
    /// セルに値を設定するデータソースメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            // セルを取得
            index = (indexPath as NSIndexPath).row
            
            let title = schoolNewsItems?[index].title
            let date = schoolNewsItems?[index].date
            let uri = schoolNewsItems?[index].uri
            let groupTitle = schoolNewsItems?[index].groupTitle
            let dummyFlg = schoolNewsItems?[index].dummyFlg
            
            if dummyFlg! {
               let cell = tableView.dequeueReusableCell(withIdentifier: "DummyCell") as! DummyCell
                cell.setCell(title!)
                cell.selectionStyle = .none
                return cell
            } else if title ==  "" {
                // タイトル
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTitleCell") as! NewsTitleCell
                cell.setCell(groupTitle!)
                cell.selectionStyle = .none
                return cell
            } else {
                // 記事
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewsItemCell") as! NewsItemCell
                cell.setCell(title!, date: date!, uri: uri!)
                
                return cell
            }
        } else {
            index = (indexPath as NSIndexPath).row
            
            let title = taninNewsItems?[index].title
            let date = taninNewsItems?[index].date
            let uri = taninNewsItems?[index].uri
            let dummyFlg = taninNewsItems?[index].dummyFlg
            
            if dummyFlg! {
                let cell =  tableView.dequeueReusableCell(withIdentifier: "DummyCell") as! DummyCell
                cell.setCell(title!)
                cell.selectionStyle = .none
                return cell
            } else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewsItemCell") as! NewsItemCell
                cell.setCell(title!, date: date!, uri: uri!)
                return cell
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // セグメントchanged
    @objc func selectedSegmentChanged(_ sender: UISegmentedControl, forEvent event: UIEvent){
//
//        let myQueue = DispatchQueue(label: "com.example.serial-queue", attributes: [.serial, .qosUtility])
        
       tableViewScrollTop()
        scrollToTop()
        self.tableView.bounces = false
        self.tableView.isScrollEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if sender.selectedSegmentIndex  == 0{
                self.tableView.reloadData()
                self.refreshControl.attributedTitle =
                    NSAttributedString(string:"最終更新日時 : " +
                        PreferenceManager.getLatestUpdateSchoolNews());
            } else {
                self.tableView.reloadData()
                self.refreshControl.attributedTitle =
                    NSAttributedString(string:"最終更新日時 : " +
                        PreferenceManager.getLatestUpdateTaninNews());
            }
            self.tableView.bounces = true
            self.tableView.isScrollEnabled = true
        }
    }
    
    private func tableViewScrollTop(){
        let offset: CGPoint = CGPoint(x: self.tableView.contentOffset.x, y: -self.tableView.contentInset.top)
        self.tableView.setContentOffset(offset, animated: false )
        index = 0
        
    }
    
    private func loadSchoolItems() -> Array<SchoolNewsItem>{
        let results: Results<SchoolNewsItem>! =  realm.objects(SchoolNewsItem.self)
        var items:Array<SchoolNewsItem> = Array(results)
        let size = items.count
        if size == 0 {
            let dummy = SchoolNewsItem()
            dummy.title = "記事がありません。更新してください。"
            dummy.dummyFlg = true
            items.append(dummy)
            let dummy1 = SchoolNewsItem()
            dummy1.dummyFlg = true
            if size < 30 {
                for _ in size..<30 {
                    items.append(dummy1)
                }
            }
        } else {
            let dummy1 = SchoolNewsItem()
            dummy1.dummyFlg = true
            if size < 15 {
                for _ in size..<15 {
                    items.append(dummy1)
                }
            }
        }
        
        
       return items
    }
    
    private func loadTaninItems() -> Array<TaninNewsItem>{
        let results: Results<TaninNewsItem>! =  realm.objects(TaninNewsItem.self)
        var items:Array<TaninNewsItem> = Array(results)
        let size = items.count
        if size == 0 {
            let dummy = TaninNewsItem()
            dummy.title = "記事がありません。更新してください。"
            dummy.dummyFlg = true
            items.append(dummy)
            
            let dummy1 = TaninNewsItem()
            dummy1.dummyFlg = true
            if size < 30 {
                for _ in size..<30 {
                    items.append(dummy1)
                }
            }
        } else {
            let dummy1 = TaninNewsItem()
            dummy1.dummyFlg = true
            if size < 15 {
                for _ in size..<15 {
                    items.append(dummy1)
                }
            }
        }
        
        
        return items
    }
    
    func scrollToTop() {
        if (self.tableView.numberOfSections > 0 ) {
            let top = NSIndexPath(row: Foundation.NSNotFound, section: 0)
            self.tableView.scrollToRow(at: top as IndexPath, at: .top, animated: true);
        }
    }
}
