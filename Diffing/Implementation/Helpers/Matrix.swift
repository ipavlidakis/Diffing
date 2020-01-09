//
//  Matrix.swift
//  Diffing
//
//  Created by Ilias Pavlidakis on 09/01/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation

final class Matrix<T: Equatable> {

    let size: (rows: Int, columns: Int)

    private let horizontalArray: [T]
    private let verticalArray: [T]
    private var array: [[Path<T>]]

    var optimalPath: Path<T> {
        switch (horizontalArray.isEmpty, verticalArray.isEmpty) {
            case (true, false): return self[size.rows - 1, 0]
            case (false, true): return self[0, size.columns - 1]
            case (false, false): return self[size.rows - 1, size.columns - 1]
            case (true, true): return .empty()
        }
    }

    init(source: [T], destination: [T]) {

        self.horizontalArray = destination
        self.verticalArray = source
        let count = max(source.count, destination.count)
        self.size = (count, count)
        self.array = Array<Array<Path<T>>>(
            repeating: Array<Path<T>>(repeating: .empty(), count: count),
            count: count)
    }

    subscript(_ row: Int, _ column: Int) -> Path<T> {
        get { array[row][column] }
        set { array[row][column] = newValue }
    }

    func sourceValue(at index: Int) -> T? {
        guard index < verticalArray.endIndex else { return nil }
        return verticalArray[index]
    }

    func destinationValue(at index: Int) -> T? {
        guard index < horizontalArray.endIndex else { return nil }
        return horizontalArray[index]
    }
}
