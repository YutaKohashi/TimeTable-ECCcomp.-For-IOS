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
        self.regex = try! NSRegularExpression( pattern: self.pattern, options: NSRegularExpressionOptions.CaseInsensitive)

    }
    
    init(_ pattern1: String , _ pattern2: String) {
        self.pattern = pattern1 + "(.+?)" + pattern2
        self.regex = try! NSRegularExpression( pattern: self.pattern, options: NSRegularExpressionOptions.CaseInsensitive)
    }
    
 
    
    func isMatch(input: String) -> Bool {
        let matches = self.regex.matchesInString( input, options: [], range:NSMakeRange(0, input.characters.count) )
        return matches.count > 0
    }
    
     func getValues(input: String) -> String {
        if self.isMatch(input) {
            let matches = self.regex.matchesInString( input, options: [], range:NSMakeRange(0, input.characters.count) )
            var results: [String] = []
            matches.forEach { match in
                results.append( (input as NSString).substringWithRange(match.rangeAtIndex(1)))
            }
            
            return results[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        //一致しないときは空文字を返す
        return ""
    }
    
    //特定の文字列が含まれているか
    func ContainsCheck(target:String) -> Bool{
        return target.containsString(pattern)
        
    }

    
    func getGroupValues(input: String) -> [String] {
        var results: [String] = []
        
        if self.isMatch(input) {
            let matches = self.regex.matchesInString( input, options: [], range:NSMakeRange(0, input.characters.count) )
            
            for i in 0 ..< matches.count {
                results.append( (input as NSString).substringWithRange(matches[i].range).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
            }
            return results
        }
        return results
    }
    
    func narrowingValues(input: String) -> String {
        if self.isMatch(input) {
            let matches = self.regex.matchesInString( input, options: [], range:NSMakeRange(0, input.characters.count) )
            var results: [String] = []
            matches.forEach { match in
                results.append( (input as NSString).substringWithRange(match.rangeAtIndex(1)))
            }
            
            return results[0]
        }
        //一致しないときは空文字を返す
        return ""
    }
    
    
 
    
}


