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

        struct System {

            static let prefix           = "system."
            static let changeLanguage   = baseMessage + System.prefix + "changeLanguage"
        }

        struct Data {

            static let prefix           = "data."
            static let cryptoKeys       = baseMessage + Data.prefix + "cryptoKeys"
        }
    }

    //
    // keys to set and access posted data
    //

    struct Keys {

        enum Language: String {

            case oldLanguageId, newLanguageId
        }

        enum Data: String {

            case keys
        }
    }

    //
    // Acccessors
    // note: usage in postMessage: .cryptoKeys
    //

    static let changeLanguage           = Notification.Name(Messages.System.changeLanguage)
    static let cryptoKeys               = Notification.Name(Messages.Data.cryptoKeys)
}

