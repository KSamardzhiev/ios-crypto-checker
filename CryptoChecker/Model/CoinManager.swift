//
//  CoinManager.swift
//  CryptoChecker
//
//  Created by Kostadin Samardzhiev on 28.12.21.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoinData(_ coinManager: CoinManager, exchangeModel: ExchangeModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String
    var baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    var delegate: CoinManagerDelegate?
    
    let currencyArray = [ "USD", "EUR", "BGL" ]
    
    func getCoinPrice(for currency: String) {
        fetchPrice(for: currency)
    }
    
    func fetchPrice(for currency: String) {
        print(apiKey!)
        let url = URL(string: "\(baseURL)/\(currency)?apikey=\(apiKey ?? "INVALID_KEY")")
        
        if let safeUrl = url {
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: safeUrl) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                }
                
                if let safeData = data {
                    if let exchangeModel = parseJson(data: safeData) {
                        delegate?.didUpdateCoinData(self, exchangeModel: exchangeModel)
                    }
                }
                
            }
            dataTask.resume()
        }
        
        
    }
    
    func parseJson(data: Data) -> ExchangeModel? {
        let decoder = JSONDecoder()
        
        do {
            let exchangeModel = try decoder.decode(ExchangeModel.self, from: data)
            return exchangeModel
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
