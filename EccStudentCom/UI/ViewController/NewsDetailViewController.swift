//
//  NewsDetailViewController.swift
//  EccStudentCom
//
//  Created by 小橋勇太 on 2017/02/19.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import UIKit
import SpringIndicator

class NewsDetailViewController: UIViewController {
    
    private var newTitle: String!
    private var date: String!
//    private var html:String!
    private var newsId:Int!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var indicator: SpringIndicator!
    @IBOutlet weak var bodyLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = newTitle
        dateLabel.text = date
        bodyLabel.dataDetectorTypes = .link
        
        startIndicator()
        
        HttpConnector().requestNewsDetail(userId: PreferenceManager.getSavedId(), password: PreferenceManager.getSavedPass(), newsId: newsId) { (callback) in
            self.stopIndicator()
            if callback.bool {
                let detail : NewsDetailRoot = callback.response!
                self.bodyLabel.text = detail.newsDetail.body
                
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 閉じるボタンのイベント
    @IBAction func closeButton(_ sender: Any) {
          self.dismiss(animated: true, completion: nil)
    }
    
    func setTitle(str:String){
        self.newTitle = str
    }
    func setDate(str:String){
        self.date = str
    }
    
    func setNewsId(int:Int){
        self.newsId = int
    }
    
    private func startIndicator(){
        indicator.isHidden = false
        indicator.startAnimation()
    }
    
    private func stopIndicator(){
        indicator.stopAnimation(false)
        indicator.isHidden = false
        
    }
}
