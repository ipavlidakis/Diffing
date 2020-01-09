//
//  Diffing+Differ.swift
//  Diffing
//
//  Created by Ilias Pavlidakis on 09/01/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation

struct WagnerFischerDiffer: DifferProtocol {

    func diff<T: Equatable>(
        _ source: [T],
        _ destination: [T]) -> Path<T> {

        let diffArray = Matrix(source: source, destination: destination)

        guard !source.isEmpty else {

            destination.enumerated().forEach {
                diffArray[0, $0.offset] = diffArray[0, max($0.offset - 1, 0)].create(byAppending: .insert($0.element))
            }
            return diffArray.optimalPath
        }

        guard !destination.isEmpty else {

            source.enumerated().forEach {
                diffArray[$0.offset, 0] = diffArray[max($0.offset - 1, 0), 0].create(byAppending: .delete($0.element))
            }
            return diffArray.optimalPath
        }

        for row in 0..<diffArray.size.rows {
            for column in 0..<diffArray.size.columns {

                let sourceValue = diffArray.sourceValue(at: row) //row < source.endIndex ? source[row] : nil
                let destinationValue = diffArray.destinationValue(at: column) //column < destination.endIndex ? destination[column] : nil

                guard sourceValue != nil || destinationValue != nil else { fatalError("Either sourceValue or destinationValue must not be nil") }

                switch (row, column) {
                    case (_, _) where sourceValue == destinationValue && row == column:
                        diffArray[row, column] = diffArray[max(0, row-1), max(0, column-1)]

                    case (0, 0) where sourceValue != nil && destinationValue != nil:  // topLeft item
                        diffArray[row, column].append(.substitute(source: sourceValue!, destination: destinationValue!))

                    case (0, _) where destinationValue != nil: // first row
                        diffArray[row, column] = diffArray[row, column-1].create(byAppending: .insert(destinationValue!))

                    case (_, 0) where sourceValue != nil: // first column
                        diffArray[row, column] = diffArray[row-1, column].create(byAppending: .delete(sourceValue!))

                    case (_, _) where sourceValue != nil && destinationValue != nil:
                        let leftItem = diffArray[row, column-1].create(byAppending: .delete(sourceValue!))
                        let topItem = diffArray[row-1, column].create(byAppending: .insert(destinationValue!))
                        let diagonalItem = diffArray[row-1, column-1].create(byAppending: .substitute(source: sourceValue!, destination: destinationValue!))
                        diffArray[row, column] = leftItem.shortest(b: topItem, c: diagonalItem)

                    case (_, _) where sourceValue == nil && destinationValue != nil:
                        diffArray[row, column] = diffArray[max(row-1, 0), max(column-1, 0)].create(byAppending: .insert(destinationValue!))

                    case (_, _) where sourceValue != nil && destinationValue == nil:
                        diffArray[row, column] = diffArray[max(row-1, 0), max(column-1, 0)].create(byAppending: .delete(sourceValue!))

                    default:
                        fatalError("Unhandled state")
                }
            }
        }

        return diffArray.optimalPath
    }
}
