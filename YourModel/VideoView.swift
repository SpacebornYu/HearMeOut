import SwiftUI

struct VideoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                if Platform.isSimulator {
                    Text("Oops! You are using the Simulator 👀.\nRun the App on an iPhone to use the live Camera.")
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    SwiftUIAVCaptureVideoPreviewView()
                        .edgesIgnoringSafeArea(.all)
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
