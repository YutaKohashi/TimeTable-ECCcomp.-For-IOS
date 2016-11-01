//
//  ViewController.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/09/24.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import UIKit
import RealmSwift
import KRProgressHUD
import MetalKit


class ViewController: UIViewController, UITextFieldDelegate {

    fileprivate let userId:String = "2140257"
    fileprivate let password:String = "455478"
//    
//    fileprivate var ActivityIndicator: MKActivityIndicator!

    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
   
    @IBOutlet weak var loginButton: UIButton!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StatusBarManager().setStatusBarBackgroundColor(color: UIColor(red:0.00, green:0.29, blue:0.39, alpha:1.0))
        // ステータスバーのスタイル変更を促す
        self.setNeedsStatusBarAppearanceUpdate();
        
        //パスワード入力フィールドをpasswordmodeに
        passwordTextField.isSecureTextEntry = true
        
        self.passwordTextField.delegate = self;
        
        //ログインボタン設定
        loginButton.layer.cornerRadius = 10    //角の設定
        loginButton.layer.masksToBounds = true
//        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func tabLoginBtn(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        
        //インターネットに接続されていないのときはアラート表示
        if !ToolsBase().CheckReachability("google.com"){
//            ToolsBase().showToast("インターネットに接続されていません", isShortLong: true)
            DialogManager().showWarningForInternet()
            return;
        }
        
        //テキストフィールドチェック
        if ToolsBase().checkTextFiled(idTextField: idTextField,passwordTextField: passwordTextField){
            DialogManager().showWarningForTextField()
            return;
        }
        
//        HttpRequest().requestTimeTable(idTextField: idTextField, passwordTextField: passwordTextField,callback: {
//            requestResultBool in
//            
//            if(requestResultBool){
//                DispatchQueue.main.async(execute: {
//                    DialogManager().showSuccess()
//                    
//                    
//                })
//            }else{
//                //失敗
//            }
//        })
    
        HttpRequest().reequestTimeTableAttendanseRate(idTextField: idTextField, passwordTextField: passwordTextField,callback: {
            requestResultBool in
            
            if(requestResultBool){
                //成功
                DispatchQueue.main.async(execute: {
                     DialogManager().showSuccess()
                    
                    //出席率表示画面へ遷移
                    let storyboard: UIStoryboard = self.storyboard!
                    //let nextView = storyboard.instantiateViewController(withIdentifier: "MainView") as! TableViewController
                    let nextView = storyboard.instantiateViewController(withIdentifier: "MainView") as! UITabBarController
                    self.present(nextView, animated: true, completion: nil)
                    
                })
            }else{
                //失敗
            }
        })

    }
    
    override var prefersStatusBarHidden : Bool {
        // trueの場合はステータスバー非表示
        return false;
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        // ステータスバーを白くする
        return UIStatusBarStyle.lightContent;
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}

