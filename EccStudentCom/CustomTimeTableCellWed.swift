//
//  CustomTimeTableCellWed.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/11/01.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import UIKit

class CustomTimeTableViewCellWed: UITableViewCell {
    
//    
//    @IBOutlet weak var subjectName: UILabel!
//    @IBOutlet weak var room: UILabel!
    @IBOutlet weak var subjectName: UILabel!
    @IBOutlet weak var room: UILabel!
//    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    /// 画像・タイトル・説明文を設定するメソッド
    func setCell(_ subject: String,roomN: String) {
        
        subjectName.text = subject
        room.text = roomN
    }
    
}
