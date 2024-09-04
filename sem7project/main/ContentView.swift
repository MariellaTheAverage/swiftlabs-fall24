//
//  ContentView.swift
//  sem7project
//
//  Created by Mary Grishchenko on 03.09.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        @State var redirectFlag = 0
        
        NavigationSplitView {
            List {
                NavigationLink {
                    Task1View()
                } label: {
                    Text("Task 1")
                }
                NavigationLink {
                    Task2View()
                } label: {
                    Text("Task 2")
                }
                NavigationLink {
                    Task1View()
                } label: {
                    Text("Task 3")
                }
                NavigationLink {
                    Task1View()
                } label: {
                    Text("Task 4")
                }
            }
            .navigationTitle("Tasks")
        } detail: {
            Text("Mobile development project")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
