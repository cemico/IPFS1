//
//  ProcessInfo_Utils.swift
//  IPFS1
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

extension ProcessInfo {

    ///////////////////////////////////////////////////////////
    // statics
    ///////////////////////////////////////////////////////////

    static func isEnvironment(env: String) -> Bool {

        return (processInfo.environment[env] != nil)
    }

    static func iOSGTE(version: Int) -> Bool {

        return (processInfo.operatingSystemVersion.majorVersion >= version)
    }
}
