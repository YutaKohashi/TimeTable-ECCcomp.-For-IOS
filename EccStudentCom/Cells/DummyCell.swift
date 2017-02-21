//
//  DummyCell.swift
//  EccStudentCom
//
//  Created by 小橋勇太 on 2017/02/20.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import UIKit

class DummyCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    func setCell(_ label:String){
        self.label.text = label
    }
}
