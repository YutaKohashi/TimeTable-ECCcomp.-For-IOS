
//
//  ViewController.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/09/24.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import UIKit
import RealmSwift
import MetalKit


class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Util.setStatusBarBackgroundColor(color: Util.getPrimaryColor())
        // ステータスバーのスタイル変更を促す
        self.setNeedsStatusBarAppearanceUpdate();
        
        //パスワード入力フィールドをpasswordmodeに
        passwordTextField.isSecureTextEntry = true
        
        self.passwordTextField.delegate = self;
        
        //ログインボタン設定
        loginButton.layer.cornerRadius = 10    //角の設定
        loginButton.layer.masksToBounds = true
        
        PrefUtil.saveLatestUpdateAttendanceRate(now: "-/-/- -:-")
        PrefUtil.saveLatestUpdateTaninNews(now: "-/-/- -:-")
        PrefUtil.saveLatestUpdateASchoolNews(now: "-/-/- -:-")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 以前ログインしていたかをチェック
        // ログインしていた場合に何か行いたい時
        if PrefUtil.loginedCheck() {
            
            // 以前のデータをすべて削除
            let realm = try! Realm()
            try! realm.write {
                realm.deleteAll()
            }
            
            EscApiManager.resetToken()
            
            PrefUtil.saveLoginedState(false)
            //保存されていたpassIdを削除
            PrefUtil.removeSavedIdPass()
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
        guard Util.isConnectedToNetwork() else {
            DiagUtil.showWarningForInternet()
            return
        }
        
        //テキストフィールドチェック
        guard !Util.checkTextFiled(idTextField: idTextField,passwordTextField: passwordTextField) else{
            DiagUtil.showWarningForTextField()
            return
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
                        HttpConnector().request(type: .SCHEDULE, userId: userId, password: password, callback: { (result2) in
                            if result2 {
                                HttpConnector().request(type: .ATTENDANCE_RATE, userId: userId, password: password, callback: { (result3) in
                                    DiagUtil.hideIndicator()

                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                        if result3 {
                                            DiagUtil.showSuccess(string:"ログインに\n成功しました")
                                        } else {
                                            DiagUtil.showError(string: "出席情報の取得に\n失敗しました")
                                        }
                                    }
                                    
                                    DispatchQueue.main.async {
                                        //ログインしたことを保存
                                        PrefUtil.saveLoginState(true)
                                        //passIdを保存
                                        PrefUtil.saveIdPass(userId, pass: password)
                                        // 時間割画面へ
                                        let storyboard: UIStoryboard = self.storyboard!
                                        let nextView = storyboard.instantiateViewController(withIdentifier: "MainView") as! UITabBarController
                                        self.present(nextView, animated: true, completion: nil)
                                        
                                    }
                                    
                                })
                            } else {
                                //失敗
                                DiagUtil.hideIndicator()
                                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    DiagUtil.showError(string: "失敗しました")
                                }
                            }
                        })
                        
                    } else {
                        //失敗
                        DiagUtil.hideIndicator()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            DiagUtil.showError(string: "失敗しました")
                        }
                    }
                })
            }else{
                DiagUtil.hideIndicator()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    DiagUtil.showError(string: "失敗しました")
                }
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

