//
//  Task1View.swift
//  sem7project
//

import SwiftUI

struct Task1View: View {
    @State var showing = false
    
    var body: some View {
        Button("Hello World?") {
            showing = true
        }
        .buttonStyle(.borderedProminent)
        .popover(isPresented: $showing) {
            Text("Hello World!!!")
                .font(.title)
                .foregroundColor(Color.green)
                .padding(.top, 20.0)
                
                
        }
    }
}

struct Task1View_Previews: PreviewProvider {
    static var previews: some View {
        Task1View()
    }
}

