
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
                                .background(.red)
                                .cornerRadius(13.0)
                        }
                        .padding(.vertical, 20)
                            
                            .sheet(isPresented: $isModalVideoShowed) {
                                VideoView()
                            }
                        Spacer()
                    }
                } header: {
                    Text("Recognize ASL letters by using\nthe camera")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                } footer: {
                    Text("Thanks to the 'Hand Pose Classification' model and a specific-made Machine Learning model, with this app you are able to perform (via the phone camera) American Sign Language letters get as a result the corrisponding alphabetic letter. ")
                        .fontWeight(.semibold)
                    
                }
            }
            .navigationTitle("ASL CoreML")
        }
    }
}

#Preview {
    CoreMLDocumentationView().preferredColorScheme(.dark)
}
