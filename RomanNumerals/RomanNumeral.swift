//
//  RomanNumerals.swift
//  RomanNumerals
//
//  Created by PJ COOK on 10/11/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

// Reference:
// https://www.wikihow.com/Learn-Roman-Numerals
// https://www.mathsisfun.com/roman-numerals.html#convert

enum RomanNumeral: String {
    case I, V, X, L, C, D, M
    
    var value: Int {
        switch self {
        case .I: return 1
        case .V: return 5
        case .X: return 10
        case .L: return 50
        case .C: return 100
        case .D: return 500
        case .M: return 1000
        }
    }
    
    func isValidSibling(_ value: RomanNumeral) -> Bool {
        switch self {
        case .I: return [.V, .X, .I].contains(value)
        case .V: return [.I].contains(value)
        case .X: return [.I, .C, .L, .X].contains(value)
        case .L: return [.X].contains(value)
        case .C: return [.X, .M, .C].contains(value)
        case .D: return [.C].contains(value)
        case .M: return [.C, .M].contains(value)
        }
    }
    
    static func extractChain(_ input: inout [RomanNumeral]) -> ([RomanNumeral], Bool) {
        var result = [RomanNumeral]()
        var firstSymbol: RomanNumeral? = nil
        var ascending: Bool? = nil
        while !input.isEmpty {
            // Add to output
            let currentValue = input.removeFirst()
            result.append(currentValue)

            // Extract first symbol and make non optional
            if firstSymbol == nil {
                firstSymbol = currentValue
                guard let nextValue = input.first, nextValue.isValidSibling(currentValue) else { break }
                continue
            }
            guard let firstSymbol = firstSymbol else { break }

            // Determine whether we should evaluate an ascending sequence and make non optional
            if ascending == nil { ascending = currentValue.value >= firstSymbol.value }
            guard let ascending = ascending else { break }
            
            // Peek at next value and validate
            guard let nextValue = input.first else { break }
            if nextValue == currentValue { continue }
            guard nextValue.isValidSibling(firstSymbol) else { break }
            
            // Evaluate whether we're at the end of the chain
            if ascending && currentValue.value > nextValue.value { break }
            else if !ascending && currentValue.value < nextValue.value { break }
        }
        var shouldSubtractValues = false
        if result.count > 1, ascending ?? false {
            shouldSubtractValues = result.first != result.last
        }
        return (result, shouldSubtractValues)
    }
    
    static func sumChain(_ input: ([RomanNumeral], Bool)) -> Int {
        var result = 0
        
        for numeral in input.0 {
            if input.1 && numeral != input.0.last {
                result -= numeral.value
            } else {
                result += numeral.value
            }
        }
        
        return result
    }
}

// Rules
// When a symbol appears after a larger (or equal) symbol it is added
// • Example: VI = V + I = 5 + 1 = 6
// • Example: LXX = L + X + X = 50 + 10 + 10 = 70
//
// But if the symbol appears before a larger symbol it is subtracted
// • Example: IV = V − I = 5 − 1 = 4
// • Example: IX = X − I = 10 − 1 = 9
//
// Don't use the same symbol more than three times in a row (but IIII is sometimes used for 4, particularly on clocks)


extension String {
    func convertFromRomanNumerals() -> Int {
        var numerals = self.compactMap { RomanNumeral(rawValue: String($0)) }
        var value = 0
        
        while !numerals.isEmpty {
            value += RomanNumeral.sumChain(RomanNumeral.extractChain(&numerals))
        }
        
        return value
    }
    
    func addRomanNumeral(_ value: String) -> String {
        return (self.convertFromRomanNumerals() + value.convertFromRomanNumerals()).convertToRomanNumerals()
    }
}

extension Int {
    fileprivate func convertToNumerals(_ value: Int, symbolTen: String, symbolFive: String, symbolUnit: String, _ result: inout String) {
        guard value > 0 else { return }

        switch value {
        case 9:
            result += symbolUnit + symbolTen
        case 5...8:
            result += symbolFive
            result += String(repeating: symbolUnit, count: value - 5)
        case 4:
            result += symbolUnit + symbolFive
        default:
            result += String(repeating: symbolUnit, count: value)
        }
    }
    
    func convertToRomanNumerals() -> String {
        var result = ""

        let thousands = Int(self / 1000)
        let hundreds = (self / 100) % 10
        let tens = (self / 10) % 10
        let units = self % 10
        
        result = String(repeating: "M", count: thousands)
        convertToNumerals(hundreds, symbolTen: "M", symbolFive: "D", symbolUnit: "C", &result)
        convertToNumerals(tens, symbolTen: "C", symbolFive: "L", symbolUnit: "X", &result)
        convertToNumerals(units, symbolTen: "X", symbolFive: "V", symbolUnit: "I", &result)
        
        return result
    }
}
