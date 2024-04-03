//
//  Onboarding.swift
//  HearMeOut
//
//  Created by Yuri Mario Gianoli on 03/04/24.
//



import SwiftUI

struct Onboarding: View {
    @AppStorage("firstTime") var firstTime: Bool = true
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("Welcome to")
                Text("HearMeOut")
                    .foregroundColor(.accentColor)
            }
            .font(.title)
            .fontWeight(.bold)
            .padding(.bottom, 300)
            
            VStack(spacing: 20.0) {
                ScrollView(.vertical, showsIndicators: false){
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "hand.draw")
                                .font(.custom("", size: 33))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.accentColor)
                            Text("ASL")
                                .fontWeight(.bold)
                                .font(.title)
                                .foregroundColor(.accentColor)
                        }
                        Spacer()
                        Spacer()
                        Spacer()
                        Text("Sign languages, like American Sign Language (ASL), are vital forms of communication for the deaf and\nhard-of-hearing community.            Sign languages utilize handshapes for communication, it plays a crucial role in fostering inclusivity and minimizing communication barriers, essential for creating more inclusive societies.")
                            .lineSpacing(12.0)
                            .font(.custom("", size: 18))
                            .foregroundColor(.white)
                    }
                
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "cpu")
                                .font(.custom("", size: 40))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.accentColor)
                            Text("CreateML")
                                .fontWeight(.bold)
                                .font(.title)
                                .foregroundColor(.accentColor)
                        }
                        Spacer()
                        Spacer()
                        Spacer()
                        Text("CreateML is Apple's framework for building and training machine learning models directly within Xcode. Hand pose classification,used for this app, is a specific application that involves training a model to recognize and classify different hand gestures from images or video frames. Developers collect and label a dataset, train the model using CreateML's tools, evaluate its performance, and integrate it into iOS and macOS using Core ML. This empowers developers to add intelligent hand gesture recognition features to their applications.")
                            .lineSpacing(12.0)
                            .font(.custom("", size: 18))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 50)
                    
                    
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "camera.viewfinder")
                                .font(.custom("", size: 40))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.accentColor)
                            Text("HearMeOut")
                                .fontWeight(.bold)
                                .font(.title)
                                .foregroundColor(.accentColor)
                        }
                        Spacer()
                        Spacer()
                        Spacer()
                        Text("HearMeOut is an application that utilizes a machine learning model to recognize certain letters of the American Sign Language (ASL) through the device's camera. The app provides a demo of the capabilities of hand gesture recognition in CreateML and aims to promote inclusivity for the deaf community.")
                            .lineSpacing(12.0)
                            .font(.custom("", size: 18))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 50)
            }
            
            .padding(.horizontal, 28)
            .symbolRenderingMode(.hierarchical)
            
            
        }
            .padding(.top, -250)
                Button {
                    print("Continue tapped!")
                    firstTime.toggle()
                } label: {
                    Text("Continue")
                        .padding(8)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .cornerRadius(16)
                
            }
            .padding(.horizontal)
            Spacer()
        }
    }


#Preview {
    Onboarding().preferredColorScheme(.dark)
}

