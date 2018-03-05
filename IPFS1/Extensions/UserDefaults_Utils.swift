//
//  UserDefaults_Utils.swift
//  IPFS1
//
//  Created by Dave Rogers on 3/4/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import UIKit

// quick accessor
var Settings = UserDefaults.standard

// utilize #function for naming
extension UserDefaults {

    // temp user list
    var users: [String : String] {

        get {

            return self.dictionary(forKey: #function) as? [String : String] ?? [:]
        }

        set {

            self.set(newValue, forKey: #function)
            self.synchronize()
        }
    }
}

