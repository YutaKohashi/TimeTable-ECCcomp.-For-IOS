//
//  EscApiConst.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/14.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation

struct EscApiConst{
    //****************** エラーコード **************************
    
    /**
     * トークン認証
     */
    // 認証成功
    static let SUCCESS_AUTH:String = "CD00001";
    // 認証失敗
    static let ERROR_AUTH:String = "ER00001";
    
    
    /**
     * 時間割取得一覧
     */
    // API正常実行
    
    // トークン期限切れ
    static let ERROR_EXPIRED_TOKEN:String = "ER00002";
    // アクセストークンが未指定または不正
    static let ERROR_INVALID_TOKEN:String = "ER00003";
    // 時間割の取得に失敗しました
    static let ERROR_API:String = "ER00004";

}
