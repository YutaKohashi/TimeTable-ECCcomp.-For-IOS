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
        
//        var backButton = UIBarButtonItem()
//        backButton.tintColor = UIColor.white
//        self.navigationItem.backBarButtonItem = backButton
       
        
        webView.scrollView.bounces = false
          let path : String = Bundle.main.path(forResource: "about_html", ofType:"html")!
        DispatchQueue.main.async(execute: {
            //View controller code
          
            self.webView.loadRequest(NSURLRequest(url: NSURL(string: path)! as URL) as URLRequest)
        })
        //デリゲート先に自分を設定する。
        //self.delegate = self
    }
    
//    //画面遷移後の呼び出しメソッド
//    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
//        
//        //ナビゲーションバーのボタンの文字色を赤に変更する。
//        self.navigationBar.tintColor = UIColor.white
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override var prefersStatusBarHidden : Bool {
        // trueの場合はステータスバー非表示
        return false;
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        // ステータスバーを白くする
        return UIStatusBarStyle.lightContent;
    }
    
}
