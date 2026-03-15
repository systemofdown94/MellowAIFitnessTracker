import SwiftUI

struct ProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var profile = Profile(id: UUID(), name: "", age: "", weight: "", height: "")
    
    @FocusState var isFocused: Bool
    
    var body: some View {
        ZStack {
            Color(hex: "#100F0E")
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                navbar
                
                VStack(spacing: 16) {
                    icon
                    TextFieldCustomView(
                        type: .default,
                        placeholder: "Name",
                        text: $profile.name,
                        isFocused: $isFocused
                    )
                    
                    TextFieldCustomView(
                        type: .numberPad,
                        placeholder: "Age",
                        text: $profile.age,
                        isFocused: $isFocused
                    )
                    
                    TextFieldCustomView(
                        type: .numberPad,
                        placeholder: "Weight",
                        text: $profile.weight,
                        isFocused: $isFocused
                    )
                    
                    TextFieldCustomView(
                        type: .numberPad,
                        placeholder: "Height",
                        text: $profile.height,
                        isFocused: $isFocused
                    )
                    
                    Spacer()
                    
                    saveButton
                }
                .padding(.top)
                .padding(.horizontal, 16)
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        HStack {
                            Button("Done") {
                                isFocused = false
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            Task {
                let profile = await UDService.shared.value(forKey: .profile, as: Profile.self) ?? self.profile
                
                self.profile = profile
            }
        }
    }
    
    private var navbar: some View {
        ZStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color(hex: "#FFC409"))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            
            Text("Profile")
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
    
    private var icon: some View {
        Image(systemName: "person.crop.circle.fill")
            .font(.system(size: 120, weight: .bold))
            .foregroundStyle(.white.opacity(0.8))
    }
    
    private var saveButton: some View {
        Button {
            Task {
                await UDService.shared.set(profile, forKey: .profile)
                dismiss()
            }
        } label: {
            Text("Save")
                .frame(width: 270, height: 52)
                .font(.inter(.bold, size: 19))
                .background(Color(hex: "#FFC409"))
                .foregroundStyle(Color(hex: "#100F0E"))
                .cornerRadius(8)
        }
        .padding(.bottom, 30)
    }
}

#Preview {
    ProfileView()
}
