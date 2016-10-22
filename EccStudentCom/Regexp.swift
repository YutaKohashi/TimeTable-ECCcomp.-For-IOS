//
//  Regexp.swift
//  ecc
//
//  Created by YutaKohashi on 2016/09/16.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import Foundation

class Regexp {
    let internalRegexp: NSRegularExpression
    let pattern: String
    
    init(_ pattern: String) {
        self.pattern = pattern
        self.internalRegexp = try! NSRegularExpression( pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
    }
    
    func isMatch(_ input: String) -> Bool {
        let matches = self.internalRegexp.matches( in: input, options: [], range:NSMakeRange(0, input.characters.count) )
        return matches.count > 0
    }
    
    func matches(_ input: String) -> [String]? {
        if self.isMatch(input) {
            let matches = self.internalRegexp.matches( in: input, options: [], range:NSMakeRange(0, input.characters.count) )
            var results: [String] = []
            for i in 0 ..< matches.count {
                results.append( (input as NSString).substring(with: matches[i].range) )
            }
            return results
        }
        return nil
    }
}
