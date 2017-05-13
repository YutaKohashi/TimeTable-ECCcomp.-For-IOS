//
//  TimeTableView1.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/09.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import UIKit
import RealmSwift


protocol TimeTableDelegate: class {
    func onCellTap(timeTable:TimeTable)
}

//@IBDesignable
class TimeTableView1: UIView ,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    

    @IBOutlet weak var headerHiddenSatSun: UIStackView!
    @IBOutlet weak var headerHiddenSat: UIStackView!
    @IBOutlet weak var headerHiddenSun: UIStackView!
    @IBOutlet weak var headerAll: UIStackView!
    
    
    // privateフィールド ----------------------------------------------------
    
    private let cellMargin : CGFloat = 0.0
    private var itemCount:Int = 0
    private var colCount:Int = 7
    // セルの幅に対するセルの高さの割合
    private var cellHeightProportion :CGFloat = 1.2
    
    // データ
    private var rootTimeTable: RootTimeTable? = nil
    private var timeTableItems:Results<TimeTableItem>? = nil
    
    // ヘッダタイプ
    private var isEnable0gen:Bool = true
    private var isEnable5gen:Bool = true
    private var isEnableSun:Bool = true
    private var isEnableSat:Bool = true
    
    // public methods  -------------------------------------------------------
    
    // RootTimeTableViewをセットする
//    public func setData(rootTimeTable:RootTimeTable){
//        self.rootTimeTable = rootTimeTable
//    }
    public func setData(timeTableItems:Results<TimeTableItem>){
        self.timeTableItems = timeTableItems
    }
    
    
//    // ヘッダタイプを設定する
//    public func setHeaderType(type:HeaderType){
//        headerType = type
//        
//        // ヘッダタイプを適用
//        switch headerType {
//        case .ALL: break
//        case .HIDE_SAT:
//            isEnableSat = false
//            colCount -= 1
//        case .HIDE_SUN:
//            isEnableSun = false
//            colCount -= 1
//        case .HIDE_SAT_SUN:
//            isEnableSun = false
//            isEnableSat = false
//            colCount -= 2
//        }
//    }

    public func setType(isEnable0gen:Bool, isEnable5gen :Bool, isEnableSun:Bool, isEnableSat:Bool){
        self.isEnable0gen = isEnable0gen
        self.isEnable5gen = isEnable5gen
        self.isEnableSat = isEnableSat
        self.isEnableSun = isEnableSun
        
        self.colCount = 7
        if(!isEnableSun){
            self.colCount -= 1
        }
        if(!isEnableSat){
            self.colCount -= 1
        }
        
        // set itemcount
        itemCount = 42
        if(!isEnable0gen){
            itemCount -= 7
        }
        if(!isEnable5gen){
            itemCount -= 7
        }
        
        if(!isEnableSun){
            if(!isEnable0gen && !isEnable5gen){
                itemCount -= 4
            } else if(!isEnable0gen || !isEnable5gen){
                itemCount -= 5
            } else {
                itemCount -= 6
            }
        }
        
        if(!isEnableSat){
            if(!isEnable0gen && !isEnable5gen){
                itemCount -= 4
            } else if(!isEnable0gen || !isEnable5gen){
                itemCount -= 5
            } else {
                itemCount -= 6
            }
        }
        
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
    

    override func layoutSubviews() {
        // ヘッダタイプを適用
        if(isEnableSat && isEnableSun){
            headerHiddenSatSun.isHidden = true
            headerHiddenSat.isHidden = true
            headerHiddenSun.isHidden = true
            headerAll.isHidden = false
        }else if(!isEnableSat && isEnableSun){
            headerHiddenSatSun.isHidden = true
            headerHiddenSat.isHidden = false
            headerHiddenSun.isHidden = true
            headerAll.isHidden = true
        } else if(isEnableSat && !isEnableSun){
            headerHiddenSatSun.isHidden = false
            headerHiddenSat.isHidden = true
            headerHiddenSun.isHidden = true
            headerAll.isHidden = true
        } else if(!isEnableSat && !isEnableSun){
            headerHiddenSatSun.isHidden = false
            headerHiddenSat.isHidden = true
            headerHiddenSun.isHidden = true
            headerAll.isHidden = true
        }
            }
    
    
    
    // 画面回転時の補正  -------------------------------------------------------

//    override func setNeedsLayout() {
    override func setNeedsLayout(){
        super.setNeedsLayout()
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        let isLandscape:Bool = Util.isLandscape()
      
        cellHeightProportion = self.getCellHeightProportion(isLandscape:isLandscape)
        
        flowLayout.invalidateLayout()
        print("colCount : " + String(colCount) + " " + String(describing: Date()))

    }
    
    
    // 端末、列数、画面の向きを考慮してセルの高さを指定する
    private func getCellHeightProportion(isLandscape:Bool) -> CGFloat{
        var proportion:CGFloat = 1.0
        let deviceType = Util.getDeviceType()
        
        if(isLandscape){
            //　横
            switch deviceType {
            case .iPadPro:
                proportion *= 0.7
                
                if(colCount == 7){
                    proportion *= 1.2
                } else if( colCount == 6){
                    proportion *= 1.0
                } else {
                    proportion *= 0.9
                }
            case .iPad:
                proportion *= 0.7
                
                if(colCount == 7){
                    proportion *= 1.2
                } else if( colCount == 6){
                    proportion *= 1.0
                } else {
                    proportion *= 0.9
                }
                
            case .iPhone5:
                proportion *= 0.7
                
                if(colCount == 7){
                    proportion *= 1.2
                } else if( colCount == 6){
                    proportion *= 1.0
                } else {
                    proportion *= 0.9
                }
                
            case .iPhone7:
//                proportion *= 0.8
                
                if(colCount == 7){
                    proportion *= 0.7
                } else if( colCount == 6){
                    proportion *= 0.6
                } else {
                    proportion *= 0.55
                }
                
            case .iPhone7sPlus:
                
                proportion *= 0.82
                if(colCount == 7){
                    proportion *= 0.9
                } else if( colCount == 6){
                    proportion *= 0.8
                } else {
                    proportion *= 0.7
                }
                
            case .undifined:
                proportion *= 1.0
            }
            
            
        } else {
            // 縦
            switch deviceType {
            case .iPadPro:
                proportion *= 1.3
                
                if(colCount == 7){
                    proportion *= 1.2
                } else if( colCount == 6){
                    proportion *= 1.0
                } else {
                    proportion *= 0.9
                }
            case .iPad:
                proportion *= 1.3
                
                if(colCount == 7){
                    proportion *= 1.2
                } else if( colCount == 6){
                    proportion *= 1.0
                } else {
                    proportion *= 0.9
                }
                
            case .iPhone5:
                proportion *= 1.5
                if(colCount == 7){
                    proportion *= 1.2
                }
                if(colCount == 6){
                    proportion *= 1.1
                }
                
            case .iPhone7:
                proportion *= 1.5
                
                if(colCount == 7){
                    proportion *= 1.3
                } else if( colCount == 6){
                    proportion *= 1.1
                } else {
                    proportion *= 1.0
                }
            case .iPhone7sPlus:
                proportion *= 1.5
                
                if(colCount == 7){
                    proportion *= 1.5
                } else if( colCount == 6){
                    proportion *= 1.2
                } else {
                    proportion *= 0.9
                }
            case .undifined:
                proportion *= 1.0
            }
            
         
        }
        
        return proportion
    }
    
    // ----------------------------------------------------------------------
    
    
    
    
    
    
    
    // Cell が選択された場合
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        // [indexPath.row] から画像名を探し、UImage を設定
//        selectedImage = UIImage(named: photos[(indexPath as NSIndexPath).row])
//        if selectedImage != nil {
//            // SubViewController へ遷移するために Segue を呼び出す
//            performSegue(withIdentifier: "toSubViewController",sender: nil)
//        }
        self.onCellTap(timeTable: (rootTimeTable?.timeTables[indexPath.row])!)
        
    }
    
    
    
    //セルサイズの指定（UICollectionViewDelegateFlowLayoutで必須）　横幅いっぱいにセルが広がるようにしたい
    // Screenサイズに応じたセルサイズを返す
    // UICollectionViewDelegateFlowLayoutの設定が必要
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widths:CGFloat = collectionView.frame.size.width/CGFloat(colCount) - 0.1
        let heights:CGFloat = widths * cellHeightProportion
        
        return CGSize(width:widths ,height:heights)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell:TimeTableViewCell = getCellLayout(indexPath: indexPath) as! TimeTableViewCell
//        cell.subject.text = String(describing: rootTimeTable?.timeTables[(indexPath as NSIndexPath).row].id)
        let timeTableItem = getTimeTableItem(index: (indexPath as NSIndexPath).row)
//        let timeTableItem:TimeTableItem = timeTableItems![indexPath.row]
        cell.subject.text = timeTableItem.subjectName
        cell.room.text = timeTableItem.room
        return cell
    }
    
    private func getCellLayout(indexPath: IndexPath) -> UICollectionViewCell! {
        let identifier: String = "TimeTableCell"
        var nibMyCellloaded: Bool = false
        if !nibMyCellloaded {
            let nib = UINib(nibName: "TimeTableCell", bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: identifier)
            nibMyCellloaded = true
        }
        let cell: UICollectionViewCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "TimeTableCell", for: indexPath))
        
        return cell
    }
    
    private func getTimeTableItem(index: Int) -> TimeTableItem {
        var i = index
        // 実際に表示されるとき何行目か---
        //割る数
        var col = 7
        if(!isEnableSat){
            col-=1
        }
        if(!isEnableSun){
            col-=1
        }
        var row = index / col
        
        if(!isEnable0gen){
            row += 1
        }
        
        if(!isEnable0gen){
            if(isEnableSat && isEnableSun){
                i += 7
            } else if(isEnableSat || isEnableSun){
                i += 6
            } else {
                i += 5
            }
        }
        
        if(!isEnableSun){
            i += (row + 1)
        }
        
        if(!isEnableSat){
            i += row
        }
        
        return timeTableItems![i]
    }
    
    
    //　セルに表示する要素数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
    
    // MARK: - delegate
    weak var delegate: TimeTableDelegate?
    func onCellTap(timeTable:TimeTable) {
        delegate?.onCellTap(timeTable: timeTable)
    }

}

//// ヘッダタイプを定義
//enum HeaderType {
//    case ALL
//    case HIDE_SAT
//    case HIDE_SUN
//    case HIDE_SAT_SUN
//}
