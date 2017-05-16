//
//  CALayer+RuntimeAttribute.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/11/05.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import UIKit

extension CALayer {
    
    func setBorderIBColor(color: UIColor!) -> Void{
        self.borderColor = color.cgColor
    }
}
