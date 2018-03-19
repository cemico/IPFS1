//
//  Data_Utils.swift
//  IPFS1
//
//  Created by Dave Rogers on 3/19/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

extension Data {

    var utf8String: String? {

        return string(as: .utf8)
    }

    func string(as encoding: String.Encoding) -> String? {

        return String(data: self, encoding: encoding)
    }
}
