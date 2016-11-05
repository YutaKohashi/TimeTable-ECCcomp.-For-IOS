//
//  CallBackClass.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/11/05.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

//コールバックのためのカスタムオブジェクト
class CallBackClass{
    
    //HTMLリソース
    var resultHtm : String = ""
    //成功判定
    var resultBool : Bool = false
    
    var string:String {
        // 値を取得するときに呼ばれる。
        get{
            return resultHtm
        }
        // 値がセットされるときに呼ばれる。
        set(str){
            resultHtm = str
        }
    }
    
    var bool:Bool {
        // 値を取得するときに呼ばれる。
        get{
            return resultBool
        }
        // 値がセットされるときに呼ばれる。
        set(boolean){
            resultBool = boolean
        }
    }
}
