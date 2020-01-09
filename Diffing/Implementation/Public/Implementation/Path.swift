//
//  Path.swift
//  Diffing
//
//  Created by Ilias Pavlidakis on 09/01/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public struct Path<T: Equatable> {

    private(set) var steps: [Step<T>] = []
    var count: Int { steps.count }

    mutating func append(_ step: Step<T>) { steps.append(step) }
}

extension Path {

    static func empty<T>() -> Path<T> { Path<T>() }

    func create(byAppending newStep: Step<T>) -> Path<T> {

        var newPath = self
        newPath.append(newStep)

        return newPath
    }

    func shortest(b: Path<T>, c: Path<T>) -> Path<T> {

        let first = count <= b.count ? self : b

        return first.count <= c.count ? first : c
    }
}

extension Path: CustomStringConvertible{

    public var description: String { "\(steps)" }

    public func prettyPrint() { steps.forEach { print("\($0)") } }
}
