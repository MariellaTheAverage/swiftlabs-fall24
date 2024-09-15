//
//  AsyncButton.swift
//  sem7project
//
//  Created by Mary Grishchenko on 12.09.2024.
//

import SwiftUI

struct AsyncButton<Label: View>: View {
    let action: () async throws -> Void
    let label: Label
    
    @State private var isRunning = false
    
    init(
        action: @escaping () async throws -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.action = action
        self.label = label()
    }
    
    var body: some View {
        Button {
            isRunning = true
            Task {
                try await action()
                isRunning = false
            }
        } label: {
            label
        }
        .disabled(isRunning)
    }
}


struct AsyncButton_Previews: PreviewProvider {
    static var previews: some View {
        AsyncButton {
            try await Task.sleep(for: .seconds(2))
        } label: {
            Text("Run async function")
        }

    }
}
