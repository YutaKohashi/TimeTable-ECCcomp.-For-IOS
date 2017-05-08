//
//  File.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/08.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import UIKit

//@IBDesignable
class TimeTableView:UIView,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//
//    // disp timetable
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sunHeaderLabel: UILabel!
    @IBOutlet weak var monHeaderLabel: UILabel!
    @IBOutlet weak var tueHeaderLabel: UILabel!
    @IBOutlet weak var wedHeaderLabel: UILabel!
    @IBOutlet weak var thuHeaderLabel: UILabel!
    @IBOutlet weak var friHeaderLabel: UILabel!
    @IBOutlet weak var satHeaderLabel: UILabel!
    
    // セルの幅に対するセルの高さの割合
    private var cellHeightProportion :CGFloat = 0.0
    private var rootTimeTable: RootTimeTable? = nil
    
    private let cellMargin : CGFloat = 0.0
    private var itemCount:Int = 0
    private var colCount:Int = 5
    
    // public methods ---------------------------------------------
    
    public func setCellHightProportion(proportion:CGFloat){
        self.cellHeightProportion = proportion
    }
    
    /**
    *RootTimeTableViewをセットする
    */
    public func setData(rootTimeTable:RootTimeTable){
        self.rootTimeTable = rootTimeTable
    }
    
    
    // コンストラクタ　-------------------------------------------------------
    // コードから初期化はここから
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
        let nib = UINib(nibName: "TimeTableView", bundle: bundle)
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
     // -----------------------------------------------------------------
    
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widths:CGFloat = self.frame.size.width/CGFloat(colCount)
        let heights:CGFloat = widths * cellHeightProportion
        
        return CGSize(width:widths,height:heights)
    }
    
    //　セルに表示する要素数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        itemCount = 20
        return itemCount
    }
    
    // セクション数設定
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    // レイアウト設定
    //セルのアイテムのマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0.0 , 0.0 , 0.0 , 0.0 )  //マージン(top , left , bottom , right)
    }
    
    //セルの水平方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }
    //セルの垂直方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
//        // TODO
////        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeTableCell", for: indexPath)
////        
////         return cell
//        return UICollectionViewCell()
        let identifier: String = "TimeTableCell"
        var nibMyCellloaded: Bool = false
        if !nibMyCellloaded {
            let nib = UINib(nibName: "TimeTableCell", bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: identifier)
            nibMyCellloaded = true
        }
        let cell: TimeTableViewCell? = (collectionView.dequeueReusableCell(withReuseIdentifier: "TimeTableCell", for: indexPath) as? TimeTableViewCell)
//        cell?.labelCell?.text = "Text"
        return cell!
    }
    
}


