import SwiftUI

struct MoveButton: View {
    let emoji: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(emoji)
                .font(.system(size: 60))
                .frame(width: 100, height: 100)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
}

struct ContentView: View {
    private let moves = ["✊", "✋", "✌️"]
    private let winningMoves = [1, 2, 0] // what beats each index
    private let losingMoves  = [2, 0, 1] // what loses to each index
    
    @State private var appMove = Int.random(in: 0...2)
    @State private var shouldWin = Bool.random()
    @State private var score = 0
    @State private var questionCount = 0
    @State private var showResult = false
    
    var body: some View {
        VStack(spacing: 30) {
            
            Text("Score: \(score)")
                .font(.title.bold())
            
            VStack(spacing: 10) {
                Text("App chose:")
                Text(moves[appMove])
                    .font(.system(size: 100))
            }
            
            Text(shouldWin ? "You must WIN" : "You must LOSE")
                .font(.title2.bold())
                .foregroundColor(.blue)
            
            HStack(spacing: 20) {
                ForEach(0..<3) { index in
                    MoveButton(
                        emoji: moves[index],
                        action: {
                            playerTapped(index)
                        }
                    )
                }
            }
            
        }
        .padding()
        .alert("Game Over", isPresented: $showResult) {
            Button("Restart", action: resetGame)
        } message: {
            Text("Final Score: \(score)")
        }
    }
    
    // Game Logic
    func playerTapped(_ playerMove: Int) {
        let correctMove = shouldWin
            ? winningMoves[appMove]
            : losingMoves[appMove]
        
        if playerMove == correctMove {
            score += 1
        } else {
            score -= 1
        }
        
        nextRound()
    }
    
    func nextRound() {
        questionCount += 1
        
        if questionCount == 10 {
            showResult = true
            return
        }
        
        appMove = Int.random(in: 0...2)
        shouldWin.toggle()
    }
    
    func resetGame() {
        score = 0
        questionCount = 0
        appMove = Int.random(in: 0...2)
        shouldWin = Bool.random()
    }
}

#Preview {
    ContentView()
}
