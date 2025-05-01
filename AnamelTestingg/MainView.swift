//
//  MainView.swift
//  PECSApp
//
//  Created by Fatimah Alqarni on 30/04/2025.
//


import SwiftUI
import UserNotifications

struct MainView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("اختَر نوع المستخدم")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)

                NavigationLink(destination: AddCardView()) {
                    Text("أنا الأم")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.purple)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                NavigationLink(destination: ChildView()) {
                    Text("أنا الطفل")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                Spacer()
            }
        }
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                print("📬 إشعار مسموح؟ \(granted)")

                if granted {
                    let content = UNMutableNotificationContent()
                    content.title = "اختبار إشعار"
                    content.body = "🎉 هذا إشعار محلي يعمل بنجاح!"
                    content.sound = .default

                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
                    let request = UNNotificationRequest(identifier: "test_notification", content: content, trigger: trigger)

                    UNUserNotificationCenter.current().add(request) { error in
                        if let error = error {
                            print("❌ فشل إرسال الإشعار المحلي: \(error.localizedDescription)")
                        } else {
                            print("✅ تم جدولة إشعار محلي")
                        }
                    }
                }
            }

        }
    }
}


#Preview {
    MainView()
}
