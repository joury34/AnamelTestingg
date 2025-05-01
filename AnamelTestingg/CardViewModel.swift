//
//  CardViewModel.swift
//  PECSApp
//
//  Created by Fatimah Alqarni on 30/04/2025.
//


import CloudKit
import UIKit

class CardViewModel: ObservableObject {

    @Published var ownerID: String = ""
    private let publicDB = CKContainer.default().publicCloudDatabase

    init() {
        fetchOwnerID()
    }

    func fetchOwnerID() {
        CKContainer.default().fetchUserRecordID { recordID, error in
            if let recordID = recordID {
                DispatchQueue.main.async {
                    self.ownerID = recordID.recordName
                }
            }
        }
    }

    func saveCard(image: UIImage, text: String, audioURL: URL?, completion: @escaping (Bool) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(false)
            return
        }

        let cardRecord = CKRecord(recordType: "Card")
        cardRecord["text"] = text as CKRecordValue
        cardRecord["ownerID"] = ownerID as CKRecordValue

        let imageURL = writeDataToTemp(data: imageData, fileExtension: "jpg")
        cardRecord["image"] = CKAsset(fileURL: imageURL)

        if let audioURL = audioURL {
            cardRecord["audio"] = CKAsset(fileURL: audioURL)
        }

        publicDB.save(cardRecord) { record, error in
            DispatchQueue.main.async {
                completion(error == nil)
            }
        }
    }

    private func writeDataToTemp(data: Data, fileExtension: String) -> URL {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension(fileExtension)
        try? data.write(to: url)
        return url
    }
    
    func subscribeToRequests(for ownerID: String) {
        let predicate = NSPredicate(format: "ownerID == %@", ownerID)
        let subscription = CKQuerySubscription(recordType: "Request",
                                               predicate: predicate,
                                               subscriptionID: "request_subscription_\(ownerID)",
                                               options: .firesOnRecordCreation)

        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.alertBody = "طفلك أرسل طلبًا جديدًا"
        notificationInfo.soundName = "default"

        subscription.notificationInfo = notificationInfo

        CKContainer.default().publicCloudDatabase.save(subscription) { result, error in
            if let error = error {
                print("❌ فشل إنشاء الاشتراك: \(error.localizedDescription)")
            } else {
                print("✅ تم تفعيل استقبال الإشعارات للأم")
                print("🔔 اشتركت الأم بالإشعارات على ownerID: \(ownerID)")
            }
        }
    }

}
