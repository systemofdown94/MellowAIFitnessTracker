import SwiftUI

@available(iOS 26.0, *)
struct AIChatView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel = AIChatViewModel()
    
    @FocusState var isFocused: Bool
    
    var body: some View {
        ZStack {
            Color(hex: "#100F0E")
                .ignoresSafeArea()
            
            VStack {
                navbar
                messages
                input
            }
            .navigationBarBackButtonHidden()
            .animation(.default, value: viewModel.messages)
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
            
            Text("AI Assistant")
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
    
    private var messages: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 12) {
                    
                    ForEach(viewModel.messages) { message in
                        messageRow(message)
                            .id(message.id)
                    }
                    
                    if viewModel.isLoading {
                        loadingView
                    }
                    
                    Spacer()
                        .frame(height: 20)
                }
                .padding(.horizontal, 16)
                .padding(.top, 6)
            }
            .onChange(of: viewModel.messages.count) { _ in
                scrollToLastMessage(using: scrollProxy)
            }
        }
    }

    private func messageRow(_ message: Message) -> some View {
        VStack {
            if !message.isUser {
                assistantAvatar
            }
            
            HStack(spacing: 8) {
                messageBubble(message)
            }
            .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)
        }
        .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)
    }

    private func messageBubble(_ message: Message) -> some View {
        Text(LocalizedStringKey(message.text))
            .font(.inter(.medium, size: 15))
            .foregroundStyle(Color(hex: "#4E3529"))
            .padding(12)
            .background(message.isUser ? Color(hex: "#FFC409") : Color(hex: "#CFFFD8"))
            .clipShape(UnevenRoundedRectangle(
                topLeadingRadius: 16,
                bottomLeadingRadius: message.isUser ? 16 : 0,
                bottomTrailingRadius: message.isUser ? 0 : 16,
                topTrailingRadius: 16
            ))
            .frame(maxWidth: UIScreen.main.bounds.width * 0.66,
                   alignment: message.isUser ? .trailing : .leading)
    }
    
    private var input: some View {
        HStack {
            TextField("", text: $viewModel.text, prompt: Text("Enter text...")
                .foregroundColor(.white.opacity(0.5))
            )
            .frame(height: 52)
            .padding(.horizontal, 12)
            .foregroundStyle(.white)
            .background(Color(hex: "#2F2F2F"))
            .cornerRadius(16)
            .focused($isFocused)
            
            Button {
                isFocused = false
                viewModel.sendMessage()
            } label: {
                Circle()
                    .frame(width: 44, height: 44)
                    .foregroundStyle(Color(hex: "#FFC409"))
                    .overlay {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.black)
                    }
            }
        }
        .padding(.horizontal, 16)
    }

    private var assistantAvatar: some View {
        HStack {
            Image(.Images.aiAssistant)
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var loadingView: some View {
        HStack {
            ProgressView()
                .tint(.white)
            Spacer()
        }
    }

    private func bubbleColor(for message: Message) -> Color {
        message.isUser ? Color("#FFC409") : Color(hex: "#CFFFD8")
    }

    private func scrollToLastMessage(using proxy: ScrollViewProxy) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard let last = viewModel.messages.last else { return }
            
            withAnimation {
                proxy.scrollTo(last.id, anchor: .top)
            }
        }
    }
}

@available(iOS 26.0, *)
#Preview {
    AIChatView()
}
