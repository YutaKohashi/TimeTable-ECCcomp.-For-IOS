//
//  CustomTimeTableCellWed.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/11/01.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import UIKit

class CustomTimeTableViewCellWed: UITableViewCell {
    
    @IBOutlet weak var subjectName: UILabel!
    @IBOutlet weak var room: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(_ subject: String,roomN: String) {
        
        subjectName.text = subject
        room.text = roomN
    }
}
