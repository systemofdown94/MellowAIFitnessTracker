import SwiftUI

struct CompleteSessionView: View {
    
    let session: Session
    let saveAction: () -> Void
    var body: some View {
        ZStack {
            Color(hex: "#100F0E")
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                navbar
                sessionInfo
                
                Spacer()
                
                saveButton
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private var navbar: some View {
        ZStack {
            Text("Completed")
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
    
    private var sessionInfo: some View {
        VStack(spacing: 64) {
            Image(systemName: "checkmark")
                .font(.system(size: 140, weight: .medium))
                .foregroundStyle(Color(hex: "#FFC409"))
            
            VStack(spacing: 32) {
                HStack {
                    Text("Time:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.inter(.regular, size: 18))
                        .foregroundStyle(Color(hex: "#9E9E9E"))
                    
                    Text("\(session.exercise.duration) min")
                        .font(.inter(.bold, size: 18))
                        .foregroundStyle(Color(hex: "#FFC409"))
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
                
                HStack {
                    Text("Mood:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.inter(.regular, size: 18))
                        .foregroundStyle(Color(hex: "#9E9E9E"))
                    
                    Text("\(session.exercise.condition?.icon ?? "")")
                        .font(.inter(.bold, size: 18))
                        .foregroundStyle(Color(hex: "#FFC409"))
                }
            }
            .frame(width: 200)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    private var saveButton: some View {
        VStack(spacing: 16) {
            Button {
                saveAction()
            } label: {
                Text("Save")
                    .frame(width: 270, height: 52)
                    .font(.inter(.bold, size: 19))
                    .background(Color(hex: "#FFC409"))
                    .foregroundStyle(Color(hex: "#100F0E"))
                    .cornerRadius(8)
            }
            
            Text("Saves to history, returns\nto empty session")
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.bottom)
                .font(.inter(.regular, size: 18))
                .foregroundStyle(Color(hex: "#9E9E9E"))
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    CompleteSessionView(session: Session(exercise: Exercise(isMock: true))) {}
}
