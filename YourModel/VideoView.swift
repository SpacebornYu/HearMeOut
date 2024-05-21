import SwiftUI

struct VideoView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var cameraManager = CameraManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                if Platform.isSimulator {
                    Text("Oops! You are using the Simulator 👀.\nRun the App on an iPhone to use the live Camera.")
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    SwiftUIAVCaptureVideoPreviewView(cameraManager: cameraManager)
                        .edgesIgnoringSafeArea(.all)
                    
                    if let prediction = cameraManager.handPrediction {
                        VStack {
                            Text(prediction)
                                .font(.largeTitle)
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .padding()
                            Spacer()
                        }
                        .padding(.top, 50) // Padding to avoid overlapping with the notch
                    }
                }
            }
            .navigationTitle("Camera")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "x.circle")
                            .padding(.top)
                    }
                }
            }
        }
    }
}

struct Platform {
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}

#Preview {
    VideoView().preferredColorScheme(.dark)
}
