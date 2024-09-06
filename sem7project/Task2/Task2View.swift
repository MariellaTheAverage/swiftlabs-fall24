//
//  Task2View.swift
//  sem7project
//
//  Created by Mary Grishchenko on 04.09.2024.
//

import SwiftUI

func HasP1Won(p1: String, p2: String) -> Int {
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
        if (p1 == "Rock") {
            return 1
        }
        return -1
        
    default:
        return 0
    }
}

struct Task2View: View {
    private var gameVariants = ["Scissors", "Paper", "Rock"]
    @State private var botsPick = ""
    @State private var usersPick: String? = nil
    @State private var totalWins = [0, 0]
    @State private var statusString = "Game on!"
    @State private var txtWinner = ""
    
    @State private var showSettings = false
    @State private var winCondition = 3
    
    @State private var test = true
    
    var body: some View {
        VStack {
            /*
            HStack {
                Spacer()
                
                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gear")
                        .padding(.trailing, 30.0)
                        .imageScale(.large)
                        
                }
            }
             */
            
            Text("Rock, Paper, Scissors, Lizard, Spock!")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top)
            
            VStack {
                Text("\(statusString)")
            }
            .padding(.top)
            .frame(width: 300.0, height: 500.0)
            .background(Color(red: 0.9, green: 0.9, blue: 0.9))
            .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
            
            Spacer()
            
            HStack {
                Button(action: {
                    botsPick = gameVariants.randomElement() ?? "Scissors"
                    usersPick = "Rock"
                }, label: {
                    Text("Rock")
                })
                .buttonStyle(.bordered)
                
                Button(action: {
                    botsPick = gameVariants.randomElement() ?? "Scissors"
                    usersPick = "Paper"
                }, label: {
                    Text("Paper")
                })
                .buttonStyle(.bordered)
                
                Button(action: {
                    botsPick = gameVariants.randomElement() ?? "Scissors"
                    usersPick = "Scissors"
                }, label: {
                    Text("Scissors")
                })
                .buttonStyle(.bordered)
            }
            .padding(.bottom)
        }
        .popover(isPresented: $showSettings) {
            VStack(alignment: .center, spacing: 10.0) {
                Text("Game settings")
                    .font(.headline)
                    .fontWeight(.bold)
                Stepper("Winning score: \(winCondition)", value: $winCondition, in: 1...10)
                    .padding(.horizontal)
            }
        }
        .toolbar {
            HStack {
                Spacer()
                
                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gear")
                        .padding(.trailing, 30.0)
                        .imageScale(.large)
                        
                }
            }
        }
    }
    
    func resetGame() {
        botsPick = ""
        totalWins = [0, 0]
        txtWinner = ""
    }
}

struct Task2View_Previews: PreviewProvider {
    static var previews: some View {
        Task2View()
    }
}
