
//
//  CoreMLDocumentationView.swift
//  HearMeOut
//
//  Created by Yuri Mario Gianoli on 25/03/24.
//

import SwiftUI

struct CoreMLDocumentationView: View {
    @State var isModalCOMLShowed = false
    @State var isModalVideoShowed = false
    @AppStorage("firstTime") var firstTime: Bool = true
    @State var isSettingsShowed: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack() {
                        Spacer()
                        Button{
                            isModalVideoShowed = true
                        } label: {
                            Text("Live Demonstration")
                                .foregroundColor(.black)
                                .padding(.horizontal, 50)
                                .padding(.vertical, 10)
                                .background(.blue)
                                .cornerRadius(13.0)
                        }
                        .padding(.vertical, 20)
                            
                            .sheet(isPresented: $isModalVideoShowed) {
                                VideoView()
                            }
                        Spacer()
                    }
                }
            }
            .navigationTitle("ASL with CreateML")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                  
                    Button(action: {
                        isSettingsShowed.toggle()
                    }){
                        Image(systemName: "info.circle")
                    }.sheet(isPresented: $isSettingsShowed) {
                        Onboarding()
                    }
                    .padding(.trailing, 10)
                    .padding(.top, 90)
                    .font(.custom("", size: 20))
                    
                }
            }
        }
        .sheet(isPresented: $firstTime) {
                print("Onboarding dismissed!")
            } content: {
                Onboarding()
            }
    }
    
}

#Preview {
    CoreMLDocumentationView().preferredColorScheme(.dark)
}
