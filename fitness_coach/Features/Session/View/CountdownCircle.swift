import SwiftUI
import Combine

struct CountdownCircle: View {
    
    let session: Session
    var onFinished: (() -> Void)?
    
    @State private var now = Date()
    @State private var finished = false
    
    private var progress: Double {
        let total = session.duration
        let remaining = session.remainingTime(now: now)
        
        return max(0, min(1, remaining / total))
    }
    
    var body: some View {
        ZStack {
            
            Circle()
                .stroke(.gray.opacity(0.3), lineWidth: 12)
            
            Circle()
                .stroke(Color(hex: "#242424"), lineWidth: 10)
                .padding(10)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color(hex: "#FFC409"),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: progress)
        }
        .onReceive(
            Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        ) { value in
            
            now = value
            
            if !finished && session.remainingTime(now: value) <= 0 {
                finished = true
                onFinished?()
            }
        }
    }
}
