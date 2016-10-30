//
//  HttpRequestBase.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/10/29.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import Async

class HttpRequestBase {
    
    func login() -> String{
        var result = "";
        var token = "";
        
        
        let group = AsyncGroup()
        group.enter()
        Alamofire.request("http://comp2.ecc.ac.jp/sutinfo/login")
            .responseString { response in
                debugPrint(response)
                result = String(describing: response)
                
                token = GetValuesBase.init("input name=\"_token\" type=\"hidden\" value=\"(.+?)\"").getToken(result)
                group.leave()
        }
        
//        let params: Parameters = [
//            "_token": token,
//            "userid": "2140257",
//            "password": "455478"
//        ]
        let params: Parameters = [
            "userid": "2140257",
            "password": "455478"
        ]

        group.enter()
        Alamofire.request("http://comp2.ecc.ac.jp/sutinfo/auth/attempt",method: .post, parameters: params)
            .responseString { response in
                debugPrint(response)
                result = String(describing: response)
                group.leave()
        }
        group.enter()
        
        return result;

    }
    
//    func httpPost() -> String{
//        var result = "";
//        
//        toLoginPage().then { result in
//            print(result)
//        }
////
////        firstly{
////            toLoginPage()
////        }.then{dict in{
////                login()
////            }.then{dict in{
////                
//            }
//        return result;
//        
//    }
    
    
    func toLoginPage() -> Promise<NSDictionary> {
        return Promise { fulfill, reject in
            Alamofire.request("http://comp2.ecc.ac.jp/sutinfo/login")
                .responseString { response in
                    if response.result.isSuccess {
                        
                    }else{
                        
                    }
                    
            }
        }
    }
    
    func login() -> Promise<NSDictionary> {
        return Promise { fulfill, reject in
            Alamofire.request("http://comp2.ecc.ac.jp/sutinfo/login")
                .responseString { response in
                    if response.result.isSuccess {
                        
                    }else{
                        
                    }
                    
            }
        }
    }
}
