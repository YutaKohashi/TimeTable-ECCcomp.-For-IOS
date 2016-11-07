//
//  AboutViewController.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/11/03.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        StatusBarManager().setStatusBarBackgroundColor(color: UIColor(red:0.00, green:0.16, blue:0.22, alpha:1.0))
//        // ステータスバーのスタイル変更を促す
        self.setNeedsStatusBarAppearanceUpdate();
        
        webView.scrollView.bounces = false
          let path : String = Bundle.main.path(forResource: "about_html", ofType:"html")!
        DispatchQueue.main.async(execute: {
            //View controller code
          
            self.webView.loadRequest(NSURLRequest(url: NSURL(string: path)! as URL) as URLRequest)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden : Bool {
        // trueの場合はステータスバー非表示
        return false;
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        // ステータスバーを白くする
        return UIStatusBarStyle.lightContent;
    }
    
}
