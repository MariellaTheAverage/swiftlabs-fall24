//
//  Task2View.swift
//  sem7project
//
//  Created by Mary Grishchenko on 04.09.2024.
//

import SwiftUI

struct Task2View: View {
    private var gameVariants = ["Scissors", "Paper", "Rock"]
    @State private var botsPick = ""
    @State private var usersPick: String? = nil
    @State private var userWins = 0
    @State private var botWins = 0
    @State private var statusString = "Bot's pick: "
    @State private var txtWinner = ""
    @State private var isRunning = true
    
    @State private var showSettings = false
    @State private var winCondition = 3
    
    @State private var fieldColor = Color(red: 0.9, green: 0.9, blue: 0.9)
    
    var body: some View {
        VStack {
            Text("Rock, Paper, Scissors, Lizard, Spock!")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                
            
            VStack {
                Text("Game on!")
                    .font(.headline)
                
                Spacer()
                
                VStack {
                    Text("Your score: \(userWins)")
                        .padding(.bottom)
                    Text("Bot's score: \(botWins)")
                }
                
                Spacer()
                
                Text("\(txtWinner)")
                
                Spacer()
                
                Text("\(statusString)\(botsPick)")
            }
            .padding(.vertical)
            .frame(width: 300.0)
            .background(fieldColor)
            .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
            
            HStack {
                Button(action: {
                    botsPick = gameVariants.randomElement() ?? "Scissors"
                    usersPick = "Rock"
                    runGame()
                }, label: {
                    Text("Rock")
                })
                .buttonStyle(.borderedProminent)
                .disabled(!isRunning)
                
                Button(action: {
                    botsPick = gameVariants.randomElement() ?? "Scissors"
                    usersPick = "Paper"
                    runGame()
                }, label: {
                    Text("Paper")
                })
                .buttonStyle(.borderedProminent)
                .disabled(!isRunning)
                
                Button(action: {
                    botsPick = gameVariants.randomElement() ?? "Scissors"
                    usersPick = "Scissors"
                    runGame()
                }, label: {
                    Text("Scissors")
                })
                .buttonStyle(.borderedProminent)
                .disabled(!isRunning)
            }
            .padding(.bottom)
            
            Button(action: {
                resetGame()
            }, label: {
                Text("Start a new game!")
            })
            .buttonStyle(.bordered)
            .padding(.bottom)
        }
        .popover(isPresented: $showSettings) {
            VStack(alignment: .center, spacing: 10.0) {
                Text("Game settings")
                    .font(.headline)
                    .fontWeight(.bold)
                Stepper("Winning score: \(winCondition)", value: $winCondition, in: 1...10)
                    .padding(.horizontal)
                Spacer()
                Button(action: {
                    resetGame()
                }, label: {
                    Text("Start a new game!")
                })
                .buttonStyle(.bordered)
                .padding(.bottom)
            }
            .padding(.all)
        }
        .toolbar {
            HStack {
                Spacer()
                
                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gear")
                        .padding(.trailing, 20.0)
                        .imageScale(.medium)
                        
                }
            }
        }
    }
    
    func runGame() {
        var p1: String
        if usersPick != nil {
            p1 = usersPick ?? ""
        }
        else {
            return
        }
        let res = HasP1Won(p1: p1, p2: botsPick)
        if res == 1 {
            userWins += 1
            if userWins >= winCondition {
                txtWinner = "You win!"
                isRunning = false
            }
        }
        else if res == -1 {
            botWins += 1
            if botWins >= winCondition {
                txtWinner = "The bot wins!"
                isRunning = false
            }
        }
    }
    
    func HasP1Won(p1: String, p2: String) -> Int {
        print(p1, p2)
        if (p1 == p2) {
            return 0
        }
        switch p1 {
        case "Rock":
            if (p2 == "Scissors") {
                return 1
            }
            return -1

        case "Scissors":
            if (p2 == "Paper") {
                return 1
            }
            return -1

        case "Paper":
            if (p2 == "Rock") {
                return 1
            }
            return -1
            
        default:
            return 0
        }
    }
    
    func resetGame() {
        botsPick = ""
        userWins = 0
        botWins = 0
        txtWinner = ""
        showSettings = false
        isRunning = true
    }
}

struct Task2View_Previews: PreviewProvider {
    static var previews: some View {
        Task2View()
    }
}
