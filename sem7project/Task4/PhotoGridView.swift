//
//  PhotoGridView.swift
//  sem7project
//
//  Created by Mary Grishchenko on 24.09.2024.
//

import SwiftUI

struct PhotoGridView: View {
    var body: some View {
        VStack {
            VStack {
                //
            }
            .frame(width: 200.0, height: 200.0)
            .background(Color(red: 0.9, green: 0.9, blue: 0.9))
            
            Text("Name")
                .multilineTextAlignment(.leading)
        }
    }
}

struct PhotoGridView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoGridView()
    }
}
