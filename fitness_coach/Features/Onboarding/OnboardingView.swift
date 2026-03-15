import SwiftUI
import StoreKit

struct OnboardingView: View {
    
    @AppStorage("onbordingFinished") var onbordingFinished = false
    
    @State private var state: OnboardingState = .page1
    
    var body: some View {
        ZStack {
            Color(hex: "#100F0E")
                .ignoresSafeArea()
            
            TabView(selection: $state) {
                page1
                page2
                page3
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .foregroundStyle(.white)
            
            VStack {
                VStack(spacing: UIDevice.isSE ? 20 : 60) {
                    Button {
                        guard state != .page3 else {
                            onbordingFinished = true
                            return
                        }
                        
                        if state == .page1 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                                SKStoreReviewController.requestReview(in: scene)
                            }
                        }
                        
                        state = OnboardingState(rawValue: state.rawValue + 1) ?? .page1
                    } label: {
                        Text(state == .page3 ? "Start" : "Next")
                            .frame(height: 52)
                            .frame(maxWidth: 270)
                            .font(.inter(.bold, size: 19))
                            .foregroundStyle(.black)
                            .background(Color(hex: "#FFC409"))
                            .cornerRadius(8)
                    }
                    
                    
                    HStack(spacing: 6) {
                        ForEach(0..<OnboardingState.allCases.count, id: \.self) { index in
                            Circle()
                                .frame(width: 12, height: 12)
                                .foregroundStyle(Color(hex: "#FFC409").opacity(index == state.rawValue ? 1 : 0.5))
                        }
                    }
                    .frame(height: 12)
                    .opacity(state == .page1 ? 0 : 1)
                }
                .padding(.bottom, UIDevice.isSE ? 20 : 60)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .animation(.default, value: state)
    }
    
    private var page1: some View {
        VStack(spacing: 50) {
            Spacer()
            
            Image(.Images.Onbord.page1)
                .resizable()
                .scaledToFill()
                .padding(.top, 40)
            
            VStack(spacing: 16) {
                Text("Track Your\nPerformance")
                    .font(.inter(.semibold, size: UIDevice.isSE ? 24 : 36))
                    .foregroundStyle(.white)
                
                Text("Manage your workouts, track activitites\nproduction, and optimize it.")
                    .font(.inter(.regular, size: UIDevice.isSE ? 14 : 18))
                    .foregroundStyle(Color(hex: "#9E9E9E"))
            }
            
            Spacer()
            
            Color.clear
                .frame(height: 52)
                .padding(.bottom, 130)
        }
        .tag(OnboardingState.page1)
        .multilineTextAlignment(.center)
    }
    
    private var page2: some View {
        VStack {
            VStack {
                Image(.Images.Onbord.page2)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.top)
                
                Text("AI Personal\nTrainer")
                    .font(.inter(.semibold, size: UIDevice.isSE ? 24 : 36))
                    .foregroundStyle(.white)
            }
            
            Spacer()
            
            VStack(spacing: UIDevice.isSE ? 10 : 20) {
                RoundedRectangle(cornerRadius: 100)
                    .frame(width: 210, height: 1)
                
                Text("Smart analysis")
                    .font(.inter(.regular, size: 20))
                
                RoundedRectangle(cornerRadius: 100)
                    .frame(width: 210, height: 1)
                
                Text("Custom Tips")
                    .font(.inter(.regular, size: 20))
                
                RoundedRectangle(cornerRadius: 100)
                    .frame(width: 210, height: 1)
                
                Text("Stay Motivated")
                    .font(.inter(.regular, size: 20))
                
                RoundedRectangle(cornerRadius: 100)
                    .frame(width: 210, height: 1)
            }
            
            Spacer()
            
            Color.clear
                .frame(height: 52)
                .padding(.bottom, 130)
        }
        .tag(OnboardingState.page2)
        .multilineTextAlignment(.center)
        .foregroundStyle(.white)
    }
    
    private var page3: some View {
        VStack {
            VStack {
                Image(.Images.Onbord.page3)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.top)
                
                VStack {
                    Text("Stay Connected")
                        .font(.inter(.semibold, size: UIDevice.isSE ? 24 : 36))
                        .foregroundStyle(.white)
                    
                    Text("Everyday tracking hepls you to be\nin good physical condition")
                        .font(.inter(.regular, size: UIDevice.isSE ? 14 : 18))
                        .foregroundStyle(Color(hex: "#9E9E9E"))
                }
            }
            
            Spacer()
            
            VStack(spacing: UIDevice.isSE ? 30 : 80) {
                RoundedRectangle(cornerRadius: 100)
                    .frame(width: 210, height: 1)
                
                
                RoundedRectangle(cornerRadius: 100)
                    .frame(width: 210, height: 1)
                
                RoundedRectangle(cornerRadius: 100)
                    .frame(width: 210, height: 1)
            }
            
            Spacer()
            
            Color.clear
                .frame(height: 52)
                .padding(.bottom, 130)
        }
        .tag(OnboardingState.page3)
        .multilineTextAlignment(.center)
        .foregroundStyle(.white)
    }
}

#Preview {
    OnboardingView()
}
