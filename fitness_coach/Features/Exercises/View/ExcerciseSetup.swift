import SwiftUI

struct ExcerciseSetupView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var sessionViewModel: SessionViewModel
    
    @Binding var navPath: [ExerciseScreen]
    
    let type: ExerciseType
    
    @State var exercise: Exercise?
    
    @State private var durationMinutes: Int = 30
    @State private var selectedIntencity: ExerciseIntencity = .medium
    
    var body: some View {
        ZStack {
            Color(hex: "#100F0E")
                .ignoresSafeArea()
            
            VStack {
                navbar
                
                VStack(spacing: 16) {
                    exerciseTypeInfo
                    intencity
                    duration
                }
                
                Spacer()
                
                startButton
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .navigationBarBackButtonHidden()
        .onChange(of: durationMinutes) { duration in
            exercise?.duration = duration
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
            
            Text("Add Exercises")
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
    
    private var exerciseTypeInfo: some View {
        HStack {
            Image(type.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
            
            Text(type.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.inter(.semibold, size: 36))
                .foregroundStyle(.white)
        }
        .padding(.top)
        .padding(.horizontal, 16)
    }
    
    private var intencity: some View {
        VStack {
            Text("Intencity")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.inter(.semibold, size: 24))
                .foregroundStyle(.white)
            
            HStack {
                ForEach(ExerciseIntencity.allCases) { intencity in
                    Button {
                        withAnimation {
                            selectedIntencity = intencity
                        }
                    } label: {
                        Text(intencity.title)
                            .frame(height: 52)
                            .frame(maxWidth: .infinity)
                            .font(.inter(.regular, size: 18))
                            .background(selectedIntencity == intencity ? Color(hex: "#FFC409") : .clear)
                            .foregroundStyle(selectedIntencity == intencity ? Color(hex: "#242424") : .white)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(4)
            .background(Color(hex: "#242424"))
            .cornerRadius(12)
        }
        .padding(.top)
        .padding(.horizontal, 16)
    }
    
    private var duration: some View {
        VStack {
            Text("Duration (min)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.inter(.bold, size: 18))
                .foregroundStyle(.white)
            
            Picker("", selection: $durationMinutes) {
                ForEach(1...180, id: \.self) { minute in
                    Text("\(minute) min").tag(minute)
                }
            }
            .labelsHidden()
            .pickerStyle(.wheel)
            .colorScheme(.dark)
        }
        .padding(.top)
        .padding(.horizontal, 16)
    }
    
    private var startButton: some View {
        Button {
            let name = exercise?.name == "" ? type.title : exercise?.name ?? type.title
            let newExercise = Exercise(
                name: name,
                type: type,
                intencity: selectedIntencity,
                duration: durationMinutes,
                caloriesPerMinute: exercise?.caloriesPerMinute ?? type.caloriesPerMinute?.formatted() ?? "0"
            )
            
            let newSession = Session(exercise: newExercise)
            
            navPath = []
            AppTabCoordinator.shared.currentState = .session
            sessionViewModel.sessionState = .active(newSession)
        } label: {
            Text("Start SESSION")
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
    ExcerciseSetupView(
        sessionViewModel: SessionViewModel(),
        navPath: .constant([]),
        type: .custom,
        exercise: Exercise(
            isMock: true
        )
    )
}

#Preview {
    ExcerciseSetupView(
        sessionViewModel: SessionViewModel(),
        navPath: .constant([]),
        type: .run,
        exercise: nil
    )
}
