//
//  Array_Utils.swift
//  IPFS1
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

extension Array {

    ///////////////////////////////////////////////////////////
    // static / class
    ///////////////////////////////////////////////////////////

    static func from(any: Any, default value: Array = []) -> Array {

        return any as? Array ?? value
    }
}

