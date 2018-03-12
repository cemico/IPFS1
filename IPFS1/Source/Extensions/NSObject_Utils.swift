//
//  NSObject_Utils.swift
//  IPFS1
//
//  Created by Dave Rogers on 3/4/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

extension NSObject {

    ///////////////////////////////////////////////////////////
    // computed properties
    ///////////////////////////////////////////////////////////

    var className: String {

        return type(of: self).className
    }

    ///////////////////////////////////////////////////////////
    // static / class
    ///////////////////////////////////////////////////////////

    static var className: String {

        return String(describing: self)
    }
}


