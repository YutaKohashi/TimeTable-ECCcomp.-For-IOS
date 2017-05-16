
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
        
        PreferenceManager.saveLatestUpdateAttendanceRate(now: "-/-/- -:-")
        PreferenceManager.saveLatestUpdateTaninNews(now: "-/-/- -:-")
        PreferenceManager.saveLatestUpdateASchoolNews(now: "-/-/- -:-")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 以前ログインしていたかをチェック
        // ログインしていた場合に何か行いたい時
        if PreferenceManager.loginedCheck() {
//            let alert: UIAlertController = UIAlertController(title: "お詫び",
//                                                             message: "新機能実装のため ログアウト させていただきました。\n再度ログインをお願いします。",
//                                                             preferredStyle:   UIAlertControllerStyle.alert)
//            // OKボタン
//            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
//                (action: UIAlertAction!) -> Void in
//                print("OK")
//                //全データを削除
//                let realm = try! Realm()
//                try! realm.write {
//                    realm.deleteAll()
//                }
//                
//                PreferenceManager.saveLoginState(false)
//                //保存されていたpassIdを削除
//                PreferenceManager.removeSavedIdPass()
//                PreferenceManager.saveLoginedState(false)
//                
//            })
//            
//            alert.addAction(defaultAction)
//            present(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tabLoginBtn(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        //インターネットに接続されていないのときはアラート表示
        if !Util.isConnectedToNetwork(){
            DiagUtil.showWarningForInternet()
            return;
        }
        
        //テキストフィールドチェック
        if Util.checkTextFiled(idTextField: idTextField,passwordTextField: passwordTextField){
            DiagUtil.showWarningForTextField()
            return;
        }
        
        //インジゲータダイアログ表示
        DiagUtil.showIndicator()
        let userId:String = idTextField.text!
        let password:String = passwordTextField.text!
        HttpConnector().request(type: .TIME_TABLE,
                                userId: userId,
                                password: password)
        { (result) in
            if(result){
                HttpConnector().request(type: .NEWS_SCHOOL_TEACHER, userId: userId, password: password, callback: { (result1) in
                    if result1 {
                        HttpConnector().request(type: .ATTENDANCE_RATE, userId: userId, password: password, callback: { (result2) in
                            DiagUtil.hideIndicator()
                            let sec:Double = 1
                            let delay = sec * Double(NSEC_PER_SEC)
                            let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                            DispatchQueue.main.asyncAfter(deadline: time, execute: {
                                
                                DiagUtil.showSuccess()
                            })
                            
                            DispatchQueue.main.async(execute: {
                                //ログインしたことを保存
                                PreferenceManager.saveLoginState(true)
                                //passIdを保存
                                PreferenceManager.saveIdPass(userId, pass: password)
                                //出席率表示画面へ遷移
                                let storyboard: UIStoryboard = self.storyboard!
                                let nextView = storyboard.instantiateViewController(withIdentifier: "MainView") as! UITabBarController
                                self.present(nextView, animated: true, completion: nil)
                                
                            })

                        })
                    } else {
                        //失敗
                        DiagUtil.hideIndicator()
                        let sec:Double = 1
                        let delay = sec * Double(NSEC_PER_SEC)
                        let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                        DispatchQueue.main.asyncAfter(deadline: time, execute: {
                            //エラーダイアログ表示
                            DiagUtil.showError(string: "失敗しました")
                        })
                    }
                })
            }else{
                //失敗
                DiagUtil.hideIndicator()
                let sec:Double = 1
                let delay = sec * Double(NSEC_PER_SEC)
                let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: time, execute: {
                    //エラーダイアログ表示
                    DiagUtil.showError(string: "失敗しました")
                })
            }
        }
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
