//
//  Task3View.swift
//  sem7project
//

import SwiftUI

struct Task3View: View {
    @StateObject private var currentRates = CurrencyLoader(Currencies: [], sURL: URL(string: "https://www.cbr.ru/scripts/XML_daily.asp")!)
    @State private var CurTypeFrom: Currency? = nil
    @State private var CurTypeTo: Currency? = nil
    @State private var CurAmntFrom: Float = 0.0
    @State private var CurAmntTo: Float = 0.0
    
    @State private var IdFrom: Int = 0
    @State private var IdTo: Int = 0
    
    var body: some View {
        switch currentRates.state {
        case .loaded:
            VStack {
                Text("Конвертер валют")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                VStack {
                    HStack {
                        TextField("?", value: $CurAmntFrom, formatter: formatter)
                            .onChange(of: CurAmntFrom, perform: {amnt in
                                if (amnt > 0) {
                                    ConvertCurrency(amnt: amnt)}})
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Picker(selection: $CurTypeFrom) {
                            ForEach(currentRates.Currencies, id: \.self) {currency in
                                Text("\(currency.Name) (\(currency.CharCode))").tag(currency as Currency?)
                            }
                            
                        } label: {
                            Text("label!")
                        }
                        .padding(.vertical)
                        .onChange(of: CurTypeFrom, perform: {
                            cType in ConvertCurrency(amnt: CurAmntFrom)
                        })
                        
                    }
                    .padding(.horizontal)
                    
                    Text("=")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack {
                        TextField("?", value: $CurAmntTo, formatter: formatter)
                            .onChange(of: CurAmntTo, perform: {amnt in
                                if (amnt > 0) {
                                    ConvertCurrencyBackwards(amnt: amnt)}})
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Picker(selection: $CurTypeTo) {
                            ForEach(currentRates.Currencies, id: \.self) {currency in
                                Text("\(currency.Name) (\(currency.CharCode))").tag(currency as Currency?)
                            }
                            
                        } label: {
                            Text("label!")
                        }
                        .padding(.vertical)
                        .onChange(of: CurTypeTo, perform: {
                            cType in ConvertCurrencyBackwards(amnt: CurAmntTo)
                        })
                        
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                AsyncButton {
                    await currentRates.GetData()
                } label: {
                    Text("Обновить курс валют")
                }
                .buttonStyle(.borderedProminent)

            }
            .toolbar {
                AsyncButton {
                    // currentRates.state = .loading
                    await currentRates.GetData()
                } label: {
                    Image(systemName: "arrow.2.circlepath")
                        .padding(.trailing, 20.0)
                        .imageScale(.medium)
                }
                
            }
            .task {
                // await currentRates.GetData()
                CurTypeFrom = currentRates.Currencies[0]
                CurTypeTo = currentRates.Currencies[0]
            }
        case .loading:
            VStack{
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(2.0, anchor: .center)
            }
            .task {
                print("Загрузка курса...")
                await currentRates.GetData()
                print("Готово")
            }
        default:
            Text("def label")
        }
    }
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    // Here be conversion logic
    func ConvertCurrency(amnt: Float) {
        let CFrom = CurTypeFrom!
        let CTo = CurTypeTo!
        let rub = amnt * CFrom.VunitRate
        CurAmntTo = rub / CTo.VunitRate
    }
    
    func ConvertCurrencyBackwards(amnt: Float) {
        let CFrom = CurTypeFrom!
        let CTo = CurTypeTo!
        let rub = amnt * CTo.VunitRate
        CurAmntFrom = rub / CFrom.VunitRate
    }
}

struct Task3View_Previews: PreviewProvider {
    static var previews: some View {
        Task3View()
    }
}
