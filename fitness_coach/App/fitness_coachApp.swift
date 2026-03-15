import SwiftUI

@main
struct fitness_coachApp: App {
    
    @AppStorage("onbordingFinished") var onbordingFinished = false
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if onbordingFinished {
                    AppTabView()
                        .transition(.slide.combined(with: .opacity))
                } else {
                    OnboardingView()
                }
            }
            .animation(.default, value: onbordingFinished)
        }
    }
}


