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
    private var resultHtm : String = ""
    //成功判定
    private var resultBool : Bool = false
    
    var string:String {
        get{
            return resultHtm
        }
        set(str){
            resultHtm = str
        }
    }
    
    var bool:Bool {
        get{
            return resultBool
        }
        set(boolean){
            resultBool = boolean
        }
    }
}
