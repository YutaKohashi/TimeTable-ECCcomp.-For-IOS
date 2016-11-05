//
//  PreferenceController.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/11/02.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


class PreferenceController : UITableViewController{
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let btn_back = UIBarButtonItem()
        btn_back.title = ""
        
//        self.navigationItem.backBarButtonItem?.tintColor
        
        self.navigationItem.backBarButtonItem = btn_back
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //完了ボタンが押下されたとき
    @IBAction func doneButtonClick(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        switch indexPath.section {
        case 0:
            if(indexPath.row == 0){
                DialogManager().showIndicator()
                HttpRequest().updateTimetable(userId: SaveManager().getSavedId(), password: SaveManager().getSavedPass(),callback: {
                    requestResultBool in
                    if (requestResultBool){
                        DialogManager().hideIndicator()
                        let sec:Double = 0.8
                        let delay = sec * Double(NSEC_PER_SEC)
                        let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                        DispatchQueue.main.asyncAfter(deadline: time, execute: {
                             DialogManager().showSuccess()
                        })
                        
                    }else{
                        DialogManager().hideIndicator()
                        let sec:Double = 0.8
                        let delay = sec * Double(NSEC_PER_SEC)
                        let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                        DispatchQueue.main.asyncAfter(deadline: time, execute: {
                            DialogManager().showError()
                        })
                    }
                })
            }
            break
        case 1:
            break
        case 2:
            if (indexPath.row == 0){
                //ログアウト
              logout()
            }
            break
        default:
            break
            
        }
        //タップしたあとハイライトを消す
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override var prefersStatusBarHidden : Bool {
        // trueの場合はステータスバー非表示
        return false;
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        // ステータスバーを白くする
        return UIStatusBarStyle.lightContent;
    }
    
    // ログアウト
    func logout(){
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "確認", message: "ログアウトしてもよろしいですか？", preferredStyle:   UIAlertControllerStyle.alert)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
            let realm = try! Realm()
            try! realm.write {
                realm.deleteAll()
            }
            
            let ud = UserDefaults.standard
            ud.set(false, forKey: "login")
            ud.synchronize()
            
            //保存されていたpassIdを削除
            SaveManager().removeSavedIdPass()
            
            DispatchQueue.main.async(execute: {
                //View controller code
                let storyboard: UIStoryboard = self.storyboard!
                let nextView = storyboard.instantiateViewController(withIdentifier: "LoginView") as! ViewController
                self.present(nextView, animated: true, completion: nil)
            })
        })
        
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
    }
}
