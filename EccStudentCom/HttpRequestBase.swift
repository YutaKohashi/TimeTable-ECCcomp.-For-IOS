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
    
    let URL1 : String = "http://school4.ecc.ac.jp/eccstdweb/st0100/st0100_01.aspx";
    let URL2 : String = "http://school4.ecc.ac.jp/eccstdweb/st0100/st0100_01.aspx";
    let URL3 : String = "http://school4.ecc.ac.jp/EccStdWeb/ST0100/ST0100_02.aspx";
    
    //StudentCommunication
    let URL4:String = "http://comp2.ecc.ac.jp/sutinfo/login"        //ログインページ
    let URL5:String = "http://comp2.ecc.ac.jp/sutinfo/auth/attempt" //実ログイン
    
    // MARK:時間割を取得するメソッド（クロージャあり）
    func requestTimeTable(userId :String,password:String,callback: @escaping (CallBackClass) -> Void) -> Void {
        // レスポンスを格納する変数
        var mLastResponseHtml : String = ""
        var requestResultBool:Bool = false
        
        //コールバックインスタンス
        let callbackClass = CallBackClass()
        
        let request:URLRequest = self.createURLRequest(method: "GET",
                                                        uri:  self.URL4,
                                                        requestBody: "",
                                                        referer: "http://google.co.jp",
                                                        header:true)
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if error != nil
            {
                print("error=\(error)")
                callbackClass.bool = requestResultBool
                callback(callbackClass)
                return;
            }
            
            mLastResponseHtml = String(data: data!, encoding: String.Encoding.utf8)!
            
            //正常に遷移できているか確認
            if !GetValuesBase("ログイン").ContainsCheck(mLastResponseHtml){
                callbackClass.bool = requestResultBool
                callback(callbackClass)
                return;
            }
            
            // リクエストボディ作成
            let requestBody :String = self.createPostDataForEscLogin(userId: userId,passwrod: password,mLastResponseHtml: mLastResponseHtml)
            let request :URLRequest = self.createURLRequest(method: "POST",
                                                            uri:  self.URL5,
                                                            requestBody: requestBody,
                                                            referer: self.URL4,
                                                            header:true)
            
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                if error != nil
                {
                    print("error=\(error)")
                    callbackClass.bool = requestResultBool
                    callback(callbackClass)
                    return;
                }
                
                mLastResponseHtml  = String(data: data!, encoding: String.Encoding.utf8)!
                
                //正常に遷移できているか確認
                if !GetValuesBase("ログアウト").ContainsCheck(mLastResponseHtml){
                    callbackClass.bool = requestResultBool
                    callback(callbackClass)
                    return;
                }
                
                // 成功時
                requestResultBool = true
                callbackClass.string = mLastResponseHtml
                callbackClass.bool = requestResultBool
                callback(callbackClass)
            }
            task.resume()
        }
        task.resume()
    }

    
    // MARK:出席率関連を取得するメソッド (クロージャあり)CallBackClasを返す ()
    func reequestAttendanseRate(userId :String,password:String,callback: @escaping (CallBackClass) -> Void) -> Void {
        // レスポンスを格納する変数
        var mLastResponseHtml : String = ""
        var requestResultBool:Bool = false
        
        //コールバッククラスインスタンス化
        let callBackClass = CallBackClass()
        
        let request = self.createURLRequest(method: "GET",
                                            uri:  self.URL1,
                                            requestBody: "",
                                            referer: "http://google.co.jp",
                                            header:true)
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if error != nil
            {
                print("error=\(error)")
                requestResultBool = false
                callBackClass.bool = requestResultBool
                callback(callBackClass)
                return;
            }
            
            mLastResponseHtml = String(data: data!, encoding: String.Encoding.utf8)!
            
            //正常に遷移できているか確認
            if !GetValuesBase("ログイン").ContainsCheck(mLastResponseHtml){
                requestResultBool = false
                callBackClass.bool = requestResultBool
                callback(callBackClass)
                return;
            }
            
            let requestBody :String = self.createPostDataForYSLogin(userId: userId, password: password, mLastResponseHtml: mLastResponseHtml)
            let request:URLRequest = self.createURLRequest(method: "POST",
                                                           uri: self.URL2,
                                                           requestBody: requestBody,
                                                           referer: self.URL1,
                                                           header:true)

            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                if error != nil
                {
                    print("error=\(error)")
                    callBackClass.bool = requestResultBool
                    callback(callBackClass)
                    return;
                }
                
                mLastResponseHtml  = String(data: data!, encoding: String.Encoding.utf8)!
                
                //正常に遷移できているか確認
                if !GetValuesBase("ログオフ").ContainsCheck(mLastResponseHtml){
                    callBackClass.bool = requestResultBool
                    callback(callBackClass)
                    return;
                }
                
                let requestBody :String = self.createPostDataForRatePage(mLastResponseHtml: mLastResponseHtml)
                let request:URLRequest = self.createURLRequest(method: "POST",
                                                               uri: self.URL3,
                                                               requestBody: requestBody,
                                                               referer: "",
                                                               header:false)  //ヘッダを無効に
                
                let task = URLSession.shared.dataTask(with: request) {
                    data, response, error in
                    if error != nil
                    {
                        print("error=\(error)")
                        callBackClass.bool = requestResultBool
                        callback(callBackClass)
                        return;
                    }
                    
                    mLastResponseHtml = String(data: data!, encoding: String.Encoding.utf8)!
                    
                    //正常に遷移できているか確認
                    if !GetValuesBase("教科名").ContainsCheck(mLastResponseHtml){
                        callBackClass.bool = requestResultBool
                        callback(callBackClass)
                        return;
                    }
                    
                    // コールバック
                    requestResultBool = true
                    callBackClass.bool = requestResultBool
                    callBackClass.string = mLastResponseHtml
                    callback(callBackClass)
                    
                }
                task.resume()
            }
            task.resume()
        }
        task.resume()
    }
    
    // MARK: -
    func getTeacherName(html:String) -> [String]{
        var result = [String]()
        
        let urls: [String] =  GetValuesBase("<li class=\"letter\"><a href=\"(.+?)\">投書</a>").getGroupValues(html)
        
        var index : uint = 0
        for url:String in urls{
            
            let urlStr = GetValuesBase("<li class=\"letter\"><a href=\"(.+?)\">投書</a>").getValues(url)
            
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
    
    // MARK: -
    // MARK:リクエスト作成
    func createURLRequest(method:String,uri:String,requestBody:String,referer:String,header:Bool) -> URLRequest{
        var request:URLRequest = URLRequest(url: URL(string: uri)!)
        request.httpMethod = method
        if(header){
            request.addValue(referer, forHTTPHeaderField: "Referer")
            request.addValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87", forHTTPHeaderField: "User-Agent")
            request.addValue("text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8", forHTTPHeaderField: "Accept")
        }
        request.httpBody = requestBody.data(using: String.Encoding.utf8)
        return request
    }
    
    func createURLRequest2(method:String,uri:URLRequest,requestBody:String,referer:String) -> URLRequest{
        var request:URLRequest = uri
        request.httpMethod = method

        
        request.httpBody = requestBody.data(using: String.Encoding.utf8)
        return request
    }
    
    // MARK: -
    // MARK:StudentCommunicationログイン時のリクエストボディ
    func createPostDataForEscLogin(userId:String, passwrod:String,mLastResponseHtml:String) -> String{
        let _token = GetValuesBase().uriEncode(GetValuesBase("input name=\"_token\" type=\"hidden\" value=\"(.+?)\"").getValues(mLastResponseHtml))
        let postString :String = "_token=" + _token + "&userid=" + userId + "&password=" +  passwrod
        
        return postString
    }
    
    // MARK:山口学園学生サービスログイン時のリクエストボディ
    func createPostDataForYSLogin(userId:String, password:String,mLastResponseHtml:String) -> String{
        let __LASTFOCUS = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"__LASTFOCUS\" id=\"__LASTFOCUS\" value=\"(.+?)\"").getValues(mLastResponseHtml))
        let __VIEWSTATE =  GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"__VIEWSTATE\" id=\"__VIEWSTATE\" value=\"(.*?)\"").getValues(mLastResponseHtml))
        let __SCROLLPOSITIONX = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"__SCROLLPOSITIONX\" id=\"__SCROLLPOSITIONX\" value=\"(.+?)\"").getValues(mLastResponseHtml))
        let __SCROLLPOSITIONY = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"__SCROLLPOSITIONY\" id=\"__SCROLLPOSITIONY\" value=\"(.+?)\"").getValues(mLastResponseHtml))
        let __EVENTTARGET = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"__EVENTTARGET\" id=\"__EVENTTARGET\" value=\"(.+?)\"").getValues(mLastResponseHtml))
        let __EVENTARGUMENT = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"__EVENTARGUMENT\" id=\"__EVENTARGUMENT\" value=\"(.+?)\"").getValues(mLastResponseHtml))
        let __EVENTVALIDATION = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"__EVENTVALIDATION\" id=\"__EVENTVALIDATION\" value=\"(.+?)\"").getValues(mLastResponseHtml))
        let  ctl00$ContentPlaceHolder1$txtUserId  : String = userId
        let ctl00$ContentPlaceHolder1$txtPassword :String = password
        let  ctl00$ContentPlaceHolder1$btnLogin : String = GetValuesBase().uriEncode("ログイン")
    
        let postString :String = "__LASTFOCUS=" + __LASTFOCUS + "&__VIEWSTATE=" + __VIEWSTATE + "&__SCROLLPOSITIONX=" +  __SCROLLPOSITIONX + "&__SCROLLPOSITIONY=" +  __SCROLLPOSITIONY + "&__EVENTTARGET=" + __EVENTTARGET + "&__EVENTARGUMENT=" + __EVENTARGUMENT + "&__EVENTVALIDATION=" + __EVENTVALIDATION + "&ctl00%24ContentPlaceHolder1%24txtUserId=" + ctl00$ContentPlaceHolder1$txtUserId + "&ctl00%24ContentPlaceHolder1%24txtPassword=" + ctl00$ContentPlaceHolder1$txtPassword + "&ctl00%24ContentPlaceHolder1%24btnLogin=" + ctl00$ContentPlaceHolder1$btnLogin
        
        return postString
    }
    
    // MARK:出席率画面遷移時のリクエストボディ
    func createPostDataForRatePage(mLastResponseHtml:String) -> String{
        
        let  __EVENTTARGET2 = GetValuesBase().uriEncode("ctl00$btnSyuseki")
        let  __EVENTARGUMENT2 = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"__EVENTARGUMENT\" id=\"__EVENTARGUMENT\" value=\"(.+?)\"").getValues(mLastResponseHtml))
        let __VIEWSTATE2 = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"__VIEWSTATE\" id=\"__VIEWSTATE\" value=\"(.+?)\"").getValues(mLastResponseHtml))
        let __SCROLLPOSITIONX2 = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"__SCROLLPOSITIONX\" id=\"__SCROLLPOSITIONX\" value=\"(.+?)\"").getValues(mLastResponseHtml))
        let __SCROLLPOSITIONY2 = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"__SCROLLPOSITIONY\" id=\"__SCROLLPOSITIONY\" value=\"(.+?)\"").getValues(mLastResponseHtml))
        let __EVENTVALIDATION2 = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"__EVENTVALIDATION\" id=\"__EVENTVALIDATION\" value=\"(.+?)\"").getValues(mLastResponseHtml))
        let ctl00$txtWindowOpenFlg = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"ctl00\\$txtWindowOpenFlg\" id=\"ctl00_txtWindowOpenFlg\" value=\"(.+?)\"").getValues(mLastResponseHtml))
        let ctl00$txtWindowOpenUrl = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"ctl00\\$txtWindowOpenUrl\" id=\"ctl00_txtWindowOpenUrl\" value=\"(.+?)\"").getValues(mLastResponseHtml))
        let ctl00$txtWindowOpenName = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"ctl00\\$txtWindowOpenName\" id=\"ctl00_txtWindowOpenName\" value=\"(.+?)\"").getValues(mLastResponseHtml))
        let ctl00$txtWindowOpenStyle = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"ctl00\\$txtWindowOpenStyle\" id=\"ctl00_txtWindowOpenStyle\" value=\"(.+?)\"").getValues(mLastResponseHtml))
        let ctl00$txtSearchKey = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"ctl00\\$txtSearchKey\" id=\"ctl00_txtSearchKey\" value=\"(.+?)\"").getValues(mLastResponseHtml))
        let ctl00$txtParamKey = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"ctl00\\$txtParamKey\" id=\"ctl00_txtParamKey\" value=\"(.+?)\"").getValues(mLastResponseHtml))
        let ctl00$txtCssFileName = GetValuesBase().uriEncode(GetValuesBase("input type=\"hidden\" name=\"ctl00\\$txtCssFileName\" id=\"ctl00_txtCssFileName\" value=\"(.+?)\"").getValues(mLastResponseHtml))
        let ctl00$txtHeadTitle = "";
        
        let postString = "__EVENTTARGET=" + __EVENTTARGET2 + "&__EVENTARGUMENT=" + __EVENTARGUMENT2 + "&__VIEWSTATE=" + __VIEWSTATE2 + "&__SCROLLPOSITIONX=" + __SCROLLPOSITIONX2 + "&__SCROLLPOSITIONY=" + __SCROLLPOSITIONY2 + "&__EVENTVALIDATION=" + __EVENTVALIDATION2 + "&ctl00%24txtWindowOpenFlg=" + ctl00$txtWindowOpenFlg + "&ctl00%24txtWindowOpenUrl=" + ctl00$txtWindowOpenUrl + "&ctl00%24txtWindowOpenName=" + ctl00$txtWindowOpenName + "&ctl00%24txtWindowOpenStyle=" + ctl00$txtWindowOpenStyle + "&ctl00%24txtSearchKey=" + ctl00$txtSearchKey + "&ctl00%24txtParamKey=" + ctl00$txtParamKey + "&ctl00%24txtCssFileName=" + ctl00$txtCssFileName + "&ctl00%24txtHeadTitle=" + ctl00$txtHeadTitle;
        return postString
    }

}
    
