//
//  XMLParser.swift
//  sem7project
//
//  Created by Mary Grishchenko on 06.09.2024.
//

import Foundation

class CurrencyLoader: ObservableObject {
    @Published var Currencies: [Currency]
    private var rawData: Data
    private var sourceURL: URL
    
    init(Currencies: [Currency]?, sURL: URL) {
        self.Currencies = Currencies ?? []
        self.rawData = Data()
        self.sourceURL = sURL
        Task {
            await self.GetData()
        }
    }
    
    func UpdateData() async -> Void {
        // maybe add correction code for minimal updates?
    }
    
    func GetData() async -> Void {
        let task = URLSession.shared.dataTask(with: self.sourceURL) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                return
            }
            let dataString = String(NSString(data: data, encoding: NSWindowsCP1251StringEncoding) ?? "")
            self.rawData = dataString.data(using: String.Encoding(rawValue: NSWindowsCP1251StringEncoding) )!
            let Parser = XMLParser(data: self.rawData)
            let parseDLGT = CurrencyParser(dataArray: self.Currencies)
            Parser.delegate = parseDLGT
            self.Currencies = []
            Parser.parse()
            self.Currencies = parseDLGT.dataArray
        }
        task.resume()
    }
}
    
class CurrencyParser: NSObject, XMLParserDelegate {
    private var currentElement = ""
    public var dataArray: [Currency]
    private var idx: Int
    
    init(currentElement: String = "", dataArray: [Currency]) {
        self.currentElement = currentElement
        self.dataArray = dataArray
        self.idx = -1
    }
    
    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
    ) {
        currentElement = elementName
        if (elementName == "Valute") {
            dataArray.append(Currency(id: self.idx, VID: nil, NumCode: nil, CharCode: nil, Nominal: nil, Name: nil, Value: nil, VunitRate: nil))
            self.idx += 1
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if (string.trimmingCharacters(in: .whitespacesAndNewlines) != "") {
            if (self.currentElement == "NumCode") {
                self.dataArray[self.idx].NumCode = Int(string) ?? -1
            }
            if (self.currentElement == "CharCode") {
                self.dataArray[self.idx].CharCode = string
            }
            if (self.currentElement == "Nominal") {
                self.dataArray[self.idx].Nominal = Int(string) ?? -1
            }
            if (self.currentElement == "Name") {
                self.dataArray[self.idx].Name = string
            }
            if (self.currentElement == "Value") {
                let val = String(string.map {
                    $0 == "," ? "." : $0
                })
                self.dataArray[self.idx].Value = Float(val) ?? -1.0
            }
            if (self.currentElement == "VunitRate") {
                let val = String(string.map {
                    $0 == "," ? "." : $0
                })
                self.dataArray[self.idx].VunitRate = Float(val) ?? -1.0
            }
        }
    }
}
