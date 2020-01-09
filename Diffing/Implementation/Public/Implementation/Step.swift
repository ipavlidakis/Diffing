//
//  Step.swift
//  Diffing
//
//  Created by Ilias Pavlidakis on 09/01/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public enum Step<T: Equatable> {

    case insert(T)
    case delete(T)
    case substitute(source: T, destination: T)
}

extension Step: CustomStringConvertible {

    public var description: String {
        switch self {
            case .insert(let value): return "Add \(value)"
            case .delete(let value): return "Delete \(value)"
            case .substitute(let source, let destination): return "Substitute \(source) with \(destination)"
        }
    }
}

extension Step: Equatable {

    public static func == (lhs: Step<T>, rhs: Step<T>) -> Bool {

        switch (lhs, rhs) {
            case (.insert(let left), .insert(let right)): return left == right
            case (.delete(let left), .delete(let right)): return left == right
            case (.substitute(let leftSource, let leftDestination), .substitute(let rightSource, let rightDestination)): return leftSource == rightSource && leftDestination == rightDestination
            default: return false
        }
    }
}
