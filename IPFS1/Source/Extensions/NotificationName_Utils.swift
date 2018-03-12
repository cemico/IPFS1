//
//  NotificationName_Utils.swift
//  IPFS1
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

extension Notification.Name {

    //
    // unique messages to post
    //

    private struct Messages {

        // good practice using reverse dns notation
        private static let baseMessage  = companyReverseDomain + "messages."

        struct cat1 {

            static let prefix           = "cat1."
            static let ex1              = baseMessage + cat1.prefix + "ex1"
        }
    }

    //
    // keys to set and access posted data
    //

    struct Keys {

        struct cat1 {

            static let name1            = "name1"
            static let name2            = "name2"
        }
    }

    //
    // cat1
    // note: usage in postMessage: .cat1
    //

    static let cat1                     = Notification.Name(Messages.cat1.ex1)
}

