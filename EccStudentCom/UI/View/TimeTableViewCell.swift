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
    // uicollectionview表示時に表示するアイテムのindexを保持する変数
    @IBOutlet weak var index: UILabel!
    
    public func setLabel(subject:String, room:String, index:Int){
        self.subject.text = subject
        self.room.text = room
        self.index.text = String(index)
    }
    
    public func setIndex(index:Int){
        self.index.text = String(index)
    }
    
    public func setRoomBackgroundColor(color:UIColor!){
        room.backgroundColor = color
    }
}
