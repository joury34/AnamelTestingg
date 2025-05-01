//
//  RequestSender.swift
//  PECSApp
//
//  Created by Fatimah Alqarni on 30/04/2025.
//


import CloudKit

class RequestSender {
    static func sendRequest(cardText: String, ownerID: String) {
        let record = CKRecord(recordType: "Request")
        record["cardText"] = cardText as CKRecordValue
        record["ownerID"] = ownerID as CKRecordValue
        record["timestamp"] = Date() as CKRecordValue

        CKContainer.default().publicCloudDatabase.save(record) { record, error in
            if let error = error {
                print("❌ فشل إرسال الطلب: \(error.localizedDescription)")
            } else {
                print("✅ تم إرسال الطلب إلى CloudKit")
            }
        }
    }
}
