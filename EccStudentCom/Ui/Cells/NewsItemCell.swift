//
//  NewsItemCell.swift
//  EccStudentCom
//
//  Created by 小橋勇太 on 2017/02/19.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import UIKit

class NewsItemCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var newsId: UILabel!
    @IBOutlet weak var from: UILabel!
    
    func setCell(_ title:String, date:String,newsId:String, from:String){
        self.title.text = title
        self.date.text = date
        self.newsId.text = newsId
        self.from.text = from
    }
    
    func getTitle() ->String {
        return title.text!
    }
    
    func getDate() -> String {
        return date.text!
    }
    
    func getNewsId() -> String{
        return newsId.text!
    }
}
