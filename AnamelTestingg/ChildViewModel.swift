//
//  ChildViewModel.swift
//  PECSApp
//
//  Created by Fatimah Alqarni on 30/04/2025.
//


import Foundation
import CloudKit
import UIKit

class ChildViewModel: ObservableObject {
    @Published var cards: [Card] = []
    @Published var ownerID: String = UserDefaults.standard.string(forKey: "ownerID") ?? ""

    private let publicDB = CKContainer.default().publicCloudDatabase

    func saveOwnerID() {
        UserDefaults.standard.set(ownerID, forKey: "ownerID")
    }

    func fetchCards() {
        let predicate = NSPredicate(format: "ownerID == %@", ownerID)
        let query = CKQuery(recordType: "Card", predicate: predicate)

        publicDB.perform(query, inZoneWith: nil) { records, error in
            DispatchQueue.main.async {
                self.cards = records?.compactMap { record in
                    guard let text = record["text"] as? String,
                          let imageAsset = record["image"] as? CKAsset,
                          let imageData = try? Data(contentsOf: imageAsset.fileURL!),
                          let image = UIImage(data: imageData) else {
                        return nil
                    }

                    let audioURL: URL? = (record["audio"] as? CKAsset)?.fileURL

                    return Card(image: image, text: text, audioURL: audioURL)
                } ?? []
            }
        }
    }
}
