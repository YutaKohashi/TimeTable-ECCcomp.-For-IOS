//
//  CalendarViewController.swift
//  EccStudentCom
//
//  Created by 小橋勇太 on 2017/03/20.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Util.setStatusBarBackgroundColor(color: Util.getPrimaryColor())
        // ステータスバーのスタイル変更を促す
        self.setNeedsStatusBarAppearanceUpdate();
        // Do any additional setup after loading the view.
    }

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

}
