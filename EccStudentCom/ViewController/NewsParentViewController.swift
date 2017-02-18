//
//  NewsParentViewController.swift
//  EccStudentCom
//
//  Created by 小橋勇太 on 2017/02/17.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import UIKit

class NewsParentViewController: UIViewController {


    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setup(){
    }
    
    @IBAction func segmentButton(_ sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex {
//        case 0:
//            containerView.bringSubview(toFront: schoolNewsVC.view)
//        case 1:
//            containerView.bringSubview(toFront: taninNewsVC.view)
//        default:
//            print("")
//        }
    }
}
