//
//  ChildView.swift
//  PECSApp
//
//  Created by Fatimah Alqarni on 30/04/2025.
//


import SwiftUI

struct ChildView: View {
    @StateObject private var viewModel = ChildViewModel()
    @State private var audioPlayer = AudioPlayer()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.cards.isEmpty {
                    VStack(spacing: 12) {
                        
                        
                        
                        Text("أدخل رمز الأم (ownerID):")
                            .font(.headline)

                        TextField("مثال: A1B2C3...", text: $viewModel.ownerID)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        Button("حفظ وعرض الكروت") {
                            viewModel.saveOwnerID()
                            viewModel.fetchCards()
                        }
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.cards.indices, id: \.self) { index in
                                let card = viewModel.cards[index]
                                VStack(spacing: 10) {
                                    Image(uiImage: card.image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 200)

                                    Text(card.text)
                                        .font(.title3)
                                        .padding(.horizontal)

                                    if let audioURL = card.audioURL {
                                        Button("تشغيل الصوت") {
                                            audioPlayer.play(url: audioURL)
                                        }
                                        .padding(.horizontal)
                                        .padding(.vertical, 8)
                                        .background(.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        
                                        Button("📤 إرسال إشعار للأم") {
                                            RequestSender.sendRequest(cardText: card.text, ownerID: viewModel.ownerID)
                                        }
                                        .padding(.horizontal)
                                        .padding(.vertical, 8)
                                        .background(.orange)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)

                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .shadow(radius: 2)
                            }
                        }
                        .padding()
                    }
                    .navigationTitle("كروت الأم")
                }
            }
        }
    }
}

#Preview {
    ChildView()
}


//_afc9f5c7143a14644961be2110952d03
