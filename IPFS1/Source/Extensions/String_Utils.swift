//
//  String_Utils.swift
//  IPFS1
//
//  Created by Dave Rogers on 3/4/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

extension String {

    static func className<T>(ofSelf: T) -> String {

        return String(describing: type(of: ofSelf))
    }
}

