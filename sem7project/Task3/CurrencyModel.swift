//
//  CurrencyModel.swift
//  sem7project
//
//  Created by Mary Grishchenko on 09.09.2024.
//

import Foundation

public struct Currency: Hashable, Identifiable {
    public var id: Int
    // public var id: any Hashable
    public var VID: String
    public var NumCode: Int
    public var CharCode: String
    public var Nominal: Int
    public var Name: String
    public var Value: Float
    public var VunitRate: Float
    
    public init(id: Int, VID: String?, NumCode: Int?, CharCode: String?, Nominal: Int?, Name: String?, Value: Float?, VunitRate: Float?) {
        self.id = id
        self.VID = VID ?? ""
        self.NumCode = NumCode ?? -1
        self.CharCode = CharCode ?? ""
        self.Nominal = Nominal ?? -1
        self.Name = Name ?? ""
        self.Value = Value ?? -1.0
        self.VunitRate = VunitRate ?? -1.0
    }
}
