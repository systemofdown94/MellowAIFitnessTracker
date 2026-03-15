import SwiftUI

struct TextFieldCustomView: View {
    
    let type: UIKeyboardType
    let placeholder: String?
    
    @Binding var text: String
    
    @FocusState.Binding var isFocused: Bool
    
    init(
        type: UIKeyboardType,
        placeholder: String? = nil,
        text: Binding<String>,
        isFocused: FocusState<Bool>.Binding
    ) {
        self.type = type
        self.placeholder = placeholder
        self._text = text
        self._isFocused = isFocused
    }
    
    var body: some View {
        HStack {
            TextField("", text: $text, prompt: Text(placeholder ?? "Enter text...")
                .foregroundColor(.white.opacity(0.5))
            )
            .foregroundStyle(.white)
            .font(.inter(.regular, size: 18))
            .keyboardType(type)
            .focused($isFocused)
            
            if text != "" {
                Button {
                    text = ""
                    isFocused = false
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.white.opacity(0.5))
                }
            }
        }
        .frame(height: 56)
        .padding(.horizontal)
        .background(Color(hex: "#2F2F2F"))
        .cornerRadius(13)
        .overlay {
            RoundedRectangle(cornerRadius: 13)
                .stroke(.white, lineWidth: 1)
        }
        
    }
}
