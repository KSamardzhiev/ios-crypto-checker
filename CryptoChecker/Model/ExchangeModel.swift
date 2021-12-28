//
//  ExchangeModel.swift
//  CryptoChecker
//
//  Created by Kostadin Samardzhiev on 28.12.21.
//

import Foundation

struct ExchangeModel: Decodable {
    let time: String
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
    
    var rateString: String {
        return String(format: "%.2f", rate)
    }
}
