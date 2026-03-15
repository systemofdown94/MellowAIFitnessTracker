import SwiftUI

struct HistoryDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: HistoryViewModel
    
    @State var session: Session
    
    @FocusState var isFocused: Bool
    
    var body: some View {
        ZStack {
            Color(hex: "#100F0E")
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                navbar
                input
                
                Spacer()
                
                saveButton
            }
        }
        .navigationBarBackButtonHidden()
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
            
            Text("Exercise Detail")
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
    
    private var input: some View {
        VStack(spacing: 32) {
            description
            info
        }
        .padding(.horizontal, 16)
    }
    
    private var description: some View {
        VStack(spacing: 16) {
            Text("Description")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.inter(.bold, size: 18))
                .foregroundStyle(.white)
            
            TextField("", text: $session.description, prompt: Text("Enter description...")
                .foregroundColor(.white.opacity(0.5))
            )
            .frame(height: 140, alignment: .top)
            .padding(12)
            .foregroundStyle(.white)
            .background(Color(hex: "#2F2F2F"))
            .cornerRadius(16)
            .focused($isFocused)
        }
    }
    
    private var info: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Total calories burned:")
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                Text(session.exercise.totalCalories.formatted())
                    .foregroundStyle(Color(hex: "#FFC409"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Text("Total duration:")
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                Text(session.exercise.duration.formatted() + " min")
                    .foregroundStyle(Color(hex: "#FFC409"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Text("Intencity:")
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                Text(session.exercise.intencity?.title ?? "N/A")
                    .foregroundStyle(Color(hex: "#FFC409"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Text("Last performed")
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                Text(session.endDate.formatted(.dateTime.year().month().day()))
                    .foregroundStyle(Color(hex: "#FFC409"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .font(.inter(.bold, size: 18))
    }
    
    private var saveButton: some View {
        Button {
            isFocused = false
            viewModel.save(session)
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
    HistoryDetailView(
        viewModel: HistoryViewModel(),
        session: Session(exercise: Exercise(isMock: true))
    )
}
