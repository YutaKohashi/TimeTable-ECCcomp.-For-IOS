//
//  LisenceViewController.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/11/03.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import UIKit

class LisenceViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.scrollView.bounces = false
        
        DispatchQueue.main.async(execute: {
            //View controller code
            let path : String = Bundle.main.path(forResource: "lisence", ofType:"html")!
            self.webView.loadRequest(URLRequest(url:URL(string: path)! as URL) as URLRequest)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
