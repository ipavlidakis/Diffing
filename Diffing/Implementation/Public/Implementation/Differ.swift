//
//  Differ.swift
//  Diffing
//
//  Created by Ilias Pavlidakis on 09/01/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public enum Differ {

    static let wagnerFischer: DifferProtocol = WagnerFischerDiffer()
}
