//
//  TimeTableView1.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/09.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import UIKit

//@IBDesignable
class TimeTableView1: UIView ,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    // privateフィールド ----------------------------------------------------
    
    private let cellMargin : CGFloat = 0.0
    private var itemCount:Int = 0
    private var colCount:Int = 5
    // セルの幅に対するセルの高さの割合
    private var cellHeightProportion :CGFloat = 1.2
    
    // データ
    private var rootTimeTable: RootTimeTable? = nil
    
    
    
    // public methods  -------------------------------------------------------
    
    // cellの幅に対するcellの縦の割合のsetter
    public func setCellHightProportion(proportion:CGFloat){
        self.cellHeightProportion = proportion
    }
    
    // RootTimeTableViewをセットする
    public func setData(rootTimeTable:RootTimeTable){
        self.rootTimeTable = rootTimeTable
    }
    
    public func getTimeTableCollectionView(){
        
    }
//    override func viewWillLayoutSubviews() {
//    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            //here you can do the logic for the cell size if phone is in landscape
            cellHeightProportion = 0.6
        } else {
            //logic if not landscape
            cellHeightProportion = 1.2
        }
        
        flowLayout.invalidateLayout()
    }
    
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
        let nib = UINib(nibName: "TimeTableView1", bundle: bundle)
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
    
    
    
    
    
    
    //セルサイズの指定（UICollectionViewDelegateFlowLayoutで必須）　横幅いっぱいにセルが広がるようにしたい
    // Screenサイズに応じたセルサイズを返す
    // UICollectionViewDelegateFlowLayoutの設定が必要
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widths:CGFloat = collectionView.frame.size.width/CGFloat(colCount)
        let heights:CGFloat = widths * cellHeightProportion
        
        return CGSize(width:widths,height:heights)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
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
        
//        // Cell はストーリーボードで設定したセルのID
//        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeTableCell", for: indexPath)
////        let subjectLabel = cell.contentView.viewWithTag(1) as! UILabel
////        let roomLabel = cell.contentView.viewWithTag(2) as! UILabel
////        //        // Tag番号を使ってImageViewのインスタンス生成
////        //        let imageView = testCell.contentView.viewWithTag(1) as! UIImageView
////        //        // 画像配列の番号で指定された要素の名前の画像をUIImageとする
////        //        let cellImage = UIImage(named: photos[(indexPath as NSIndexPath).row])
////        //        // UIImageをUIImageViewのimageとして設定
////        //        imageView.image = cellImage
////        //
////        //        testCell.backgroundColor = UIColor.green
////        
////        subjectLabel.text = ""
////        roomLabel.text = ""
////        
//        return cell
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
    

}
