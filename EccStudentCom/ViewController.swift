//
//  ViewController.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/09/24.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import UIKit
import RealmSwift


class ViewController: UIViewController {

    private var myActivityIndicator: UIActivityIndicatorView!
    private let userId:String = "2140257"
    private let password:String = "455478"
    
    var mLastResponseHtml : String!
    
    let URL1 :String = "http://school4.ecc.ac.jp/eccstdweb/st0100/st0100_01.aspx";
    let URL2 : String = "http://school4.ecc.ac.jp/eccstdweb/st0100/st0100_01.aspx";
    let URL3 : String  = "http://school4.ecc.ac.jp/EccStdWeb/ST0100/ST0100_02.aspx";
 
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //背景色を変更
        //        self.view.backgroundColor = 0x123456
        // 背景色を黒に設定する.
        self.view.backgroundColor = UIColor.blackColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tabLoginBtn(sender: UIButton) {
        
        if !loginCheck(){
            return
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
                return
            }
            // You can print out response object
//            print("response = \(response)")
            // Print out response body
            self.mLastResponseHtml = String(data: data!, encoding: NSUTF8StringEncoding)!
//            print("responseString = \(self.mLastResponseHtml)")
            
            
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
            let  ctl00$ContentPlaceHolder1$txtUserId  : String = self.userId
            let ctl00$ContentPlaceHolder1$txtPassword :String = self.password
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
                    return
                }
                // You can print out response object
//                print("response = \(response)")
                // Print out response body
                self.mLastResponseHtml  = String(data: data!, encoding: NSUTF8StringEncoding)!
//                print("responseString2 = \( self.mLastResponseHtml )")
                
                
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
                        return
                    }
                    // You can print out response object
//                    print("response = \(response)")
                    // Print out response body
                    self.mLastResponseHtml = String(data: data!, encoding: NSUTF8StringEncoding)
//                    print("self.mLastResponseHtml = \(self.mLastResponseHtml)")
                    
                    
                    /********************* 出席率画面 ****************************/
                    //Realmをインスタンス化
                    let realm = try! Realm()
                    
                    var value:String = self.mLastResponseHtml.stringByReplacingOccurrencesOfString("\r", withString: "")
                    value = value.stringByReplacingOccurrencesOfString("\n", withString: "")
//                    print("value = \(value)")
                    let narrowHtml :String = GetValuesBase("<table class=\"GridVeiwTable\"","</table>").narrowingValues(value)
                    
                    //教科ごと
                    let results: [String] =  GetValuesBase("<tr>.*?</tr>").getGroupValues(narrowHtml)
                    
                    var item:String! = ""
                    var rowCount = 0
                    var firstRowFlg: Bool = true
                    
                    for row:String in results{
                        let col: [String] =  GetValuesBase("<td.*?</td>").getGroupValues(row)
                        
                        let saveModel = SaveModel()
                        
                        firstRowFlg = true
                        rowCount = 0
                        for td:String in col{
                            if(firstRowFlg){
                                //教科名を取得
                                saveModel.subjectName = GetValuesBase("<img(?:\\\".*?\\\"|\\'.*?\\'|[^\\'\\\"])*?>(.+?)</a>").getValues(td)
                                firstRowFlg = false
                                print("subjectName= \(saveModel.subjectName)")
                            }else{
                                item = GetValuesBase("<font(?:\\\".*?\\\"|\\'.*?\\'|[^\\'\\\"])*?>(.+?)</font>").getValues(td)
                                item = self.removeNBSP(item)
                                item = self.removePercent(item)
                                
                                switch rowCount {
                                case 1:
                                    saveModel.unit = item
                                    print("unit= \(item)")
                                case 2:
                                    saveModel.attendanceNumber = item
                                    print("attendanceNumber= \(item)")
                                case 3:
                                    saveModel.absentNumber = item
                                    print("absentNumber= \(item)")
                                case 4:
                                    saveModel.lateNumber = item
                                    print("lateNumber= \(item)")
                                case 5:
                                    saveModel.publicAbsentNumber1 = item
                                    print("publicAbsentNumber1= \(item)")
                                case 6:
                                    saveModel.publicAbsentNumber2 = item
                                    print("publicAbsentNumber2= \(item)")
                                case 7:
                                    saveModel.attendanceRate = item
                                    print("attendanceRate= \(item)")
                                case 8:
                                    saveModel.shortageNumber = item
                                    print("shortageNumber= \(item)")
                                default:
                                    print("default")
                                    
                                }
                                
                            }
                            rowCount+=1
                        }
                        
                        //データを保存
                        try! realm.write {
                            realm.add(saveModel)
                        }
                        print(" \("")")
                        print("------------------- \("")")
                        print(" \("")")
                        
                    }
                    
//                    1行目で遷移したいViewControllerがあるstoryboardを指定
//                    2行目で遷移先のViewControllerを指定
//                    3行目で遷移を行う
                    let storyboard: UIStoryboard = self.storyboard!
                    let nextView = storyboard.instantiateViewControllerWithIdentifier("MainView") as! TableViewController
                    self.presentViewController(nextView, animated: true, completion: nil)
                    
//                    print("response = \(results[0])")
                    
                    
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
        var bool: Bool = true
        
        if String(idTextField.text).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" {
            bool = false
        }
        
        if String(passwordTextField.text).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" {
            bool = false
        }
        return bool
        
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
    
    

}

