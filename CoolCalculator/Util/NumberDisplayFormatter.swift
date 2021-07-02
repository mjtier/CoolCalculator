//
//  NumberDisplayFormatter.swift
//  CoolCalculator
//
//  Created by Michael Tier on 6/30/21.
//

import Foundation

protocol NumberDisplayFormatter {
}


extension NumberDisplayFormatter {
    
    /**
     This function will format a double to string value with commas and decimals
    */
    func formatDisplayNumber(number: Double) -> String {
        let numberFormatter = NumberFormatter()
        if number > -99999999999999 && number < 99999999999999  {
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
        } else {
            numberFormatter.numberStyle = NumberFormatter.Style.scientific
        }
        numberFormatter.maximumFractionDigits = 18
        return numberFormatter.string(from:NSNumber(value:number))!
    }

}
