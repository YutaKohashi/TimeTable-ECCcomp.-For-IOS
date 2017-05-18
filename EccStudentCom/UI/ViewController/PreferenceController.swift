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
    
    @IBOutlet weak var versionLabel: UILabel!
    let sections:[String] = ["　時間割","　その他"]
    
    @IBOutlet weak var updateTimeTableLabel: UITableViewCell!
    @IBOutlet weak var logoutTimeTableViewCell: UITableViewCell!
    @IBOutlet weak var aboutTimteTableViewCell: UITableViewCell!
    @IBOutlet weak var lisenseTimeTableViewCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let btn_back = UIBarButtonItem()
        btn_back.title = ""
        self.navigationItem.backBarButtonItem = btn_back
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        versionLabel.text = PrefUtil.NOW_VERSION
        
        let color:UIColor = UIColor(red:0.00, green:0.55, blue:0.76, alpha:1.0)
        updateTimeTableLabel.selectedBackgroundColor = color
        logoutTimeTableViewCell.selectedBackgroundColor = color
        aboutTimteTableViewCell.selectedBackgroundColor = color
        lisenseTimeTableViewCell.selectedBackgroundColor = color
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //完了ボタンが押下されたとき
    @IBAction func doneButtonClick(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label : UILabel = UILabel()

       label.font = UIFont(name: label.font.fontName, size: 13)
        label.textColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        if(section == 0){
            label.text = sections[section]
        } else if (section == 1){
            label.text = sections[section]
        }
        return label
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        switch indexPath.section {
        case 0:
            if(indexPath.row == 0){
                
                //インターネットに接続されていないのときはアラート表示
                if !Util.isConnectedToNetwork(){
                    DiagUtil.showWarningForInternet()
                    return;
                }
                
                DiagUtil.showIndicator()
                HttpConnector().request(type: .TIME_TABLE,
                                        userId: PrefUtil.getSavedId(),
                                        password: PrefUtil.getSavedPass(),
                                        callback:
                    { (result) in
                        if(result){
                            
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
                                DiagUtil.hideIndicator()
//                                sleep(1)
                                DiagUtil.showSuccess(string: "更新しました")
                            }
                         
                        }
                        else
                        {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                                DiagUtil.hideIndicator()
                                
                                 DiagUtil.showError(string:"エラー")
                            }
                        }
                })
            }
            break
        case 1:
            //セクションを削除追加することで変化するので注意
            if (indexPath.row == 0){
                //ログアウト
                logout()
            }
            break
        case 2:
            
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
        let alert: UIAlertController = UIAlertController(title: "確認",
                                                         message: "ログアウトしてもよろしいですか？",
                                                         preferredStyle:   UIAlertControllerStyle.alert)
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            print("OK")
            let realm = try! Realm()
            try! realm.write {
                realm.deleteAll()
            }
            
            EscApiManager.resetToken()
            
            PrefUtil.saveLoginState(false)
            //保存されていたpassIdを削除
            PrefUtil.removeSavedIdPass()
            
            DispatchQueue.main.async(execute: {
                //View controller code
                let storyboard: UIStoryboard = self.storyboard!
                let nextView = storyboard.instantiateViewController(withIdentifier: "LoginView") as! ViewController
                self.present(nextView, animated: true, completion: nil)
            })
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
}
