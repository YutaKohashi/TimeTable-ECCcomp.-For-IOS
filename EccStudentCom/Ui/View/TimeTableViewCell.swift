//
//  TimeTableViewCell.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/08.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import UIKit

class TimeTableViewCell: UICollectionViewCell {
    
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var room: UILabel!
    
    public func setLabel(subject:String, room:String){
        self.subject.text = subject
        self.room.text = room
    }
    
    public func setRoomBackgroundColor(color:UIColor!){
        room.backgroundColor = color
    }
}
