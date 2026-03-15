import SwiftUI

struct SessionView: View {
    
    @ObservedObject var viewModel: SessionViewModel
    
    @State private var showStopAlert = false
    @State private var showAIChat = false
    
    @State private var selectedCondition: ExerciseCondition = .normal
    
    var body: some View {
        NavigationStack(path: $viewModel.navPath) {
            ZStack {
                Color(hex: "#100F0E")
                    .ignoresSafeArea()
                
                VStack {
                    navbar
                    
                    switch viewModel.sessionState {
                        case .noActive:
                            stumb
                        case .active(let session):
                            active(session)
                        case .pause(let session):
                            pause(session)
                    }
                }
                .animation(.default, value: viewModel.sessionState)
            }
            .onAppear {
                AppTabCoordinator.shared.shouldShowTabBar = true 
            }
            .navigationDestination(for: SessionScreen.self) { screen in
                switch screen {
                    case .complete(let session):
                        CompleteSessionView(session: session) {
                            viewModel.save(session)
                        }
                }
            }
            .fullScreenCover(isPresented: $showAIChat) {
                if #available(iOS 26.0, *) {
                    AIChatView()
                }
            }
            .alert("Are you sure you want to stop session?", isPresented: $showStopAlert) {
                Button("Yes", role: .destructive) {
                    viewModel.sessionState = .noActive
                }
            }
        }
    }
    
    private var navbar: some View {
        ZStack {
            HStack {
                switch viewModel.sessionState {
                    case .noActive:
                        if #available(iOS 26.0, *) {
                            Button {
                                showAIChat = true 
                            } label: {
                                Image(.Images.Session.aiChat)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32, height: 32)
                            }
                        } else {
                            EmptyView()
                        }
                    case .active(let session):
                        Button {
                            var newSession = session
                            newSession.pause()
                            viewModel.sessionState = .pause(newSession)
                        } label: {
                            Image(systemName: "stop.circle")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(Color(hex: "#FFC409"))
                        }
                    case .pause(let session):
                        Button {
                            var newSession = session
                            newSession.resume()
                            viewModel.sessionState = .active(newSession)
                        } label: {
                            Image(systemName: "play.circle")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(Color(hex: "#FFC409"))
                        }
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal, 16)
            
            Text("Session")
                .frame(maxWidth: .infinity)
                .font(.inter(.semibold, size: 36))
                .foregroundStyle(.white)
        }
        .frame(height: 95)
        .background(Color(hex: "#2F2F2F"))
        .overlay(alignment: .bottom) {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color(hex: "#858685"))
        }
    }
    
    private var stumb: some View {
        VStack(spacing: 32) {
            Image(.Images.Session.noActive)
                .resizable()
                .scaledToFit()
                .frame(width: 96, height: 96)
            
            VStack(spacing: 16) {
                Text("No Active Workout")
                    .font(.inter(.semibold, size: 36))
                    .foregroundStyle(.white)
                
                Text("Manage your hens, track egg production, and optimi.")
                    .font(.inter(.regular, size: 18))
                    .foregroundStyle(Color(hex: "#9E9E9E"))
            }
            .multilineTextAlignment(.center)
            
            Spacer()
            
            Button {
                AppTabCoordinator.shared.currentState = .exercises
            } label: {
                Text("Choose Workout")
                    .frame(width: 270, height: 52)
                    .font(.inter(.bold, size: 19))
                    .background(Color(hex: "#FFC409"))
                    .foregroundStyle(Color(hex: "#100F0E"))
                    .cornerRadius(8)
            }
        }
        .padding(.vertical, 32)
        .padding(.bottom, 120)
    }
    
    private func active(_ session: Session) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 32) {
                CountdownCircle(session: session) {
                    var newSession = session
                    newSession.exercise.condition = selectedCondition
                    viewModel.navPath.append(.complete(newSession))
                }
                .padding(.top, 30)
                .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 150 : 30)
                .frame(maxHeight: 300)
                .overlay {
                    VStack {
                        if session.endDate > Date() {
                            Text(session.endDate, style: .timer)
                                .font(.inter(.semibold, size: 48))
                        } else {
                            Text("Completed")
                                .font(.inter(.semibold, size: 32))
                        }
                        
                        Text(session.exercise.name)
                            .font(.inter(.semibold, size: 32))
                    }
                    .foregroundStyle(.white)
                }
                
                HStack(spacing: 8) {
                    ForEach(ExerciseCondition.allCases) { condition in
                        Button {
                            selectedCondition = condition
                        } label: {
                            Text("\(condition.icon) \(condition.title)")
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .font(.inter(.regular, size: 18))
                                .foregroundStyle(.white)
                                .background(Color(hex: "#2F2F2F"))
                                .cornerRadius(12)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedCondition == condition ?
                                                condition.color : .white.opacity(0.5), lineWidth: 3)
                                }
                        }
                    }
                }
                
                VStack {
                    HStack {
                        Text("Workout name:")
                            .foregroundStyle(.white)
                        
                        Text(session.exercise.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(Color(hex: "#FFC409"))
                    }
                    
                    HStack {
                        Text("Total duration:")
                            .foregroundStyle(.white)
                        
                        Text(session.exercise.duration.formatted() + " min")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(Color(hex: "#FFC409"))
                    }
                    
                    HStack {
                        Text("Calories burned:")
                            .foregroundStyle(.white)
                        
                        Text(session.exercise.totalCalories.formatted() + " kcal")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(Color(hex: "#FFC409"))
                    }
                }
                .padding(16)
                .font(.inter(.regular, size: 18))
                .background(Color(hex: "#2F2F2F"))
                .cornerRadius(24)
            }
            .padding(.horizontal, 16)
            
            Color.clear
                .frame(height: 70)
        }
    }
    
    private func pause(_ session: Session) -> some View {
        VStack {
            Spacer()
            
            VStack {
                Text(remainingTimeString(session: session, until: session.pausedAt ?? session.endDate))
                    .font(.inter(.bold, size: 48))
                
                Text("Paused")
                    .font(.inter(.bold, size: 32))
            }
            
            Spacer()
            
            VStack {
                Button {
                    var newSession = session
                    newSession.resume()
                    viewModel.sessionState = .active(newSession)
                } label: {
                    Text("Resume")
                        .frame(height: 52)
                        .frame(maxWidth: .infinity)
                        .font(.inter(.bold, size: 19))
                        .background(Color(hex: "#FFC409"))
                        .foregroundStyle(Color(hex: "#100F0E"))
                        .cornerRadius(8)
                }
                
                Button {
                    showStopAlert = true
                } label: {
                    Text("End session")
                        .frame(height: 52)
                        .frame(maxWidth: .infinity)
                        .font(.inter(.bold, size: 19))
                        .background(Color(hex: "#100F0E"))
                        .foregroundStyle(.red)
                        .cornerRadius(8)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.red, lineWidth: 1)
                        }
                }
            }
            .frame(width: 270)
            .padding(.bottom, 120)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .foregroundStyle(.white)
    }

    private func remainingTimeString(session: Session, until date: Date) -> String {
        let remaining = max(session.endDate.timeIntervalSince(date), 0)

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad

        return formatter.string(from: remaining) ?? "00:00"
    }
}

#Preview {
    SessionView(viewModel: SessionViewModel())
}

