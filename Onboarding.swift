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
                            Image(systemName: "camera.viewfinder")
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
                        Text("CreateML is Apple's framework for building and training machine learning models directly within Xcode. Hand pose classification,used for this app, is a specific application that involves training a model to recognize and classify different hand gestures from images or video frames. Developers collect and label a dataset, train the model using CreateML's tools, evaluate its performance, and integrate it into iOS or macOS apps using Core ML. This empowers developers to add intelligent hand gesture recognition features to their applications with ease.")
                            .lineSpacing(12.0)
                            .font(.custom("", size: 18))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 50)
                    
                    
                    
                HStack(spacing: 16.0) {
                    Image(systemName: "iphone.gen2")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                        .padding(.horizontal, 6)
                    VStack(alignment: .leading) {
                        Text("Develop")
                        Text("Implement with ease and bring your design to life! Follow the code to seamlessly implement.")
                            .foregroundColor(.secondary)
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
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

