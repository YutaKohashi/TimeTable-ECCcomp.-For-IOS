//
//  ViewController.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/09/24.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import UIKit
import RealmSwift
import KRProgressHUD
import MetalKit


class ViewController: UIViewController, UITextFieldDelegate {

    fileprivate let userId:String = "2140257"
    fileprivate let password:String = "455478"
//    
//    fileprivate var ActivityIndicator: MKActivityIndicator!
    
    var mLastResponseHtml : String!
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
   
    @IBOutlet weak var loginButton: UIButton!
    
    let URL1 :String = "http://school4.ecc.ac.jp/eccstdweb/st0100/st0100_01.aspx";
    let URL2 : String = "http://school4.ecc.ac.jp/eccstdweb/st0100/st0100_01.aspx";
    let URL3 : String  = "http://school4.ecc.ac.jp/EccStdWeb/ST0100/ST0100_02.aspx";
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStatusBarBackgroundColor(color: UIColor(red:0.00, green:0.29, blue:0.39, alpha:1.0))
        // ステータスバーのスタイル変更を促す
        self.setNeedsStatusBarAppearanceUpdate();
        
        //パスワード入力フィールドをpasswordmodeに
        passwordTextField.isSecureTextEntry = true
        
        self.passwordTextField.delegate = self;
        
        //ログインボタン設定
        loginButton.layer.cornerRadius = 10    //角の設定
        loginButton.layer.masksToBounds = true
//        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tabLoginBtn(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        
        //インターネットに接続されていないのときはアラート表示
        if !ToolsBase().CheckReachability("google.com"){
//            ToolsBase().showToast("インターネットに接続されていません", isShortLong: true)
            self.showWarningForInternet()
            return;
        }
        
        //テキストフィールドチェック
        if self.checkTextFiled(){
            self.showWarningForTextField()
            return;
        }
        
        //プログレスダイアログ表示
        showIndicator()
        
        // ログイン画面へ遷移し必要な値を取得する
        //let myUrl = URL(string: URL1);
        //let request = NSMutableURLRequest(url:myUrl!);
        //var request = URLRequest(url: URL(string: URL1)!)
        var request = URLRequest(url: URL(string: URL1)!)
        request.httpMethod = "GET";
        let postString = "";
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if error != nil
            {
                 self.hideIndicator()
                let sec:Double = 1
                let delay = sec * Double(NSEC_PER_SEC)
                let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: time, execute: {
                    self.showError()
                })
                print("error=\(error)")
                return;
            }
            
            self.mLastResponseHtml = String(data: data!, encoding: String.Encoding.utf8)!
            
            //正常に遷移できているか確認
            if !GetValuesBase("ログイン").ContainsCheck(self.mLastResponseHtml){
                 self.hideIndicator()
                let sec:Double = 1
                let delay = sec * Double(NSEC_PER_SEC)
                let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: time, execute: {
                    self.showError()
                })
                return;
            }
            
            /*********************** ログイン画面　*****************************************
             ****************************************************************************
             ****************************************************************************/
            
            //let myUrl = URL(string: self.URL2)
            //let request = NSMutableURLRequest(url:myUrl!)
            var request = URLRequest(url: URL(string: self.URL2)!)
            request.httpMethod = "POST"
            
            let __LASTFOCUS = self.uriEncode(GetValuesBase("input type=\"hidden\" name=\"__LASTFOCUS\" id=\"__LASTFOCUS\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
            let __VIEWSTATE =  self.uriEncode(GetValuesBase("input type=\"hidden\" name=\"__VIEWSTATE\" id=\"__VIEWSTATE\" value=\"(.*?)\"").getValues(self.mLastResponseHtml))
            let __SCROLLPOSITIONX = self.uriEncode(GetValuesBase("input type=\"hidden\" name=\"__SCROLLPOSITIONX\" id=\"__SCROLLPOSITIONX\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
            let __SCROLLPOSITIONY = self.uriEncode(GetValuesBase("input type=\"hidden\" name=\"__SCROLLPOSITIONY\" id=\"__SCROLLPOSITIONY\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
            let __EVENTTARGET = self.uriEncode(GetValuesBase("input type=\"hidden\" name=\"__EVENTTARGET\" id=\"__EVENTTARGET\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
            let __EVENTARGUMENT = self.uriEncode(GetValuesBase("input type=\"hidden\" name=\"__EVENTARGUMENT\" id=\"__EVENTARGUMENT\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
            let __EVENTVALIDATION = self.uriEncode(GetValuesBase("input type=\"hidden\" name=\"__EVENTVALIDATION\" id=\"__EVENTVALIDATION\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
            let  ctl00$ContentPlaceHolder1$txtUserId  : String = self.idTextField.text!
            let ctl00$ContentPlaceHolder1$txtPassword :String = self.passwordTextField.text!
            let  ctl00$ContentPlaceHolder1$btnLogin : String = self.uriEncode("ログイン")
            //
            let postString :String = "__LASTFOCUS=" + __LASTFOCUS + "&__VIEWSTATE=" + __VIEWSTATE + "&__SCROLLPOSITIONX=" +  __SCROLLPOSITIONX + "&__SCROLLPOSITIONY=" +  __SCROLLPOSITIONY + "&__EVENTTARGET=" + __EVENTTARGET + "&__EVENTARGUMENT=" + __EVENTARGUMENT + "&__EVENTVALIDATION=" + __EVENTVALIDATION + "&ctl00%24ContentPlaceHolder1%24txtUserId=" + ctl00$ContentPlaceHolder1$txtUserId + "&ctl00%24ContentPlaceHolder1%24txtPassword=" + ctl00$ContentPlaceHolder1$txtPassword + "&ctl00%24ContentPlaceHolder1%24btnLogin=" + ctl00$ContentPlaceHolder1$btnLogin;
            
            request.addValue("http://school4.ecc.ac.jp/eccstdweb/st0100/st0100_01.aspx", forHTTPHeaderField: "Referer")
            request.addValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87", forHTTPHeaderField: "User-Agent")
            request.addValue("text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8", forHTTPHeaderField: "Accept")
            request.httpBody = postString.data(using: String.Encoding.utf8);
//            print("postString = \(postString)")
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                if error != nil
                {
                     self.hideIndicator()
                    self.showError()
                    print("error=\(error)")
                    return;
                }
                
                self.mLastResponseHtml  = String(data: data!, encoding: String.Encoding.utf8)!
                
                //正常に遷移できているか確認
                if !GetValuesBase("ログオフ").ContainsCheck(self.mLastResponseHtml){
                     self.hideIndicator()
                    let sec:Double = 1
                    let delay = sec * Double(NSEC_PER_SEC)
                    let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: time, execute: {
                        self.showError()
                    })
                    return;
                }
                
                /********************* ログイン ****************************
                 *********************************************************/
                
                //let myUrl = URL(string: self.URL3);
                //let request = NSMutableURLRequest(url:myUrl!);
                var request = URLRequest(url: URL(string: self.URL3)!)
                request.httpMethod = "POST";
                
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
                
                request.httpBody = postString.data(using: String.Encoding.utf8);
                
                let task = URLSession.shared.dataTask(with: request) {
                    data, response, error in
                    if error != nil
                    {
                         self.hideIndicator()
                        let sec:Double = 1
                        let delay = sec * Double(NSEC_PER_SEC)
                        let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                        DispatchQueue.main.asyncAfter(deadline: time, execute: {
                            self.showError()
                        })
                        print("error=\(error)")
                        return;
                    }
                    
                    self.mLastResponseHtml = String(data: data!, encoding: String.Encoding.utf8)
                    
                    //正常に遷移できているか確認
                    if !GetValuesBase("教科名").ContainsCheck(self.mLastResponseHtml){
                         self.hideIndicator()
                        let sec:Double = 1
                        let delay = sec * Double(NSEC_PER_SEC)
                        let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                        DispatchQueue.main.asyncAfter(deadline: time, execute: {
                            self.showError()
                        })
                        return;
                    }
                    
                    /********************* 出席率画面 ****************************/
                    
                    //Realmをインスタンス化
                    let realm = try! Realm()
                    
                    //出席率をデータベースへ保存
                    let saveManager = SaveManager()
                    saveManager.saveAttendanceRate(realm, mLastResponseHtml: self.mLastResponseHtml)
                    
                    //ダイアログ非表示
                    self.hideIndicator()

                    //ログインしたことを保存
                    saveManager.saveLoginState(true)
                    //passIdを保存
                    saveManager.saveIdPass(self.idTextField.text!, pass: self.passwordTextField.text!)
                    
                    DispatchQueue.main.async(execute: {
                        
                        //成功ダイアログ表示
                        self.showSuccess()
                        
                        //出席率表示画面へ遷移
                        let storyboard: UIStoryboard = self.storyboard!
                        //let nextView = storyboard.instantiateViewController(withIdentifier: "MainView") as! TableViewController
                        let nextView = storyboard.instantiateViewController(withIdentifier: "MainView") as! UITabBarController
                        self.present(nextView, animated: true, completion: nil)

                    })
                    
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
    
    //テキストフィールドに値が入力されているか
    func loginCheck() -> Bool{
        let ud = UserDefaults.standard
        let bool : Bool = ud.bool(forKey: "login") 
        
        return bool
    }
    
    override var prefersStatusBarHidden : Bool {
        // trueの場合はステータスバー非表示
        return false;
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        // ステータスバーを白くする
        return UIStatusBarStyle.lightContent;
    }
   
    //ログイン時に表示するダイアログ
    func showIndicator(){
        KRProgressHUD.show(progressHUDStyle: .white, maskType: .black, activityIndicatorStyle: .color(UIColor.blue, UIColor.blue),message: "お待ち下さい")
    }
    
    func hideIndicator(){
        KRProgressHUD.dismiss()
    }
    
    func showError(){
        KRProgressHUD.showError(progressHUDStyle: .whiteColor,maskType: .black)
        
        let sec:Double = 4
        let delay = sec * Double(NSEC_PER_SEC)
        let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            KRProgressHUD.dismiss()
        })
    }
    
    func showSuccess(){
        KRProgressHUD.showSuccess(progressHUDStyle: .whiteColor,maskType: .black)
        
        let sec:Double = 3
        let delay = sec * Double(NSEC_PER_SEC)
        let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            KRProgressHUD.dismiss()
        })
    }
    
    func showWarningForInternet(){
        KRProgressHUD.showWarning(progressHUDStyle: .whiteColor,maskType: .black,message:"インターネット未接続")
        
        let sec:Double = 4
        let delay = sec * Double(NSEC_PER_SEC)
        let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            KRProgressHUD.dismiss()
        })
    }
    
    func showWarningForTextField(){
        KRProgressHUD.showWarning(progressHUDStyle: .whiteColor,maskType: .black,message:"未入力")
        
        let sec:Double = 4
        let delay = sec * Double(NSEC_PER_SEC)
        let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            KRProgressHUD.dismiss()
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //テキストフィールドチェック
    func checkTextFiled() -> Bool{
        var flg:Bool = false
         let num = idTextField.text?.characters.count
        if num == 0{
            flg = true
        }
        let num2 = passwordTextField.text?.characters.count
        if num2 == 0{
            flg = true
        }
        return flg
    }
    
    //URLエンコードを行うメソッド
    func uriEncode(_ str: String) -> String {
        let allowedCharacterSet = NSMutableCharacterSet.alphanumeric()
        allowedCharacterSet.addCharacters(in: "-._~")
        return str.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet as CharacterSet)!
    }
    
    //％を取り除く
    func removePercent(_ str:String) -> String{
        return str.replacingOccurrences(of: "%", with: "")
    }
    
    //&nbspを取り除く
    func removeNBSP(_ str:String)->String{
        return str.replacingOccurrences(of: "&nbsp;", with: "0")
    }
    
   // func setStatusBarBackgroundColor(_ color: UIColor) {
        
     //   guard  let statusBar = (UIApplication.shared.value(forKey: "statusBarWindow") as AnyObject).value(forKey: "statusBar") as? UIView else {
     //       return
     //   }
   //  //   statusBar.backgroundColor = color
//    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color
    }

}

