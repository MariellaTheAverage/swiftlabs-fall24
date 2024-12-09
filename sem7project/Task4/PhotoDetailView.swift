//
//  PhotoDetailView.swift
//  sem7project
//
//  Created by Mary Grishchenko on 24.09.2024.
//

import SwiftUI

struct PhotoDetailView: View {
    var body: some View {
        VStack {
            Text("Name")
                .font(.title)
                .fontWeight(.semibold)
            
            VStack {
                //
            }
            .frame(width: 350.0, height: 350.0)
            .background(Color(red: 0.9, green: 0.9, blue: 0.9))
            
            VStack(alignment: .leading) {
                Text("Description")
                    .multilineTextAlignment(.leading)
            }
        }
    }
}

struct PhotoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoDetailView()
    }
}
