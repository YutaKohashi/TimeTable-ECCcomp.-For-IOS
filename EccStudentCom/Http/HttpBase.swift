//
//  RequestBase2.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/11/08.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import Foundation

class HttpBase{
    
    // MARK:GET通信
    func httpGet(url:String,requestBody:String,referer:String,header:Bool,callback: @escaping (CallBackClass) -> Void) -> Void {
        self.httpRequest(type: "GET",
                         url: url,
                         requestBody: requestBody,
                         referer: referer,
                         header: header) { (cb) in
            callback(cb)
        }
    }
    
    // MARK:POST通信
    func httpPost(url:String,requestBody:String,referer:String,header:Bool,callback: @escaping (CallBackClass) -> Void) -> Void {
        self.httpRequest(type: "POST",
                         url: url,
                         requestBody: requestBody,
                         referer: referer,
                         header: header) { (cb) in
            callback(cb)
        }
    }
    
    // MARK:リクエストベースメソッド
    private func httpRequest(type:String,url:String,requestBody:String,referer:String,header:Bool,callback: @escaping (CallBackClass) -> Void) -> Void {
        let cb:CallBackClass = CallBackClass()
        
        let request = self.createURLRequest(method: type,
                                            uri:  url,
                                            requestBody: requestBody,
                                            referer: referer,
                                            header:header)
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if error != nil
            {
                print("error=\(String(describing: error))")
                cb.bool = false
                callback(cb)
                return
            }
            
            if (response as? HTTPURLResponse) == nil {
                print("error=\(String(describing: error))")
                cb.bool = false
                callback(cb)
                return
            }
            
            cb.string = String(data: data!, encoding: String.Encoding.utf8)!
            cb.bool = true
            callback(cb)
        }
        task.resume()
    }
  
    //連続GETメソッド
    func continuousRequest(urls:[String],method:String) -> [String]{
        var htmls:[String] = []
        
        for i in 0  ..< urls.count {
            self.sendSynchronize(method:method,
                                 url: urls[i],
                                 requestBody:"",
                                 completion:{ data, res, error in
                htmls.append(String(data: data! as Data, encoding: String.Encoding.utf8)!)
            })
        }
        
        return htmls
    }
    
    private func statusCheck(code:Int) -> Bool{
        if code == 200{
            return true
        }
        return false
    }
    
    //TODO:
    private func sendSynchronize(method:String,url:String,requestBody:String, completion: @escaping (NSData?, URLResponse?, NSError?) -> Void) {
        let semaphore = DispatchSemaphore(value: 0)
        
        let url = URL(string: url)!
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: url) { data, response, error in
            defer {
                completion(data as NSData?, response, error as NSError?)
                semaphore.signal()
            }
        }
        task.resume()
        semaphore.wait()
    }
    
    
    // MARK:リクエスト作成
    private func createURLRequest(method:String,uri:String,requestBody:String,referer:String,header:Bool) -> URLRequest{
        var request:URLRequest = URLRequest(url: URL(string: uri)!)
        request.httpMethod = method
        if(header){
            request.addValue(referer, forHTTPHeaderField: "Referer")
            request.addValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87",
                             forHTTPHeaderField: "User-Agent")
            request.addValue("text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
                             forHTTPHeaderField: "Accept")
        }
        request.httpBody = requestBody.data(using: String.Encoding.utf8)
        return request
    }
}
