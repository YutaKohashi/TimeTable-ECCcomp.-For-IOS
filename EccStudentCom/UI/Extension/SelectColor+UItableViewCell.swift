//
//  SelectColor+UItableViewCell.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/11/28.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    @IBInspectable
    var selectedBackgroundColor: UIColor? {
        get {
            return selectedBackgroundView?.backgroundColor
        }
        set(color) {
            let background = UIView()
            background.backgroundColor = color
            selectedBackgroundView = background
        }
    }
    
}
