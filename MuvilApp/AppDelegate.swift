//
//  AppDelegate.swift
//  MuvilApp
//
//  Created by Fernando Pérezon 10/15/21.
//

import UIKit
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var loginResponse: LoginResponse?
    var operatorResponse: OperatorResponse?
    var schoolResponse: SchoolResponse?
    var courseResponse: CourseResponse?
    var vehiculeLocationResponse: [VehiculeLocationResponse]?
    var notificationResponse: [NotificationResponse]?
    var courseWithDetailResponse: [CourseWithDetailResponse]?
    var courseSelected: Int?
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.playback, mode: .moviePlayback)
            }
            catch {
                print("Setting category to AVAudioSessionCategoryPlayback failed.")
            }
        return true
    }
}

