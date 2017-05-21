//
//  AppDelegate.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2016/09/24.
//  Copyright © 2016年 YutaKohashi. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    private var viewController:UIViewController = UIViewController()
    private var storyboard:UIStoryboard = UIStoryboard()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // background fetch
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        // delegate
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            // Fallback on earlier versions
        }
        
        storyboard =  UIStoryboard(name: "Main",bundle:nil)
        
        
        // 700ミリ秒
        usleep(600)
        
        //表示するビューコントローラーを指定
        if  PrefUtil.loginCheck() {
            //ログイン処理が完了しているとき(withIdentifier: "MainView") as! UITabBarController
            viewController = storyboard.instantiateViewController(withIdentifier: "MainView") as UIViewController
        } else {
            //ログイン処理が完了していない
            viewController = storyboard.instantiateViewController(withIdentifier: "LoginView") as UIViewController
        }
        
        
        window?.rootViewController = viewController
        
        // realm miglation
        let config = Realm.Configuration(
            // 新しいスキーマバージョンを設定します。 これは以前に使用されたものよりも大きくなければなりません
            // version（以前にスキーマバージョンを設定していない場合、バージョンは0です）。
            schemaVersion: 1,
            
            //スキーマのバージョンが上記のものよりも低い/を開くときに自動的に呼び出されるブロックを設定する
            migrationBlock: { migration, oldSchemaVersion in
                //まだ何も移行していないので、oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Realmは新しいプロパティと削除されたプロパティを自動的に検出します
                    //そして自動的にディスク上のスキーマを更新する
                    print()
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        //デフォルトのレルムに対してこの新しい設定オブジェクトを使用するようにRealmに指示します
        let realm = try! Realm()
        print(realm, "Realm")
        print(config,"Realm Version")
        
        
        
        return true
    }
    
    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
        -> Void) {
        
        if !PrefUtil.loginCheck() {
            completionHandler(UIBackgroundFetchResult.failed)
            return
        }
        
        if !Util.isConnectedToNetwork() {
            completionHandler(UIBackgroundFetchResult.failed)
            return
        }
        
        let beforeTaninNews:Results<TaninNewsItem>? = TaninNewsAccessor.sharedInstance.getAll()
        let beforeSchoolNews:Results<SchoolNewsItem>? = SchoolNewsAccessor.sharedInstance.getAll()
        let userId = PrefUtil.getSavedId()
        let pass = PrefUtil.getSavedPass()
        
        if userId.isEmpty || pass.isEmpty {
            completionHandler(UIBackgroundFetchResult.noData)
            return
        }
        
        HttpConnector().request(type: .NEWS_SCHOOL_TEACHER, userId: userId, password: pass) { (callback) in
            if callback {
                let afterTaninNews = TaninNewsAccessor.sharedInstance.getAll()
                let afterSchoolNews = SchoolNewsAccessor.sharedInstance.getAll()
                
                
                let array1 = self.compareNotify(beforeTaninNews: beforeTaninNews, afterTaninNews: afterTaninNews)
                let array2 = self.compareNotify(beforeSchoolNews: beforeSchoolNews, afterSchoolNews: afterSchoolNews)
                if (array1 != nil && array1!.count > 0) || (array2 != nil && array2!.count > 0) {
                    // 新しい通知あり
                    // 通知登録
                    let center = UNUserNotificationCenter.current()
                    let content = UNMutableNotificationContent()
                    content.title = "新しいお知らせがあります"
                    
                    var newsItem:CommonNewsItem? = nil
                    var num:Int = 0
                    if array1 != nil {
                        array1!.forEach({ (item) in
                            content.body += "●" + item.title + "\n"
                            if newsItem == nil {
                                newsItem = CommonNewsItem()
                                newsItem!.title = item.title
                                newsItem!.date = item.date
                                newsItem!.from = item.from
                                newsItem!.newsId = item.newsId
                            }
                            num += 1
                        })
                    }
                    
                    if array2 != nil {
                        array2!.forEach({ (item) in
                            content.body += "●" + item.title + "\n"
                            if newsItem == nil {
                                newsItem = CommonNewsItem()
                                newsItem!.title = item.title
                                newsItem!.date = item.date
                                newsItem!.from = item.from
                                newsItem!.newsId = item.newsId
                            }
                            num += 1
                        })
                    }
                    
                    content.sound = UNNotificationSound.default()
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                    let identifier = "UYLLocalNotification"
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    center.removeAllDeliveredNotifications()
                    center.add(request, withCompletionHandler: { (error) in
                        if error != nil {
                            // Something went wrong
                            completionHandler(UIBackgroundFetchResult.failed)
                            return
                        }
                        
                        if num == 1 {
                            PrefUtil.setNotifyNewsTitle(title: newsItem!.title)
                            PrefUtil.setNotifyNewsDate(date: newsItem!.date)
                            PrefUtil.setNotifyNewsId(newsId: newsItem!.newsId)
                        } else {
                            PrefUtil.setNotifyNewsTitle(title: "")
                            PrefUtil.setNotifyNewsDate(date: "")
                            PrefUtil.setNotifyNewsId(newsId: -1)
                        }
                        
                        //                            print("action * action * action * action ")
                        completionHandler(UIBackgroundFetchResult.newData)
                        
                    })

                } else {
                    // 新しい通知なし
                    completionHandler(UIBackgroundFetchResult.noData)
                }
            } else {
                completionHandler(UIBackgroundFetchResult.failed)
            }
        }
    }
    

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Push Notifications のmessageを取得
        let body = response.notification.request.content.body
        print("\(body)")
        
        print("push VC")
        
        let newsDetailVC: NewsDetailViewController = self.storyboard.instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
        let title = PrefUtil.getNotifyNewsTItle()
        let date = PrefUtil.getNotifyNewsDate()
        let newsId = PrefUtil.getNotifyNewsNewsId()
        
        if title != "" && date != "" && newsId != -1 {
            newsDetailVC.setTitle(str: title)
            newsDetailVC.setDate(str: date)
            newsDetailVC.setNewsId(int: newsId)
            viewController.present(newsDetailVC, animated: true, completion: nil)
            PrefUtil.setNotifyNewsTitle(title: "")
            PrefUtil.setNotifyNewsDate(date: "")
            PrefUtil.setNotifyNewsId(newsId: -1)
        }
        
        completionHandler()
    }
    
    private func compareNotify(beforeTaninNews:Results<TaninNewsItem>?,
                               afterTaninNews:Results<TaninNewsItem>?) -> Array<TaninNewsItem>?{
        guard afterTaninNews != nil else {
            return nil
        }
        
        guard beforeTaninNews != nil  else {
            return Array(afterTaninNews!)
        }
        
        var result:Array<TaninNewsItem> = Array<TaninNewsItem>()
        
        for item:TaninNewsItem in afterTaninNews! {
            if !beforeTaninNews!.contains(item){
                result.append(item)
            }
        }
        
        // stub----------------------------------------------
//        let item : TaninNewsItem = TaninNewsItem()
//        item.title = "kdkdkdたいとるたいとる"
//        item.newsId = 122
//        item.date = "ldlldひづけひづけ"
//        result.append(item)
        // stub----------------------------------------------
        
        return result
    }
    
    private func compareNotify(beforeSchoolNews:Results<SchoolNewsItem>?,
                               afterSchoolNews:Results<SchoolNewsItem>?) -> Array<SchoolNewsItem>?{
        guard afterSchoolNews != nil else {
            return nil
        }
        
        guard beforeSchoolNews != nil  else {
            return Array(afterSchoolNews!)
        }
        
        var result:Array<SchoolNewsItem> = Array<SchoolNewsItem>()
        
        for item:SchoolNewsItem in afterSchoolNews! {
            if !beforeSchoolNews!.contains(item){
                result.append(item)
            }
        }
        
        
        // stub----------------------------------------------
//        let item : SchoolNewsItem = SchoolNewsItem()
//        item.title = "たいとるたいとる"
//        item.newsId = 122
//        item.date = "ひづけひづけ"
//        result.append(item)
        // stub----------------------------------------------
        
        
        return result
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        // DBファイルのfileURLを取得
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //
        //        if let fileURL = Realm.Configuration.defaultConfiguration.fileURL {
        //            try! NSFileManager.defaultManager().removeItemAtURL(fileURL)
        //        }
        
        let alertController = UIAlertController(title: "Hello!", message: "This is Alert sample.", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        
        
        //        if ToolsBase().CheckReachability("google.com") {
        //            print("インターネットへの接続が確認されています")
        //        } else {
        //            //未接続
        //            //ダイアログ表示
        //            //KRProgressHUD.showWarning(progressHUDStyle: .whiteColor,maskType:.black,message:"インターネット未接続")
        //            print("インターネットに接続してください")
        //        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "jp.yuta.kohashi.EccStudentCom" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "EccStudentCom", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
    
    
    
    
}

