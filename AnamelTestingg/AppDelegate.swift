//
//  AppDelegate.swift
//  PECSApp
//
//  Created by Fatimah Alqarni on 30/04/2025.
//


import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("📱 Device Token: \(token)")
        // هنا ممكن تحفظينه في CloudKit أو تعرضينه مؤقتًا
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ فشل التسجيل في APNs: \(error.localizedDescription)")
    }
}
