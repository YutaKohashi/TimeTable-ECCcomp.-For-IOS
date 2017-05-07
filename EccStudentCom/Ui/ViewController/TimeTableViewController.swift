//
//  TImeTableViewController.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/10/30.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import UIKit
import RealmSwift
import KRProgressHUD

class TimeTableViewController: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate  , UICollectionViewDelegateFlowLayout {
    var refreshFlg:Bool = false
    
    // 時間割CollectionView
    @IBOutlet weak var timeTableCollectionView: UICollectionView!
    
    @IBOutlet weak var bottomSheetView: UIView!
    @IBOutlet weak var bottomCloseButton: UIButton!
    
    //Labels on BottomSheetView
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet var masterView: UIView!
    
    //　アイテムマージンを0にしてセルマージンを2.0にする
    private let cellMargin : CGFloat = 0.0
    private var itemCount:Int = 0
    private var colCount:Int = 5
    
    // セルの幅に対するセルの高さの割合
    private var cellHeightProportion :CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StatusBarManager().setStatusBarBackgroundColor(color: UIColor(red:0.00, green:0.29, blue:0.39, alpha:1.0))
        // ステータスバーのスタイル変更を促す
        self.setNeedsStatusBarAppearanceUpdate();
        
        
        
        
//        
//        initTableView()
        bottomSheetView.isHidden = true
        bottomCloseButton.isHidden = true
        bottomCloseButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //セルサイズの指定（UICollectionViewDelegateFlowLayoutで必須）　横幅いっぱいにセルが広がるようにしたい
    // Screenサイズに応じたセルサイズを返す
    // UICollectionViewDelegateFlowLayoutの設定が必要
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let numberOfMargin:CGFloat = 8.0
        let widths:CGFloat = collectionView.frame.size.width/CGFloat(colCount)
        let heights:CGFloat = widths * cellHeightProportion
        
        return CGSize(width:widths,height:heights)
        
        //        let cellSize:CGFloat = self.view.frame.size.width/5-2
        //        // 正方形で返すためにwidth,heightを同じにする
        //        return CGSize(width: cellSize, height: cellSize)
        //
        //        let padding: CGFloat = 25
        //        let collectionCellSize = collectionView.frame.size.width - padding
        //
        //        return CGSize(width: collectionCellSize/5, height: collectionCellSize/5)
    }
    
    
    // セル表示設定　---------------------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        // Cell はストーリーボードで設定したセルのID
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeTableCell", for: indexPath)
        let subjectLabel = cell.contentView.viewWithTag(1) as! UILabel
        let roomLabel = cell.contentView.viewWithTag(2) as! UILabel
        //        // Tag番号を使ってImageViewのインスタンス生成
        //        let imageView = testCell.contentView.viewWithTag(1) as! UIImageView
        //        // 画像配列の番号で指定された要素の名前の画像をUIImageとする
        //        let cellImage = UIImage(named: photos[(indexPath as NSIndexPath).row])
        //        // UIImageをUIImageViewのimageとして設定
        //        imageView.image = cellImage
        //
//        testCell.backgroundColor = UIColor.green
        
        subjectLabel.text = ""
        roomLabel.text = ""
        
        return cell
    }

    
    
    // コレクションビュー　---------------------------------------------------------------------------------
    
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
    
    

    
    
    
    // MARK: 画面回転時にセルの幅を再設定
    // 画面回転時にセルの幅を再設定 ------------------------------------------------------------------------
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = timeTableCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
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
    
    
    
    // MARK:　ステータスバー
    // ステータスバー ------------------------------------------------------------------------
    override var prefersStatusBarHidden : Bool {
        // trueの場合はステータスバー非表示
        return false;
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        // ステータスバーを白くする
        return UIStatusBarStyle.lightContent;
    }
    

    
    // ボトムシート ------------------------------------------------------------------------
    //closeButton
    @IBAction func bottomCloseButton(_ sender: AnyObject) {
        
        bottomCloseButton.isEnabled = false
        
        fadeOutAnimation()
        closeAnimation()
        subjectLabel.text = ""
        teacherLabel.text = ""
        timeLabel.text = ""
        
    }
    
    func setBottomSheet(){
        bottomSheetView.isHidden = false
        bottomCloseButton.isHidden = false
        openAnimation()
        fadeInAnimation()
    }
    
    private func getTime(index:Int) -> String{
        switch index {
        case 0:
            return "09:15 ~ 10:45"
        case 1:
            return "11:00 ~ 12:30"
        case 2:
            return "13:30 ~ 15:00"
        case 3:
            return "15:15 ~ 16:45"
        case 3:
            return "17:00 ~ 18:30"
        default:
            return ""
        }
    }
    
    // アニメーション ------------------------------------------------------------------------
    
    private let ANIM_SPEED = 0.3
    
    private func openAnimation(){
        UIView.animate(withDuration: ANIM_SPEED, animations: {
            self.bottomSheetView.frame.origin.y = 150
            self.bottomCloseButton.isEnabled = true
        })
    }
    
    private func closeAnimation(){
        UIView.transition(with: bottomSheetView,
                          duration: 0.1,
                          options: .transitionCrossDissolve,
                          animations: {() -> Void in
                            self.bottomSheetView.isHidden = true
        }, completion: { _ in })
    }
    
    private  func fadeInAnimation(){
        UIView.animate(withDuration: ANIM_SPEED) { () -> Void in
            self.bottomCloseButton.alpha = 1.0
        }
    }
    private func fadeOutAnimation(){
        UIView.animate(withDuration: ANIM_SPEED) { () -> Void in
            self.bottomCloseButton.alpha = 0.0
        }
    }
    
}
