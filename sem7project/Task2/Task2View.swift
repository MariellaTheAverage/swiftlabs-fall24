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
    @State private var botsPick = "Scissors"
    @State private var usersPick: String? = nil
    @State private var totalUserWins = 0
    @State private var currentMatch: Int? = nil
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Rock, Paper, Scissors, Lizard, Spock!")
                .font(.title)
                .multilineTextAlignment(.center)
            
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
            .padding(.top)
            
            Spacer()
        }
    }
}

struct Task2View_Previews: PreviewProvider {
    static var previews: some View {
        Task2View()
    }
}
