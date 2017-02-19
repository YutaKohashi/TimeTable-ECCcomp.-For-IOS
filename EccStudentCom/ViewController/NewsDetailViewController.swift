//
//  NewsDetailViewController.swift
//  EccStudentCom
//
//  Created by 小橋勇太 on 2017/02/19.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {
    
    private var newTitle: String!
    private var date: String!
    private var html:String!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = newTitle
        dateLabel.text = date
        webView.loadHTMLString(html,
                               baseURL: URL(string:"http://comp2.ecc.ac.jp/")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func closeButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func setTitle(str:String){
        self.newTitle = str
    }
    func setDate(str:String){
        self.date = str
    }
    
    func setHtml(str:String){
        self.html = str
    }
}
