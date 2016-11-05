//
//  CustomTableCell.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/09/25.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
   
    @IBOutlet weak var subjectName: UILabel!
    @IBOutlet weak var unit: UILabel!
    @IBOutlet weak var attendanceRate: UILabel!
    @IBOutlet weak var attendanceNumber: UILabel!
    @IBOutlet weak var absentNumber: UILabel!
    @IBOutlet weak var lateNumber: UILabel!
    @IBOutlet weak var publicAbsentNumber1: UILabel!
    @IBOutlet weak var publicAbsentNumber2: UILabel!
    @IBOutlet weak var shortageNumber : UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    /// 画像・タイトル・説明文を設定するメソッド
    func setCell(_ subject: String,unitNum: String,attendanceNum: String,absentNum: String,lateNum: String,pubAbsentnum1: String,pubAbsentnum2: String,attendanceRateNum: String,shortageNum:String) {
        
        subjectName.text = subject
        unit.text = unitNum
        attendanceNumber.text = attendanceNum
        absentNumber.text = absentNum
        lateNumber.text = lateNum
        publicAbsentNumber1.text = pubAbsentnum1
        publicAbsentNumber2.text = pubAbsentnum2
        attendanceRate.text = attendanceRateNum
//        shortageNumber.text = shortageNum
    }
  
}
