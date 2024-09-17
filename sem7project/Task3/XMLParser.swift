//
//  XMLParser.swift
//  sem7project
//
//  Created by Mary Grishchenko on 06.09.2024.
//

import Foundation

actor DataGetter {
    var processedData: [Currency]
    var sourceURL: URL
    static let shared = DataGetter(url: URL(string: "https://www.cbr.ru/scripts/XML_daily.asp")!)
    private init(url: URL) {
        self.processedData = []
        self.sourceURL = url
    }
    
    // lots of warnings but it works
    func LoadData() async throws -> [Currency] {
        self.processedData = []
        let task = URLSession.shared.dataTask(with: self.sourceURL) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                return
            }
            let dataString = String(NSString(data: data, encoding: NSWindowsCP1251StringEncoding) ?? "")
            var rawData = dataString.data(using: String.Encoding(rawValue: NSWindowsCP1251StringEncoding) )!
            let Parser = XMLParser(data: rawData)
            let parseDLGT = CurrencyParser(dataArray: self.processedData)
            Parser.delegate = parseDLGT
            self.processedData = []
            Parser.parse()
            self.processedData = parseDLGT.dataArray
        }
        task.resume()
        return self.processedData
    }
}

extension CurrencyLoader {
    enum State {
        case loading
        case loaded
        case error(Error)
    }
}

// @MainActor
final class CurrencyLoader: ObservableObject {
    @Published var Currencies: [Currency]
    private var rawData: Data
    private var sourceURL: URL
    @Published var error: Error?
    @Published var CurTypeFrom: Currency?
    @Published var CurTypeTo: Currency?
    private(set) var state: State = .loading
    
    init(Currencies: [Currency]?, sURL: URL) {
        self.Currencies = Currencies ?? []
        self.rawData = Data()
        self.sourceURL = sURL
        /*
        Task {
            await self.GetData()
        }
         */
    }
    
    func UpdateData() async -> Void {
        // maybe add correction code for minimal updates?
    }
    
    func GetData() async -> Void {
        state = .loading
        /*
        do {
            self.Currencies = try await DataGetter.shared.LoadData()
        } catch {
            self.error = error
        }
         */
        
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
        
        state = .loaded
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
            dataArray.append(Currency(id: self.idx+1, VID: nil, NumCode: nil, CharCode: nil, Nominal: nil, Name: nil, Value: nil, VunitRate: nil))
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
