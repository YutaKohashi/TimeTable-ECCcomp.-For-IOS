//
//  RequestBody.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/11/09.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import Foundation

class RequestBody{
    // MARK: -
    // MARK:StudentCommunicationログイン時のリクエストボディ
//    func createPostDataForEscLogin(userId:String, passwrod:String,mLastResponseHtml:String) -> String{
//        let _token = GetValuesBase().uriEncode(GetValuesBase("input name=\"_token\" type=\"hidden\" value=\"(.+?)\"").getValues(mLastResponseHtml))
//        let postString :String = "_token=" + _token +
//                                 "&userid=" + userId +
//                                 "&password=" + passwrod
//        return postString
//    }
    
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
        
        let postString =
            "__LASTFOCUS=" + __LASTFOCUS +
            "&__VIEWSTATE=" + __VIEWSTATE +
            "&__SCROLLPOSITIONX=" +  __SCROLLPOSITIONX +
            "&__SCROLLPOSITIONY=" +  __SCROLLPOSITIONY +
            "&__EVENTTARGET=" + __EVENTTARGET +
            "&__EVENTARGUMENT=" + __EVENTARGUMENT +
            "&__EVENTVALIDATION=" + __EVENTVALIDATION +
            "&ctl00%24ContentPlaceHolder1%24txtUserId=" + ctl00$ContentPlaceHolder1$txtUserId +
            "&ctl00%24ContentPlaceHolder1%24txtPassword=" + ctl00$ContentPlaceHolder1$txtPassword +
            "&ctl00%24ContentPlaceHolder1%24btnLogin=" + ctl00$ContentPlaceHolder1$btnLogin
        
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
        
        let postString =
            "__EVENTTARGET=" + __EVENTTARGET2 +
            "&__EVENTARGUMENT=" + __EVENTARGUMENT2 +
            "&__VIEWSTATE=" + __VIEWSTATE2 +
            "&__SCROLLPOSITIONX=" + __SCROLLPOSITIONX2 +
            "&__SCROLLPOSITIONY=" + __SCROLLPOSITIONY2 +
            "&__EVENTVALIDATION=" + __EVENTVALIDATION2 +
            "&ctl00%24txtWindowOpenFlg=" + ctl00$txtWindowOpenFlg +
            "&ctl00%24txtWindowOpenUrl=" + ctl00$txtWindowOpenUrl +
            "&ctl00%24txtWindowOpenName=" + ctl00$txtWindowOpenName +
            "&ctl00%24txtWindowOpenStyle=" + ctl00$txtWindowOpenStyle +
            "&ctl00%24txtSearchKey=" + ctl00$txtSearchKey +
            "&ctl00%24txtParamKey=" + ctl00$txtParamKey +
            "&ctl00%24txtCssFileName=" + ctl00$txtCssFileName +
            "&ctl00%24txtHeadTitle=" + ctl00$txtHeadTitle
        
        return postString
    }
}
