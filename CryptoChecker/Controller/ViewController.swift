//
//  ViewController.swift
//  CryptoChecker
//
//  Created by Kostadin Samardzhiev on 27.12.21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var coinManager = CoinManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        coinManager.delegate = self
        
        coinManager.getCoinPrice(for: coinManager.currencyArray[pickerView.selectedRow(inComponent: 0)])
    }
}

//MARK: - PickerView

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManager.getCoinPrice(for: coinManager.currencyArray[row])
    }
}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    
    func didUpdateCoinData(_ coinManager: CoinManager, exchangeModel: ExchangeModel) {
        DispatchQueue.main.async {
            self.priceLabel.text = exchangeModel.rateString
            self.currencyLabel.text = coinManager.currencyArray[self.pickerView.selectedRow(inComponent: 0)]
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
