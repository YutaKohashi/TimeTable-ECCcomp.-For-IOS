//
//  BottomSheetView.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/18.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import UIKit

class BottomSheetView: UIView {
    

    @IBOutlet var rootView: UIView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    fileprivate var containerView:UIView?

    
    
    // コンストラクタここから  ----------------------------------------------------
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        comminInit()
    }
    
    // Storyboard/xib から初期化はここから
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        comminInit()
    }
    
    // xibからカスタムViewを読み込んで準備する
    private func comminInit() {
        // MyCustomView.xib からカスタムViewをロードする
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "BottomSheetView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(view)
        
        // カスタムViewのサイズを自分自身と同じサイズにする
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                      options:NSLayoutFormatOptions(rawValue: 0),
                                                      metrics:nil,
                                                      views: bindings))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                      options:NSLayoutFormatOptions(rawValue: 0),
                                                      metrics:nil,
                                                      views: bindings))
        
        
        
        
    }
    
    // コンストラクタここまで  -----------------------------------------------
    
    
    func show() {
        containerView?.addSubview(self)
        containerView?.bringSubview(toFront: self)
//        containerView.rect
    }
    
    func dismiss(){
        containerView?.removeFromSuperview()
    }
}

class BottomSheetViewBuilder:Buildable {
    typealias BuildType = BottomSheetView
    
    private var subject:String?
    private var teacher:String?
    private var time:String?
    private var view :UIView?
    
    func setContainer(view:UIView) -> Self {
        self.view = view
        return self
    }
    
    func setSubject(subject:String) -> Self {
        self.subject = subject
        return self
    }
    
    func setTeacher(teacher:String)->Self{
        self.teacher = teacher
        return self
    }
    
    func setTime(num:Int)->Self{
        self.time = getTime(index: num)
        return self
    }
    
    func build() -> BottomSheetView {
        let result = BottomSheetView()
        result.containerView = view
        result.subjectLabel.text = subject
        result.teacherLabel.text = teacher
        result.timeLabel.text = time
        
        return result
    }
    
    
    private func getTime(index:Int) -> String{
        switch index {
        case 0:
            return "07:30 ~ 09:00"
        case 1:
            return "09:15 ~ 10:45"
        case 2:
            return "11:00 ~ 12:30"
        case 3:
            return "13:30 ~ 15:00"
        case 4:
            return "15:15 ~ 16:45"
        case 5:
            return "17:00 ~ 18:30"
        default:
            return ""
        }
    }
    
}

protocol Buildable {
    associatedtype BuildType
    
    func build() -> BuildType
}
