//
//  NewsTitleCell.swift
//  EccStudentCom
//
//  Created by 小橋勇太 on 2017/02/19.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import UIKit

class NewsTitleCell: UITableViewCell {
    
 
    @IBOutlet weak var groupTitle: UILabel!
    
    func setCell(_ groupTitle:String){
        self.groupTitle.text  = groupTitle
    }
    
    func getGroupTitle() -> String {
        return groupTitle.text!
    }
}


