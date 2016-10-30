//
//  TImeTableViewController.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/10/30.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import UIKit
import RealmSwift
import KRProgressHUD
import MetalKit


class TimeTableViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StatusBarManager().setStatusBarBackgroundColor(color: UIColor(red:0.00, green:0.29, blue:0.39, alpha:1.0))
        // ステータスバーのスタイル変更を促す
        self.setNeedsStatusBarAppearanceUpdate();
        
        
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
