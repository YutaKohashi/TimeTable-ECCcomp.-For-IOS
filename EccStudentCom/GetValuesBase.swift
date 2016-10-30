//
//  GetValuesBase.swift
//  ecc
//
//  Created by YutaKohashi on 2016/09/16.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import Foundation


class GetValuesBase{
    
    let regex:NSRegularExpression
    let pattern: String
    
    init(_ pattern: String) {
        self.pattern = pattern
        self.regex = try! NSRegularExpression( pattern: self.pattern, options: NSRegularExpression.Options.caseInsensitive)

    }
    
    init(_ pattern1: String , _ pattern2: String) {
        self.pattern = pattern1 + "(.+?)" + pattern2
        self.regex = try! NSRegularExpression( pattern: self.pattern, options: NSRegularExpression.Options.caseInsensitive)
    }
    
 
    
    func isMatch(_ input: String) -> Bool {
        let matches = self.regex.matches( in: input, options: [], range:NSMakeRange(0, input.characters.count) )
        return matches.count > 0
    }
    
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
    
    //特定の文字列が含まれているか
    func ContainsCheck(_ target:String) -> Bool{
        return target.contains(pattern)
        
    }

    
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
    
    func getToken(_ input: String) -> String {
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
    
 
    
}


