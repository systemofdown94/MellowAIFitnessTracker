import SwiftUI

struct ExerciseAddView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var navPath: [ExerciseScreen]
    
    @State private var exercise = Exercise(isMock: false)
        
    @FocusState var isFocused: Bool
    
    var body: some View {
        ZStack {
            Color(hex: "#100F0E")
                .ignoresSafeArea()
            
            VStack {
                navbar
                
                exerciseName
                caloriesRate
                
                Spacer()
                
                saveButton
            }
            .toolbar {
                if isFocused {
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
    
    private var exerciseName: some View {
        VStack {
            Text("Exercise Name")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.inter(.bold, size: 18))
                .foregroundStyle(.white)
            
            TextFieldCustomView(type: .default, text: $exercise.name, isFocused: $isFocused)
        }
        .padding(.top)
        .padding(.horizontal, 16)
    }
    
    private var caloriesRate: some View {
        VStack {
            Text("Calories Rate (kcal/min)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.inter(.bold, size: 18))
                .foregroundStyle(.white)
            
            TextFieldCustomView(type: .numberPad, text: $exercise.caloriesPerMinute, isFocused: $isFocused)
        }
        .padding(.top)
        .padding(.horizontal, 16)
    }
    
    private var saveButton: some View {
        Button {
            isFocused = false
            navPath.append(.setup(exercise, exercise.type))
        } label: {
            Text("Save")
                .frame(width: 270, height: 52)
                .font(.inter(.bold, size: 19))
                .background(Color(hex: "#FFC409"))
                .foregroundStyle(Color(hex: "#100F0E"))
                .cornerRadius(8)
                .opacity(exercise.name == "" || exercise.caloriesPerMinute == "" ? 0.5 : 1)
        }
        .padding(.bottom, 30)
        .disabled(exercise.name == "" || exercise.caloriesPerMinute == "")
    }
}

#Preview {
    ExerciseAddView(navPath: .constant([]))
}

