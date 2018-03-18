//
//  Date_Utils.swift
//  IPFS1
//
//  Created by Dave Rogers on 3/18/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

extension Date {

    ///////////////////////////////////////////////////////////
    // static / class
    ///////////////////////////////////////////////////////////

    static func from(any: Any, default value: Date = Date()) -> Date {

        return any as? Date ?? value
    }
}

