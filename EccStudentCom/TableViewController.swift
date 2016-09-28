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
    var mLastResponseHtml : String!
    
    let URL1 :String = "http://school4.ecc.ac.jp/eccstdweb/st0100/st0100_01.aspx";
    let URL2 : String = "http://school4.ecc.ac.jp/eccstdweb/st0100/st0100_01.aspx";
    let URL3 : String  = "http://school4.ecc.ac.jp/EccStdWeb/ST0100/ST0100_02.aspx";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setStatusBarBackgroundColor(UIColor(red:0.00, green:0.16, blue:0.22, alpha:1.0))
        // ステータスバーのスタイル変更を促す
        self.setNeedsStatusBarAppearanceUpdate();
        
        //cellを選択不可に
        tableView.allowsSelection = false
        //区切り線をなくす
        tableView.separatorColor = UIColor.clearColor()
        
        let realm = try! Realm()
        print("realm.objects(SaveModel).count =\(realm.objects(SaveModel).count)")
       tableView.dataSource = self
        
        //リフレッシュコントロールを作成する。
        let refresh = UIRefreshControl()
        
        //インジケーターの下に表示する文字列を設定する。
        refresh.attributedTitle = NSAttributedString(string: "更新中")
        //インジケーターの色を設定する。
        refresh.tintColor = UIColor.grayColor()
        //テーブルビューを引っ張ったときの呼び出しメソッドを登録する。
        refresh.addTarget(self, action: "refreshTable:", forControlEvents: .ValueChanged)
        //テーブルビューコントローラーのプロパティにリフレッシュコントロールを設定する。
        self.tableView.addSubview(refresh)

    }
    
    //テーブルビュー引っ張り時の呼び出しメソッド
    func refreshTable(refreshControl: UIRefreshControl){
        //インターネットに接続されていないのときはアラート表示
        if !ToolsBase().CheckReachability("google.com"){
            //            ToolsBase().showToast("インターネットに接続されていません", isShortLong: true)
            self.showWarningForInternet()
             refreshControl.endRefreshing()
            return;
            
        }
        
        // ログイン画面へ遷移し必要な値を取得する
        let myUrl = NSURL(string: URL1);
        
        let request = NSMutableURLRequest(URL:myUrl!);
        
        request.HTTPMethod = "GET";// Compose a query string
        
        let postString = "";
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            if error != nil
            {
                print("error=\(error)")
                return;
            }
            
            self.mLastResponseHtml = String(data: data!, encoding: NSUTF8StringEncoding)!
            
            //正常に遷移できているか確認
            if !GetValuesBase("ログイン").ContainsCheck(self.mLastResponseHtml){
                 refreshControl.endRefreshing()
                return;
            }
            
            /*********************** ログイン画面　*****************************************
             ****************************************************************************
             ****************************************************************************/
            
            let myUrl = NSURL(string: self.URL2)
            
            let request = NSMutableURLRequest(URL:myUrl!)
            
            request.HTTPMethod = "POST"// Compose a query string
            
            
            let __LASTFOCUS = self.uriEncode(GetValuesBase("input type=\"hidden\" name=\"__LASTFOCUS\" id=\"__LASTFOCUS\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
            let __VIEWSTATE =  self.uriEncode(GetValuesBase("input type=\"hidden\" name=\"__VIEWSTATE\" id=\"__VIEWSTATE\" value=\"(.*?)\"").getValues(self.mLastResponseHtml))
            let __SCROLLPOSITIONX = self.uriEncode(GetValuesBase("input type=\"hidden\" name=\"__SCROLLPOSITIONX\" id=\"__SCROLLPOSITIONX\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
            let __SCROLLPOSITIONY = self.uriEncode(GetValuesBase("input type=\"hidden\" name=\"__SCROLLPOSITIONY\" id=\"__SCROLLPOSITIONY\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
            let __EVENTTARGET = self.uriEncode(GetValuesBase("input type=\"hidden\" name=\"__EVENTTARGET\" id=\"__EVENTTARGET\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
            let __EVENTARGUMENT = self.uriEncode(GetValuesBase("input type=\"hidden\" name=\"__EVENTARGUMENT\" id=\"__EVENTARGUMENT\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
            let __EVENTVALIDATION = self.uriEncode(GetValuesBase("input type=\"hidden\" name=\"__EVENTVALIDATION\" id=\"__EVENTVALIDATION\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
            let  ctl00$ContentPlaceHolder1$txtUserId  : String = SaveManager().getSavedId()
            let ctl00$ContentPlaceHolder1$txtPassword :String = SaveManager().getSavedPass()
            let  ctl00$ContentPlaceHolder1$btnLogin : String = self.uriEncode("ログイン")
            //
            let postString :String = "__LASTFOCUS=" + __LASTFOCUS + "&__VIEWSTATE=" + __VIEWSTATE + "&__SCROLLPOSITIONX=" +  __SCROLLPOSITIONX + "&__SCROLLPOSITIONY=" +  __SCROLLPOSITIONY + "&__EVENTTARGET=" + __EVENTTARGET + "&__EVENTARGUMENT=" + __EVENTARGUMENT + "&__EVENTVALIDATION=" + __EVENTVALIDATION + "&ctl00%24ContentPlaceHolder1%24txtUserId=" + ctl00$ContentPlaceHolder1$txtUserId + "&ctl00%24ContentPlaceHolder1%24txtPassword=" + ctl00$ContentPlaceHolder1$txtPassword + "&ctl00%24ContentPlaceHolder1%24btnLogin=" + ctl00$ContentPlaceHolder1$btnLogin;
            
            request.addValue("http://school4.ecc.ac.jp/eccstdweb/st0100/st0100_01.aspx", forHTTPHeaderField: "Referer")
            request.addValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87", forHTTPHeaderField: "User-Agent")
            request.addValue("text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8", forHTTPHeaderField: "Accept")
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
            //            print("postString = \(postString)")
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in
                if error != nil
                {
                    print("error=\(error)")
                    return;
                }
                
                self.mLastResponseHtml  = String(data: data!, encoding: NSUTF8StringEncoding)!
                
                //正常に遷移できているか確認
                if !GetValuesBase("ログオフ").ContainsCheck(self.mLastResponseHtml){
                    print("error=ログインできませんでした")
                    refreshControl.endRefreshing()
                    return;
                }
                
                /********************* ログイン ****************************
                 *********************************************************/
                
                let myUrl = NSURL(string: self.URL3);
                let request = NSMutableURLRequest(URL:myUrl!);
                
                request.HTTPMethod = "POST";// Compose a query string
                
                let  __EVENTTARGET2 = self.uriEncode("ctl00$btnSyuseki")
                let  __EVENTARGUMENT2 = self.uriEncode(GetValuesBase("input type=\"hidden\" name=\"__EVENTARGUMENT\" id=\"__EVENTARGUMENT\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
                let __VIEWSTATE2 = self.uriEncode(GetValuesBase("input type=\"hidden\" name=\"__VIEWSTATE\" id=\"__VIEWSTATE\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
                let __SCROLLPOSITIONX2 = self.uriEncode(GetValuesBase("input type=\"hidden\" name=\"__SCROLLPOSITIONX\" id=\"__SCROLLPOSITIONX\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
                let __SCROLLPOSITIONY2 = self.uriEncode(GetValuesBase("input type=\"hidden\" name=\"__SCROLLPOSITIONY\" id=\"__SCROLLPOSITIONY\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
                let __EVENTVALIDATION2 = self.uriEncode(GetValuesBase("input type=\"hidden\" name=\"__EVENTVALIDATION\" id=\"__EVENTVALIDATION\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
                let ctl00$txtWindowOpenFlg = self.uriEncode(GetValuesBase("input type=\"hidden\" name=\"ctl00\\$txtWindowOpenFlg\" id=\"ctl00_txtWindowOpenFlg\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
                let ctl00$txtWindowOpenUrl = self.uriEncode(GetValuesBase("input type=\"hidden\" name=\"ctl00\\$txtWindowOpenUrl\" id=\"ctl00_txtWindowOpenUrl\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
                let ctl00$txtWindowOpenName = self.uriEncode(GetValuesBase("input type=\"hidden\" name=\"ctl00\\$txtWindowOpenName\" id=\"ctl00_txtWindowOpenName\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
                let ctl00$txtWindowOpenStyle = self.uriEncode(GetValuesBase("input type=\"hidden\" name=\"ctl00\\$txtWindowOpenStyle\" id=\"ctl00_txtWindowOpenStyle\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
                let ctl00$txtSearchKey = self.uriEncode(GetValuesBase("input type=\"hidden\" name=\"ctl00\\$txtSearchKey\" id=\"ctl00_txtSearchKey\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
                let ctl00$txtParamKey = self.uriEncode(GetValuesBase("input type=\"hidden\" name=\"ctl00\\$txtParamKey\" id=\"ctl00_txtParamKey\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
                let ctl00$txtCssFileName = self.uriEncode(GetValuesBase("input type=\"hidden\" name=\"ctl00\\$txtCssFileName\" id=\"ctl00_txtCssFileName\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
                let ctl00$txtHeadTitle = "";
                
                let postString = "__EVENTTARGET=" + __EVENTTARGET2 + "&__EVENTARGUMENT=" + __EVENTARGUMENT2 + "&__VIEWSTATE=" + __VIEWSTATE2 + "&__SCROLLPOSITIONX=" + __SCROLLPOSITIONX2 + "&__SCROLLPOSITIONY=" + __SCROLLPOSITIONY2 + "&__EVENTVALIDATION=" + __EVENTVALIDATION2 + "&ctl00%24txtWindowOpenFlg=" + ctl00$txtWindowOpenFlg + "&ctl00%24txtWindowOpenUrl=" + ctl00$txtWindowOpenUrl + "&ctl00%24txtWindowOpenName=" + ctl00$txtWindowOpenName + "&ctl00%24txtWindowOpenStyle=" + ctl00$txtWindowOpenStyle + "&ctl00%24txtSearchKey=" + ctl00$txtSearchKey + "&ctl00%24txtParamKey=" + ctl00$txtParamKey + "&ctl00%24txtCssFileName=" + ctl00$txtCssFileName + "&ctl00%24txtHeadTitle=" + ctl00$txtHeadTitle;
                
                request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
                
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                    data, response, error in
                    if error != nil
                    {
                        print("error=\(error)")
                        return;
                    }
                    
                    self.mLastResponseHtml = String(data: data!, encoding: NSUTF8StringEncoding)
                    
                    //正常に遷移できているか確認
                    if !GetValuesBase("教科名").ContainsCheck(self.mLastResponseHtml){
                        refreshControl.endRefreshing()
                        return;
                    }
                    
                    /********************* 出席率画面 ****************************/
                    
                    //Realmをインスタンス化
                    let realm = try! Realm()
                    //一度データを削除
                    try! realm.write {
                        realm.deleteAll()
                    }
                    //出席率をデータベースへ保存
                    let saveManager = SaveManager()
                    saveManager.saveAttendanceRate(realm, mLastResponseHtml: self.mLastResponseHtml)
                    
                    //テーブルを再読み込みする。
                    self.tableView.reloadData()
                    //pullToRefresh終了
                    refreshControl.endRefreshing()
                    
                    /*************************************************************/
                }
                task.resume()
                /************************************************************************************
                 ************************************************************************************/
            }
            task.resume()
            /************************************************************************************
             ************************************************************************************
             ************************************************************************************/
        }
        task.resume()
    }
    
    @IBAction func logoutBtn(sender: UIBarButtonItem) {
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "確認", message: "ログアウトしてもよろしいですか？", preferredStyle:   UIAlertControllerStyle.Alert)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
            let realm = try! Realm()
            try! realm.write {
                realm.deleteAll()
            }
            
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setBool(false, forKey: "login")
            ud.synchronize()
            
            //保存されていたpassIdを削除
            SaveManager().removeSavedIdPass()
            
            dispatch_async(dispatch_get_main_queue(), {
                //View controller code
                let storyboard: UIStoryboard = self.storyboard!
                let nextView = storyboard.instantiateViewControllerWithIdentifier("LoginView") as! ViewController
                self.presentViewController(nextView, animated: true, completion: nil)
            })
        })
        
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        presentViewController(alert, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        // DBファイルのfileURLを取得
        if let fileURL = Realm.Configuration.defaultConfiguration.fileURL {
            try! NSFileManager.defaultManager().removeItemAtURL(fileURL)
        }
    }
    
    /// セルの個数を指定するデリゲートメソッド
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        print("realm.objects(SaveModel).count =\(realm.objects(SaveModel).count)")
        return realm.objects(SaveModel).count
//        return array.count
    }
    
    /// セルに値を設定するデータソースメソッド
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // セルを取得
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomCell") as! CustomTableViewCell
        
        let realm = try! Realm()
        let saveModel = realm.objects(SaveModel)
        
        cell.setCell(saveModel[indexPath.row].subjectName,unitNum: saveModel[indexPath.row].unit,attendanceNum: saveModel[indexPath.row].attendanceNumber,absentNum: saveModel[indexPath.row].absentNumber,lateNum: saveModel[indexPath.row].lateNumber,pubAbsentnum1: saveModel[indexPath.row].publicAbsentNumber1,pubAbsentnum2: saveModel[indexPath.row].publicAbsentNumber2,attendanceRateNum: saveModel[indexPath.row].attendanceRate,shortageNum: saveModel[indexPath.row].shortageNumber)
        
        return cell
        
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard  let statusBar = UIApplication.sharedApplication().valueForKey("statusBarWindow")?.valueForKey("statusBar") as? UIView else {
            return
        }
        
        statusBar.backgroundColor = color
    }
    
    override func prefersStatusBarHidden() -> Bool {
        // trueの場合はステータスバー非表示
        return false;
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        // ステータスバーを白くする
        return UIStatusBarStyle.LightContent;
    }
    //URLエンコードを行うメソッド
    func uriEncode(str: String) -> String {
        let allowedCharacterSet = NSMutableCharacterSet.alphanumericCharacterSet()
        allowedCharacterSet.addCharactersInString("-._~")
        return str.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet)!
    }
    
    func removePercent(str:String) -> String{
        return str.stringByReplacingOccurrencesOfString("%", withString: "")
    }
    func removeNBSP(str:String)->String{
        return str.stringByReplacingOccurrencesOfString("&nbsp;", withString: "0")
    }
    
    func showWarningForInternet(){
        KRProgressHUD.showWarning(progressHUDStyle: .WhiteColor,maskType: .Black,message:"インターネット未接続")
        
        let sec:Double = 4
        let delay = sec * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            KRProgressHUD.dismiss()
        })
    }
}
