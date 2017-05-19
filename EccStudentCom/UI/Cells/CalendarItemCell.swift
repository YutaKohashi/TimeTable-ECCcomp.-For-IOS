//
//  CalendarItemCell.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/19.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import UIKit

class CalendarItemCell : UITableViewCell {
    
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    public func setCell(body:String, date:String){
        bodyLabel.text = body
        dateLabel.text = date
    }
    
    public func getBody() -> String! {
        return bodyLabel.text
    }
    
    public func getDate() -> String! {
        return dateLabel.text
    }
}
