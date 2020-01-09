//
//  WagnerFischerTests.swift
//  Diffing-Tests
//
//  Created by Ilias Pavlidakis on 09/01/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import XCTest

@testable import Diffing

final class WagnerFischerTests: XCTestCase {

    func test_case_1() {

        XCTAssert(Array("abcd"), Array("ABCD"), expectedSteps: [
            .substitute(source: "a", destination: "A"),
            .substitute(source: "b", destination: "B"),
            .substitute(source: "c", destination: "C"),
            .substitute(source: "d", destination: "D"),
        ])
    }

    func test_case_2() {

        XCTAssert(Array("abcd"), Array("ABCDeFGH"), expectedSteps: [
            .substitute(source: "a", destination: "A"),
            .substitute(source: "b", destination: "B"),
            .substitute(source: "c", destination: "C"),
            .substitute(source: "d", destination: "D"),
            .insert("e"),
            .insert("F"),
            .insert("G"),
            .insert("H"),
        ])
    }

    func test_case_3() {

        XCTAssert(Array("abcdE124"), Array("ABCD"), expectedSteps: [
            .substitute(source: "a", destination: "A"),
            .substitute(source: "b", destination: "B"),
            .substitute(source: "c", destination: "C"),
            .substitute(source: "d", destination: "D"),
            .delete("E"),
            .delete("1"),
            .delete("2"),
            .delete("4"),
        ])
    }

    func test_case_4() {

        XCTAssert(Array("abcd"), Array("aBcDE"), expectedSteps: [
            .substitute(source: "b", destination: "B"),
            .substitute(source: "d", destination: "D"),
            .insert("E")
        ])
    }

    func test_case_5() {

        XCTAssert([1, 2, 3, 4], [2, 3, 5, 7, 7, 8], expectedSteps: [
            .substitute(source: 1, destination: 2),
            .substitute(source: 2, destination: 3),
            .substitute(source: 3, destination: 5),
            .substitute(source: 4, destination: 7),
            .insert(7),
            .insert(8)
        ])
    }

    func test_case_6() {

        XCTAssert(Array("abcd"), Array(""), expectedSteps: [
            .delete("a"),
            .delete("b"),
            .delete("c"),
            .delete("d"),
        ])
    }

    func test_case_7() {

        XCTAssert(Array(""), Array("abcd"), expectedSteps: [
            .insert("a"),
            .insert("b"),
            .insert("c"),
            .insert("d"),
        ])
    }
}

private extension WagnerFischerTests {

    func XCTAssert<T>(
        _ source: @autoclosure () throws -> [T],
        _ destination: @autoclosure () throws -> [T],
        expectedSteps: [Step<T>],
        _ message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line) where T : Equatable {

        guard let _source = try? source() else { return XCTFail("Source cannot be nil", file: file, line: line) }
        guard let _destination = try? destination() else { return XCTFail("Destination cannot be nil", file: file, line: line) }

        let path = Differ.wagnerFischer.diff(_source, _destination)

        XCTAssertEqual(path.steps, expectedSteps, message(), file: file, line: line)
    }
}
