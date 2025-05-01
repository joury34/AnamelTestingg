//
//  AddCardView.swift
//  PECSApp
//
//  Created by Fatimah Alqarni on 30/04/2025.
//


import SwiftUI
import PhotosUI

struct AddCardView: View {
    @StateObject var viewModel = CardViewModel()
    @StateObject var recorder = AudioRecorder()

    @State private var text: String = ""
    @State private var selectedImage: UIImage?
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var isRecording = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }

                PhotosPicker(selection: $selectedPhotoItem, matching: .images, photoLibrary: .shared()) {
                    Text("اختيار صورة")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .onChange(of: selectedPhotoItem) { newItem in
                    if let newItem {
                        Task {
                            if let data = try? await newItem.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                selectedImage = uiImage
                            }
                        }
                    }
                }

                TextField("اكتب النص", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(isRecording ? "إيقاف التسجيل" : "تسجيل صوت") {
                    if isRecording {
                        recorder.stopRecording()
                    } else {
                        recorder.startRecording()
                    }
                    isRecording.toggle()
                }
                .padding()
                .background(isRecording ? .red : .blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("حفظ الكارت") {
                    guard let image = selectedImage else { return }
                    viewModel.saveCard(image: image, text: text, audioURL: recorder.recordingURL) { success in
                        if success {
                            print("✅ تم الحفظ بنجاح")
                            text = ""
                            selectedImage = nil
                            recorder.recordingURL = nil
                        } else {
                            print("❌ فشل في الحفظ")
                        }
                    }
                }
                .padding()
                .background(.green)
                .foregroundColor(.white)
                .cornerRadius(10)

                Spacer()
            }
            .padding()
            .navigationTitle("إضافة كارت")
            .onAppear {
                // نتأكد أن ownerID موجود
                if !viewModel.ownerID.isEmpty {
                    viewModel.subscribeToRequests(for: viewModel.ownerID)
                    UIApplication.shared.registerForRemoteNotifications()

                }
            }
        }
    }
}

#Preview {
    AddCardView()
}
