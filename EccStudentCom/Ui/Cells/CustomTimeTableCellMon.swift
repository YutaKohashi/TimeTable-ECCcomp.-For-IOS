//
//  CustomTimeTableCell.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/11/01.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import UIKit

class CustomTimeTableViewCellMon: UITableViewCell {
    
    @IBOutlet weak var subjectName: UILabel!
    @IBOutlet weak var room: UILabel!
    @IBOutlet weak var teacherName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)        
    }
    
    func setCell(_ subject: String,roomN: String,name:String) {
        
        subjectName.text = subject
        room.text = roomN
        teacherName.text = name
    }
    
    func getSubjectName() -> UILabel{
        return subjectName
    }
    
    func getRoom() -> UILabel {
        return room
    }
    
    func getTeacherName() -> UILabel{
        return teacherName
    }

}
