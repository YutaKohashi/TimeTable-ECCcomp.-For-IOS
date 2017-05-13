//
//  RequestURL.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/11/08.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import Foundation

class RequestURL{
    let YS_TO_PAGE :String       = "http://falcon.ecc.ac.jp/eccstd/st0100/st0100_01.aspx";
    let YS_LOGIN : String        = "http://falcon.ecc.ac.jp/eccstd/st0100/st0100_01.aspx";
    let YS_TO_RATE_PAGE : String = "http://falcon.ecc.ac.jp/ECCSTD/ST0100/ST0100_02.aspx";
    
    //StudentCommunication
    let ESC_TO_PAGE:String       = "http://comp2.ecc.ac.jp/sutinfo/login"        //ログインページ
    let ESC_LOGIN:String         = "http://comp2.ecc.ac.jp/sutinfo/auth/attempt" //実ログイン
    
    let DEFAULT_REFERER:String   = "http://google.co.jp"
}
