import SwiftUI
import SwipeActions

struct HistoryView: View {
    
    @StateObject private var viewModel = HistoryViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.navPath) {
            ZStack {
                Color(hex: "#100F0E")
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    navbar
                    
                    if viewModel.sessions.isEmpty {
                        Text("There are no completed sessions yet")
                            .frame(maxHeight: .infinity)
                            .font(.inter(.bold, size: 20))
                            .foregroundStyle(Color(hex: "#FFC409"))
                    } else {
                        cells
                    }
                }
            }
            .onAppear {
                AppTabCoordinator.shared.shouldShowTabBar = true
                viewModel.loadHistory()
            }
            .navigationDestination(for: HistoryScreen.self) { screen in
                switch screen {
                    case .detail(let session):
                        HistoryDetailView(viewModel: viewModel, session: session)
                }
            }
        }
    }
    
    private var navbar: some View {
        ZStack {
            Text("History")
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
    
    private var cells: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                ForEach(viewModel.sessions) { session in
                    SwipeView {
                        Button {
                            AppTabCoordinator.shared.shouldShowTabBar = false
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                viewModel.navPath.append(.detail(session))
                            }
                        } label: {
                            HStack(spacing: 16) {
                                Image(session.exercise.type.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 58, height: 58)
                                
                                Text(session.exercise.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(.white)
                                    .lineLimit(2)
                                
                                VStack {
                                    HStack {
                                        Text("Time:")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.inter(.regular, size: 18))
                                            .foregroundStyle(Color(hex: "#9E9E9E"))
                                        
                                        Text(session.exercise.duration.formatted() + " min")
                                            .font(.inter(.bold, size: 18))
                                            .foregroundStyle(.white)
                                    }
                                    
                                    HStack {
                                        Text("Calories:")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.inter(.regular, size: 18))
                                            .foregroundStyle(Color(hex: "#9E9E9E"))
                                        
                                        Text(session.exercise.totalCalories.formatted())
                                            .font(.inter(.bold, size: 18))
                                            .foregroundStyle(Color(hex: "#FFC409"))
                                    }
                                }
                                .frame(width: 150)
                                .minimumScaleFactor(0.8)
                            }
                            .frame(height: 110)
                            .padding(.horizontal, 12)
                            .background(Color(hex: "#2F2F2F"))
                            .cornerRadius(24)
                        }
                    } trailingActions: { context in
                        Button {
                            context.state.wrappedValue = .closed
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                viewModel.remove(session)
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 16)
                                .frame(width: 64, height: 64)
                                .foregroundStyle(.red)
                                .overlay {
                                    Image(systemName: "trash")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundStyle(.white)
                                }
                        }
                    }
                    .swipeMinimumDistance(30)
                    .swipeActionWidth(80)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    HistoryView()
}
