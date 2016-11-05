//
//  HttpRequest.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/10/30.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import KRProgressHUD
import MetalKit


class HttpRequestBase{
    
    var mLastResponseHtml : String = ""
    var requestResultBool:Bool = false
    
    let URL1 :String = "http://school4.ecc.ac.jp/eccstdweb/st0100/st0100_01.aspx";
    let URL2 : String = "http://school4.ecc.ac.jp/eccstdweb/st0100/st0100_01.aspx";
    let URL3 : String  = "http://school4.ecc.ac.jp/EccStdWeb/ST0100/ST0100_02.aspx";
    
    //StudentCommunication
    let URL4:String = "http://comp2.ecc.ac.jp/sutinfo/login"        //ログインページ
    let URL5:String = "http://comp2.ecc.ac.jp/sutinfo/auth/attempt" //実ログイン
    
    
    init(){
        mLastResponseHtml = ""
        requestResultBool = false
    }
    

    // MARK:時間割を取得するメソッド（クロージャあり）
    func requestTimeTable(userId :String,password:String,callback: @escaping (CallBackClass) -> Void) -> Void {
        //コールバックインスタンス
        var callbackClass = CallBackClass()
        
        var request = URLRequest(url: URL(string: URL4)!)
        request.httpMethod = "GET";
        let postString = "";
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if error != nil
            {
                print("error=\(error)")
                self.requestResultBool = false
                callbackClass.bool = self.requestResultBool
                callback(callbackClass)
                return;
            }
            
            self.mLastResponseHtml = String(data: data!, encoding: String.Encoding.utf8)!
            
            //正常に遷移できているか確認
            if !GetValuesBase("ログイン").ContainsCheck(self.mLastResponseHtml){
                self.requestResultBool = false
                callbackClass.bool = self.requestResultBool
                callback(callbackClass)
                return;
            }
            
            /*********************** ログイン画面　*****************************************
             ****************************************************************************
             ****************************************************************************/
            
            var request = URLRequest(url: URL(string: self.URL5)!)
            request.httpMethod = "POST"
            
            let _token = GetValuesBase().uriEncode(GetValuesBase("input name=\"_token\" type=\"hidden\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
            //let userid =  idTextField.text!
            //let password = passwordTextField.text!
         
            //
            let postString :String = "_token=" + _token + "&userid=" + userId + "&password=" +  password
            
            request.addValue(self.URL4, forHTTPHeaderField: "Referer")
            request.addValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87", forHTTPHeaderField: "User-Agent")
            request.addValue("text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8", forHTTPHeaderField: "Accept")
            request.httpBody = postString.data(using: String.Encoding.utf8);
            //            print("postString = \(postString)")
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                if error != nil
                {
                    print("error=\(error)")
                    self.requestResultBool = false
                    callbackClass.bool = self.requestResultBool
                    callback(callbackClass)
                    return;
                }
                
                self.mLastResponseHtml  = String(data: data!, encoding: String.Encoding.utf8)!
                
                //正常に遷移できているか確認
                if !GetValuesBase("ログアウト").ContainsCheck(self.mLastResponseHtml){
                    self.requestResultBool = false
                    callbackClass.bool = self.requestResultBool
                    callback(callbackClass)
                    return;
                }
                
                /********************* ログイン ****************************
                 *********************************************************/
                
                print("mLastResponseHtml  :  " + self.mLastResponseHtml)
                
                self.requestResultBool = true
                callbackClass.string = self.mLastResponseHtml
                callbackClass.bool = self.requestResultBool
                callback(callbackClass)
                
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
  
    // MARK:出席率関連を取得するメソッド (クロージャあり)
    // CallBackClasを返す ()
    func reequestAttendanseRate(userId :String,password:String,callback: @escaping (CallBackClass) -> Void) -> Void {
        
        //コールバッククラスインスタンス化
        var callBackClass = CallBackClass()
        
        var request = URLRequest(url: URL(string: URL1)!)
        request.httpMethod = "GET";
        let postString = "";
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if error != nil
            {
                print("error=\(error)")
                self.requestResultBool = false
                callBackClass.bool = self.requestResultBool
                callback(callBackClass)
                return;
            }
            
            self.mLastResponseHtml = String(data: data!, encoding: String.Encoding.utf8)!
            
            //正常に遷移できているか確認
            if !GetValuesBase("ログイン").ContainsCheck(self.mLastResponseHtml){
                self.requestResultBool = false
                callBackClass.bool = self.requestResultBool
                callback(callBackClass)
                return;
            }
            
            /*********************** ログイン画面　*****************************************
             ****************************************************************************
             ****************************************************************************/
            
            var request = URLRequest(url: URL(string: self.URL2)!)
            request.httpMethod = "POST"
            
            let __LASTFOCUS = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"__LASTFOCUS\" id=\"__LASTFOCUS\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
            let __VIEWSTATE =  GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"__VIEWSTATE\" id=\"__VIEWSTATE\" value=\"(.*?)\"").getValues(self.mLastResponseHtml))
            let __SCROLLPOSITIONX = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"__SCROLLPOSITIONX\" id=\"__SCROLLPOSITIONX\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
            let __SCROLLPOSITIONY = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"__SCROLLPOSITIONY\" id=\"__SCROLLPOSITIONY\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
            let __EVENTTARGET = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"__EVENTTARGET\" id=\"__EVENTTARGET\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
            let __EVENTARGUMENT = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"__EVENTARGUMENT\" id=\"__EVENTARGUMENT\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
            let __EVENTVALIDATION = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"__EVENTVALIDATION\" id=\"__EVENTVALIDATION\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
            let  ctl00$ContentPlaceHolder1$txtUserId  : String = userId
            let ctl00$ContentPlaceHolder1$txtPassword :String = password
            let  ctl00$ContentPlaceHolder1$btnLogin : String = GetValuesBase().uriEncode("ログイン")
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
                    print("error=\(error)")
                    self.requestResultBool = false
                    callBackClass.bool = self.requestResultBool
                    callback(callBackClass)
                    return;
                }
                
                self.mLastResponseHtml  = String(data: data!, encoding: String.Encoding.utf8)!
                
                //正常に遷移できているか確認
                if !GetValuesBase("ログオフ").ContainsCheck(self.mLastResponseHtml){
                    self.requestResultBool = false
                    callBackClass.bool = self.requestResultBool
                    callback(callBackClass)
                    return;
                }
                
                /********************* ログイン ****************************
                 *********************************************************/
                
                var request = URLRequest(url: URL(string: self.URL3)!)
                request.httpMethod = "POST";
                
                let  __EVENTTARGET2 = GetValuesBase().uriEncode("ctl00$btnSyuseki")
                let  __EVENTARGUMENT2 = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"__EVENTARGUMENT\" id=\"__EVENTARGUMENT\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
                let __VIEWSTATE2 = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"__VIEWSTATE\" id=\"__VIEWSTATE\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
                let __SCROLLPOSITIONX2 = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"__SCROLLPOSITIONX\" id=\"__SCROLLPOSITIONX\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
                let __SCROLLPOSITIONY2 = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"__SCROLLPOSITIONY\" id=\"__SCROLLPOSITIONY\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
                let __EVENTVALIDATION2 = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"__EVENTVALIDATION\" id=\"__EVENTVALIDATION\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
                let ctl00$txtWindowOpenFlg = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"ctl00\\$txtWindowOpenFlg\" id=\"ctl00_txtWindowOpenFlg\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
                let ctl00$txtWindowOpenUrl = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"ctl00\\$txtWindowOpenUrl\" id=\"ctl00_txtWindowOpenUrl\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
                let ctl00$txtWindowOpenName = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"ctl00\\$txtWindowOpenName\" id=\"ctl00_txtWindowOpenName\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
                let ctl00$txtWindowOpenStyle = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"ctl00\\$txtWindowOpenStyle\" id=\"ctl00_txtWindowOpenStyle\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
                let ctl00$txtSearchKey = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"ctl00\\$txtSearchKey\" id=\"ctl00_txtSearchKey\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
                let ctl00$txtParamKey = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"ctl00\\$txtParamKey\" id=\"ctl00_txtParamKey\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
                let ctl00$txtCssFileName = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"ctl00\\$txtCssFileName\" id=\"ctl00_txtCssFileName\" value=\"(.+?)\"").getValues(self.mLastResponseHtml))
                let ctl00$txtHeadTitle = "";
                
                let postString = "__EVENTTARGET=" + __EVENTTARGET2 + "&__EVENTARGUMENT=" + __EVENTARGUMENT2 + "&__VIEWSTATE=" + __VIEWSTATE2 + "&__SCROLLPOSITIONX=" + __SCROLLPOSITIONX2 + "&__SCROLLPOSITIONY=" + __SCROLLPOSITIONY2 + "&__EVENTVALIDATION=" + __EVENTVALIDATION2 + "&ctl00%24txtWindowOpenFlg=" + ctl00$txtWindowOpenFlg + "&ctl00%24txtWindowOpenUrl=" + ctl00$txtWindowOpenUrl + "&ctl00%24txtWindowOpenName=" + ctl00$txtWindowOpenName + "&ctl00%24txtWindowOpenStyle=" + ctl00$txtWindowOpenStyle + "&ctl00%24txtSearchKey=" + ctl00$txtSearchKey + "&ctl00%24txtParamKey=" + ctl00$txtParamKey + "&ctl00%24txtCssFileName=" + ctl00$txtCssFileName + "&ctl00%24txtHeadTitle=" + ctl00$txtHeadTitle;
                
                request.httpBody = postString.data(using: String.Encoding.utf8);
                
                let task = URLSession.shared.dataTask(with: request) {
                    data, response, error in
                    if error != nil
                    {
                        print("error=\(error)")
                        self.requestResultBool = false
                        callBackClass.bool = self.requestResultBool
                        callback(callBackClass)
                        return;
                    }
                    
                    self.mLastResponseHtml = String(data: data!, encoding: String.Encoding.utf8)!
                    
                    //正常に遷移できているか確認
                    if !GetValuesBase("教科名").ContainsCheck(self.mLastResponseHtml){
                        self.requestResultBool = false
                        callBackClass.bool = self.requestResultBool
                        callback(callBackClass)
                        return;
                    }
                    
                    /********************* 出席率画面 ****************************/
                  
                    self.requestResultBool = true
                    callBackClass.bool = self.requestResultBool
                    callBackClass.string = self.mLastResponseHtml
                    callback(callBackClass)
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
    
    
    func getTeacherName(html:String) -> [String]{
        var result = [String]()
        
        let urls: [String] =  GetValuesBase("<li class=\"letter\"><a href=\"(.+?)\">投書</a>").getGroupValues(html)
        
        var index : uint = 0
        for url:String in urls{
            
            var urlStr = GetValuesBase("<li class=\"letter\"><a href=\"(.+?)\">投書</a>").getValues(url)
            
            self.getTeacherNameRequest(url: urlStr) { (teacherName) in
                result.append(teacherName)
                index += 1
            }
           
        }
        return result
    }

    
    func getTeacherNameRequest(url:String,callback: @escaping (String) -> Void) -> Void {
        var teacherName:String = ""
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET";
        let postString = "";
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if error != nil
            {
                DialogManager().hideIndicator()
                let sec:Double = 1
                let delay = sec * Double(NSEC_PER_SEC)
                let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: time, execute: {
                    DialogManager().showError()
                })
                print("error=\(error)")
                callback(teacherName)
                return;
            }
            var result = String(data: data!, encoding: String.Encoding.utf8)!
            result = GetValuesBase().removeLineCodeN(result)
            result = GetValuesBase().removeLineCodeR(result)
            result = GetValuesBase().removeTabCode(result)
            teacherName = GetValuesBase("<h3>受信者</h3> <p>(.+?)</p>").getValues(result)
            
            
            callback(teacherName)
        }
        task.resume()
    }

}
