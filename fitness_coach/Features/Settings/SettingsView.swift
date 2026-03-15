import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("hasPushOn") var hasPushOn = false
    
    @State private var navPath: [SettingsScreen] = []
    
    @State private var toggleOn = false
    @State private var showRemoveAlert = false
    @State private var showPushAlert = false
    @State private var showTextView = false
    
    var body: some View {
        NavigationStack(path: $navPath) {
            ZStack {
                Color(hex: "#100F0E")
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    navbar
                    
                    VStack(spacing: 16) {
                        profile
                        preferences
                        data
                        doc
                    }
                    .padding(.top)
                    .padding(.horizontal, 16)
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .onAppear {
                AppTabCoordinator.shared.shouldShowTabBar = true
            }
            .navigationDestination(for: SettingsScreen.self) { screen in
                switch screen {
                    case .profile:
                        ProfileView()
                }
            }
            .sheet(isPresented: $showTextView) {
                VStack {
                    HStack {
                        Button {
                            showTextView = false 
                        } label: {
                            Image(systemName: "multiply")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(.black.opacity(0.5))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding()
                    BlackWindow(url: URL(string: "https://docs.google.com/document/d/1gKnqgj0VpQvMk5Lj4xpYPBgzKjUeKb4gdAe94r4OQHo/edit?usp=sharing")!, isHidden: .constant(false))
                }
                .ignoresSafeArea(edges: [.bottom])
            }
            .alert("Are you sure you want to delete all the data?", isPresented: $showRemoveAlert) {
                Button("Yes", role: .destructive) {
                    Task {
                        UDService.shared.removeValue(forKey: .session)
                        UDService.shared.removeValue(forKey: .profile)
                    }
                }
            }
            .alert("The notification permission denied", isPresented: $showPushAlert) {}
            .onChange(of: toggleOn) { isOn in
                switch isOn {
                    case true:
                        NotificationPermissionService.instance.fetchCurrentState { status in
                            switch status {
                                case .granted:
                                    hasPushOn = true
                                case .rejected:
                                    showPushAlert = true
                                    toggleOn = false
                                case .unknown:
                                    NotificationPermissionService.instance.askForPermission { status in
                                        switch status {
                                            case .granted:
                                                hasPushOn = true
                                            case .rejected:
                                                showPushAlert = true
                                                toggleOn = false
                                            case .unknown:
                                                return
                                        }
                                    }
                            }
                        }
                    case false:
                        hasPushOn = false
                }
            }
        }
    }
    
    private var navbar: some View {
        ZStack {
            Text("Settings")
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
    
    private var preferences: some View {
        VStack {
            Text("Preferences")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.inter(.bold, size: 18))
                .foregroundStyle(.white)
            
            HStack {
                Text("Notification")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.inter(.bold, size: 18))
                    .foregroundStyle(.white)
                
                Toggle(isOn: $toggleOn) {}
                    .labelsHidden()
                    .tint(Color(hex: "#FFC409"))
            }
            .frame(height: 52)
            .padding(.horizontal, 12)
            .background(Color(hex: "#2F2F2F"))
            .cornerRadius(16)
        }
    }
    
    private var data: some View {
        VStack {
            Text("Local data")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.inter(.bold, size: 18))
                .foregroundStyle(.white)
            
            VStack(spacing: 0) {
                Button {
                    showTextView = true
                } label: {
                    HStack {
                        Text("Privacy")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.inter(.bold, size: 18))
                            .foregroundStyle(.white)
                        
                        Image(systemName: "chevron.forward")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    .frame(height: 52)
                }
                .padding(.horizontal, 12)
                .background(Color(hex: "#2F2F2F"))
                .cornerRadius(16)
            }
        }
    }
    
    private var doc: some View {
        VStack {
            Text("Doc")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.inter(.bold, size: 18))
                .foregroundStyle(.white)
            
            Button {
                showRemoveAlert = true
            } label: {
                HStack {
                    Text("Remove all the data")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.inter(.bold, size: 18))
                        .foregroundStyle(.white)
                    
                    Image(systemName: "chevron.forward")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white.opacity(0.5))
                }
                .frame(height: 52)
                .padding(.horizontal, 12)
                .cornerRadius(16)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.red, lineWidth: 1)
                }
            }
        }
    }
    
    private var profile: some View {
        VStack {
            Text("Profile")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.inter(.bold, size: 18))
                .foregroundStyle(.white)
            
            Button {
                AppTabCoordinator.shared.shouldShowTabBar = false
                navPath.append(.profile)
            } label: {
                HStack {
                    Text("Show profile")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.inter(.bold, size: 18))
                        .foregroundStyle(.white)
                    
                    Image(systemName: "chevron.forward")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white.opacity(0.5))
                }
                .frame(height: 52)
                .padding(.horizontal, 12)
                .background(Color(hex: "#2F2F2F"))
                .cornerRadius(16)
            }
        }
    }
}

#Preview {
    SettingsView()
}
