import SwiftUI

struct AppTabView: View {
    
    @ObservedObject private var coordinator = AppTabCoordinator.shared
    
    @StateObject private var sessionViewModel = SessionViewModel()
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $coordinator.currentState) {
                SessionView(viewModel: sessionViewModel)
                    .tag(TabState.session)
                    .toolbar(.hidden, for: .tabBar)
                
                ExercisesView(sessionViewModel: sessionViewModel)
                    .tag(TabState.exercises)
                    .toolbar(.hidden, for: .tabBar)
                
                HistoryView()
                    .tag(TabState.history)
                    .toolbar(.hidden, for: .tabBar)
                
                SettingsView()
                    .tag(TabState.settings)
                    .toolbar(.hidden, for: .tabBar)
            }
            
            VStack {
                HStack {
                    ForEach(TabState.allCases) { tab in
                        Button {
                            coordinator.currentState = tab
                        } label: {
                            VStack {
                                Rectangle()
                                    .frame(width: 30, height: 3)
                                    .foregroundStyle(Color(hex: "#FFC409"))
                                    .opacity(coordinator.currentState == tab ? 1 : 0)
                                
                                Image(tab.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 44, height: 44)
                                    .foregroundStyle(coordinator.currentState == tab ?  Color(hex: "#FFC409") : .white.opacity(0.5))
                                
                                Text(tab.title)
                                    .font(.inter(.semibold, size: 10))
                                    .foregroundStyle(coordinator.currentState == tab ?  Color(hex: "#FFC409") : .white.opacity(0.5))
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .background(Color(hex: "#2F2F2F"))
                .opacity(coordinator.shouldShowTabBar ? 1 : 0)
                .animation(.default, value: coordinator.shouldShowTabBar)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}

#Preview {
    AppTabView()
}


