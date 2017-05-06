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
        
       webView.scrollView.bounces = false
        DispatchQueue.main.async(execute: {
            self.html = self.getNews(html: self.html)
            self.webView.loadHTMLString(self.html, baseURL: URL(string:"http://comp2.ecc.ac.jp/")!)
        })
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
    
    func setHtml(str:String){
        self.html = str
    }
    
    private func getNews(html:String) -> String{
        var value:String = html.replacingOccurrences(of: "\r", with: "")
        value = value.replacingOccurrences(of: "\n", with: "")
        value = GetValuesBase("<p class=\"body clear\">","</p>").narrowingValues(value)
        
        value =
            "<html>" +
            "<head>" +
            "<style type='text/css'>" +
            "body{ font-family: 'SourceSansPro-Regular';\t " +
            "padding: 10px;\t" +
            "font-size: 11pt;\t" +
            "overflow-x : hidden;\t" +
            "overflow-y : auto\t}" +
            "html{ overflow-x : hidden;\t" +
            "overflow-y : auto\t}" +
            "</style>" +
            "</head>" +
            "<body>" +
             value +
            "</body>" +
            "</html>"
        
        return value
    }
}
