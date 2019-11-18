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
        do {
            for (key, value) in testValues {
                XCTAssertEqual(key, try value.convertFromRomanNumerals())
            }
        } catch {
            XCTFail()
        }
    }
    
    func test_can_handle_invalid_chains() {
        XCTAssertThrowsError(try "XVIIII".convertFromRomanNumerals())
    }
    
    func test_convert_decimal_to_roman() {
        for (key, value) in testValues {
            XCTAssertEqual(value, key.convertToRomanNumerals())
        }
    }
    
    func test_extractPart() {
        var input: [RomanNumeral] = [.V, .I, .I]
        do {
            let (result, ascending) = try RomanNumeral.extractChain(&input)
            XCTAssertEqual(3, result.count)
            XCTAssertFalse(ascending)
        } catch {
            XCTFail()
        }
        
    }
    
    func test_extractPart2() {
        var input: [RomanNumeral] = [.I, .I, .V]
        do {
            let (result, ascending) = try RomanNumeral.extractChain(&input)
            XCTAssertEqual(3, result.count)
            XCTAssertTrue(ascending)
        } catch {
            XCTFail()
        }
    }

    func test_extractPart4() {
        var input: [RomanNumeral] = [.M, .M, .C, .M, .L, .X, .X, .X, .V, .I, .I]
        do {
            let (result, ascending) = try RomanNumeral.extractChain(&input)
            XCTAssertEqual(2, result.count)
            XCTAssertFalse(ascending)
            XCTAssertEqual(9, input.count)
        } catch {
            XCTFail()
        }
    }
    
    func test_sumPart() {
        var input: [RomanNumeral] = [.V, .I, .I]
        do {
            let result = RomanNumeral.sumChain(try RomanNumeral.extractChain(&input))
            XCTAssertEqual(7, result)
        } catch {
            XCTFail()
        }
    }
    
    func test_sumPart2() {
        var input: [RomanNumeral] = [.I, .V]
        do {
            let result = RomanNumeral.sumChain(try RomanNumeral.extractChain(&input))
            XCTAssertEqual(4, result)
        } catch {
            XCTFail()
        }
    }
    
    func test_adding_two_roman_numerals() {
        let origin = "VII" // 7
        do {
            let result = try origin.addRomanNumeral("VII") // 7
            XCTAssertEqual("XIV", result) // 14
        } catch {
            XCTFail()
        }
    }
    
    func test_adding_two_roman_numerals2() {
        let origin = "CXXIII" // 123
        do {
            let result = try origin.addRomanNumeral("CDLVI") // 456
            XCTAssertEqual("DLXXIX", result) // 579
        } catch {
            XCTFail()
        }
    }
}
