//
//  GetValuesBase.swift
//  ecc
//
//  Created by YutaKohashi on 2016/09/16.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import Foundation
import KRProgressHUD


class GetValuesBase{
    
    let regex:NSRegularExpression
    let pattern: String
    
    // MARK:- コンストラクタ
    init(_ pattern: String) {
        self.pattern = pattern
        self.regex = try! NSRegularExpression( pattern: self.pattern, options: NSRegularExpression.Options.caseInsensitive)
    }
    
    init(_ pattern1: String , _ pattern2: String) {
        self.pattern = pattern1 + "(.+?)" + pattern2
        self.regex = try! NSRegularExpression( pattern: self.pattern, options: NSRegularExpression.Options.caseInsensitive)
    }
    
    init(){
        self.pattern = "(.+?)"
        self.regex = try! NSRegularExpression( pattern: self.pattern, options: NSRegularExpression.Options.caseInsensitive)
    }
 
    // MARK: -
    // MARK:マッチしているか判定するメソッド
    func isMatch(_ input: String) -> Bool {
        let matches = self.regex.matches( in: input, options: [], range:NSMakeRange(0, input.characters.count) )
        return matches.count > 0
    }
    
    // MARK:正規表現を使用して値を取得するメソッド
     func getValues(_ input: String) -> String {
        if self.isMatch(input) {
            let matches = self.regex.matches( in: input, options: [], range:NSMakeRange(0, input.characters.count) )
            var results: [String] = []
            matches.forEach { match in
                results.append( (input as NSString).substring(with: match.rangeAt(1)))
            }
            
            return results[0].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        //一致しないときは空文字を返す
        return ""
    }
    
    //MARK:特定の文字列が含まれているか
    func ContainsCheck(_ target:String) -> Bool{
        return target.contains(pattern)
    }

    // MARK:正規表現を複数取得
    func getGroupValues(_ input: String) -> [String] {
        var results: [String] = []
        
        if self.isMatch(input) {
            let matches = self.regex.matches( in: input, options: [], range:NSMakeRange(0, input.characters.count) )
            
            for i in 0 ..< matches.count {
                results.append( (input as NSString).substring(with: matches[i].range).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
            }
            return results
        }
        return results
    }
    
    func narrowingValues(_ input: String) -> String {
        if self.isMatch(input) {
            let matches = self.regex.matches( in: input, options: [], range:NSMakeRange(0, input.characters.count) )
            var results: [String] = []
            matches.forEach { match in
                results.append( (input as NSString).substring(with: match.rangeAt(1)))
            }
            return results[0]
        }
        //一致しないときは空文字を返す
        return ""
    }
    
    // MARK:URLエンコードを行うメソッド
    func uriEncode(_ str: String) -> String {
        let allowedCharacterSet = NSMutableCharacterSet.alphanumeric()
        allowedCharacterSet.addCharacters(in: "-._~")
        return str.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet as CharacterSet)!
    }
    
    // MARK:％を取り除く
    func removePercent(_ str:String) -> String{
        return str.replacingOccurrences(of: "%", with: "")
    }
    // MARK:&nbspを取り除く
    func removeNBSP(_ str:String)->String{
        return str.replacingOccurrences(of: "&nbsp;", with: "0")
    }
    
    // MARK:改行コード\nを削除
    func removeLineCodeN(_ str:String) -> String{
        return str.replacingOccurrences(of: "\n", with: "")
    }
    // MARK:改行コード\rを削除
    func removeLineCodeR(_ str:String) -> String{
        return str.replacingOccurrences(of: "\r", with: "")
    }
    // MARK:タブコード\tを削除
    func removeTabCode(_ str:String) -> String{
        return str.replacingOccurrences(of: "\t", with: "")
    }
    
}


