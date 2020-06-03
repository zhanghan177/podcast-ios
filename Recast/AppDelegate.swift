//
//  AppDelegate.swift
//  Recast
//
//  Created by Drew Dunne on 9/12/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataController: DataController!
    var tabBarController: UITabBarController!
    static var appDelegate: AppDelegate!

    override init() {
        super.init()
        AppDelegate.appDelegate = self
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow()

        // AVAudioSession
        NotificationCenter.default.addObserver(self, selector: #selector(beginInterruption), name: AVAudioSession.interruptionNotification, object: nil)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: [
                .interruptSpokenAudioAndMixWithOthers,
                .allowAirPlay,
                .allowBluetooth,
                .allowBluetoothA2DP
                ])
            #if DEBUG
            print("AudioSession active!")
            #endif
        } catch {
            #if DEBUG
            print("No AudioSession!! Don't know what do to here. ")
            #endif
        }
        
        dataController = DataController() {
            self.tabBarController = TabBarController()

            self.window = UIWindow()
            self.window?.rootViewController = self.tabBarController
            self.window?.makeKeyAndVisible()
        }

//        // Fabric
//        #if DEBUG
//        print("[Running Recast in debug configuration]")
//        #else
//        print("[Running Recast in release configuration]")
//        Crashlytics.start(withAPIKey: Keys.fabricAPIKey.value)
//        #endif
        FirebaseApp.configure()

        return true
    }

    @objc func beginInterruption() {
        // TODO: handle audio interruptions
        // need global player
    }

    // handles headphone events
    override func remoteControlReceived(with event: UIEvent?) {
        super.remoteControlReceived(with: event)
        if let e = event, e.type == .remoteControl {
            switch e.subtype {
            case .remoteControlPlay:
//                Player.sharedInstance.play()
                break
            case .remoteControlPause, .remoteControlStop:
//                Player.sharedInstance.pause()
                break
            case .remoteControlTogglePlayPause:
//                Player.sharedInstance.togglePlaying()
                break
            default:
                break
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
