import SwiftUI

struct ExercisesView: View {
    
    @ObservedObject var sessionViewModel: SessionViewModel
     
    @State private var selectedType: ExerciseType?
    
    @State private var navPath: [ExerciseScreen] = []
    
    @State private var showAIChat = false
    
    var body: some View {
        NavigationStack(path: $navPath) {
            ZStack {
                Color(hex: "#100F0E")
                    .ignoresSafeArea()
                
                VStack {
                    navbar
                    exercises
                }
            }
            .onAppear {
                AppTabCoordinator.shared.shouldShowTabBar = true
            }
            .navigationDestination(for: ExerciseScreen.self) { screen in
                switch screen {
                    case .addExercise:
                        ExerciseAddView(navPath: $navPath)
                    case .setup(let exercise, let type):
                        ExcerciseSetupView(
                            sessionViewModel: sessionViewModel,
                            navPath: $navPath,
                            type: type,
                            exercise: exercise,
                        )
                }
            }
            .fullScreenCover(isPresented: $showAIChat) {
                if #available(iOS 26.0, *) {
                    AIChatView()
                }
            }
        }
    }
    
    private var navbar: some View {
        ZStack {
            HStack {
                if #available(iOS 26.0, *) {
                    Button {
                        showAIChat = true 
                    } label: {
                        Image(.Images.Session.aiChat)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal, 16)
            
            Text("Exercises")
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
    
    private var exercises: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 16),count: 2), spacing: 16) {
                ForEach(ExerciseType.allCases) { type in
                    Button {
                        if type == .custom {
                            AppTabCoordinator.shared.shouldShowTabBar = false
                            navPath.append(.addExercise)
                        } else {
                            AppTabCoordinator.shared.shouldShowTabBar = false
                            navPath.append(.setup(Exercise(isMock: false, type: type), type))
                        }
                    } label: {
                        VStack {
                            Image(type.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                            
                            Text(type.title)
                                .frame(maxWidth: .infinity)
                                .font(.inter(.bold, size: 18))
                                .foregroundStyle(.white)
                        }
                        .frame(height: 140)
                        .background(Color(hex: "#2F2F2F"))
                        .cornerRadius(24)
                    }
                }
            }
            .padding(.top)
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    ExercisesView(sessionViewModel: SessionViewModel())
}
