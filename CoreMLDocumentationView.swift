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
                        Button(action: {
                            isModalCOMLShowed = true
                        }){
                            Text("Try with images") .foregroundColor(.white)
                                .padding(.horizontal, 50)
                                .padding(.vertical, 10)
                                .background(.red)
                                .cornerRadius(13.0)
                        }.padding().sheet(isPresented: $isModalCOMLShowed) {
                            ImageClassificationView()
                        }
                        Spacer()
                    }
                } header: {
                    Text("Recognize objects in images.")
                } footer: {
                    Text("To recognize objects in images using machine learning models, you would typically leverage technologies like Core ML or machine learning frameworks like Create ML. For instance, in the provided example, you can identify various fruits from your iPhone image library, including Apple, Avocado, Banana, Kaki, Kiwi, Lemon, Orange, Pear, Pineapple, and Pomegranate. To use your custom model, place it in the 'YourModelHere' folder and update the filename reference in the 'ImageClassification' file, specifically on line 25. Make sure you enable the permissions in info.plist: Usage Camera description.")
                    
                }
                Section {
                    HStack() {
                        Spacer()
                        Button(action: {
                            isModalVideoShowed = true
                        }){
                            Text("Live Camera") .foregroundColor(.white)
                                .padding(.horizontal, 50)
                                .padding(.vertical, 10)
                                .background(.red)
                                .cornerRadius(13.0)
                        }.padding(.vertical, 20)
                        .sheet(isPresented: $isModalVideoShowed) {
                            VideoView()
                        }
                        Spacer()
                    }
                } header: {
                    Text("Recognize objects by using camera")
                } footer: {
                    Text("This example easily identify fruits using your camera and the recognition percentage is displayed on a label. To use your own model, put it in the 'YourModelHere' folder and adjust the filename reference in the 'UIAVCaptureVideoPreviewView' file, specifically on line 27. Enable the permissions in info.plist: Usage Camera description. Make sure you test this functionality by using the camera on your iphone. ")
                    
                }
            }
            
            .navigationTitle("CoreML")
        }
    }
}

#Preview {
    CoreMLDocumentationView().preferredColorScheme(.dark)
}
