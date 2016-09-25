//
//  TableViewController.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/09/25.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import UIKit
import RealmSwift

class TableViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        print("realm.objects(SaveModel).count =\(realm.objects(SaveModel).count)")
       tableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        // DBファイルのfileURLを取得
        if let fileURL = Realm.Configuration.defaultConfiguration.fileURL {
            try! NSFileManager.defaultManager().removeItemAtURL(fileURL)
        }
    }
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        print("realm.objects(SaveModel).count =\(realm.objects(SaveModel).count)")
        return realm.objects(SaveModel).count
//        return array.count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // セルを取得
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomCell") as! CustomTableViewCell
        
        let realm = try! Realm()
        let saveModel = realm.objects(SaveModel)
        
        cell.setCell(saveModel[indexPath.row].subjectName,unitNum: saveModel[indexPath.row].unit,attendanceNum: saveModel[indexPath.row].attendanceNumber,absentNum: saveModel[indexPath.row].absentNumber,lateNum: saveModel[indexPath.row].lateNumber,pubAbsentnum1: saveModel[indexPath.row].publicAbsentNumber1,pubAbsentnum2: saveModel[indexPath.row].publicAbsentNumber2,attendanceRateNum: saveModel[indexPath.row].attendanceRate,shortageNum: saveModel[indexPath.row].shortageNumber)
        
        
        return cell
        
    }

}
