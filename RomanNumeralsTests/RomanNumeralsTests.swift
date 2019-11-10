//
//  RomanNumeralsTests.swift
//  RomanNumeralsTests
//
//  Created by PJ COOK on 10/11/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
@testable import RomanNumerals

class RomanNumeralsTests: XCTestCase {
    let testValues = [
        1:"I",
        2:"II",
        3:"III",
        4:"IV",
        5:"V",
        6:"VI",
        7:"VII",
        8:"VIII",
        9:"IX",
        18:"XVIII",
        2987:"MMCMLXXXVII",
        5000:"MMMMM",
    ]
        
    func test_convert_roman_to_decimal() {
        for (key, value) in testValues {
            XCTAssertEqual(key, value.convertFromRomanNumerals())
        }
    }
    
    func test_convert_decimal_to_roman() {
        for (key, value) in testValues {
            XCTAssertEqual(value, key.convertToRomanNumerals())
        }
    }
    
    func test_extractPart() {
        var input: [RomanNumeral] = [.V, .I, .I]
        let (result, ascending) = RomanNumeral.extractChain(&input)
        XCTAssertEqual(3, result.count)
        XCTAssertFalse(ascending)
        
    }
    
    func test_extractPart2() {
        var input: [RomanNumeral] = [.I, .I, .V]
        let (result, ascending) = RomanNumeral.extractChain(&input)
        XCTAssertEqual(3, result.count)
        XCTAssertTrue(ascending)
    }

    func test_extractPart4() {
        var input: [RomanNumeral] = [.M, .M, .C, .M, .L, .X, .X, .X, .V, .I, .I]
        let (result, ascending) = RomanNumeral.extractChain(&input)
        XCTAssertEqual(2, result.count)
        XCTAssertFalse(ascending)
        XCTAssertEqual(9, input.count)
    }
    
    func test_sumPart() {
        var input: [RomanNumeral] = [.V, .I, .I]
        let result = RomanNumeral.sumChain(RomanNumeral.extractChain(&input))
        XCTAssertEqual(7, result)
    }
    
    func test_sumPart2() {
        var input: [RomanNumeral] = [.I, .V]
        let result = RomanNumeral.sumChain(RomanNumeral.extractChain(&input))
        XCTAssertEqual(4, result)
    }
    
    func test_adding_two_roman_numerals() {
        let origin = "VII" // 7
        let result = origin.addRomanNumeral("VII") // 7
        XCTAssertEqual("XIV", result) // 14
    }
    
    func test_adding_two_roman_numerals2() {
        let origin = "CXXIII" // 123
        let result = origin.addRomanNumeral("CDLVI") // 456
        XCTAssertEqual("DLXXIX", result) // 579
    }
}
