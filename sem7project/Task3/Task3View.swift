//
//  Task3View.swift
//  sem7project
//
//  Created by Mary Grishchenko on 06.09.2024.
//

import SwiftUI

struct Task3View: View {
    @ObservedObject var currentRates = CurrencyLoader(Currencies: [], sURL: URL(string: "https://www.cbr.ru/scripts/XML_daily.asp")!)
    
    var body: some View {
        VStack {
            AsyncButton {
                await currentRates.GetData()
            } label: {
                Text("Try loading rates")
            }
            
            Button {
                print($currentRates.Currencies)
            } label: {
                Text("Log rates")
            }
        }
        .toolbar {
            AsyncButton {
                await currentRates.GetData()
            } label: {
                Image(systemName: "Gear")
                    .padding(.trailing, 20.0)
                    .imageScale(.medium)
            }

        }
    }
}

struct Task3View_Previews: PreviewProvider {
    static var previews: some View {
        Task3View()
    }
}
