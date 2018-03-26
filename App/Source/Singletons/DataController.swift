//
//  DataController.swift
//  IPFS1
//
//  Created by Dave Rogers on 3/18/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

class DataController {

    ///////////////////////////////////////////////////////////
    // data members
    ///////////////////////////////////////////////////////////

    // setup singleton
    static let shared = DataController()

    ///////////////////////////////////////////////////////////
    // lifecycle
    ///////////////////////////////////////////////////////////

    private init() {

        printInfo("\(String.className(ofSelf: self)).\(#function)")

        // update early in app launch
        updateCryptoKeys()
    }

    ///////////////////////////////////////////////////////////
    // managed data
    ///////////////////////////////////////////////////////////

    private var _cryptoKeys: [CryptoKeyModel] = []

    ///////////////////////////////////////////////////////////
    // api
    ///////////////////////////////////////////////////////////

    var cryptoKeys: [CryptoKeyModel] {

        // read-only / getter
        return _cryptoKeys
    }

    func addKey(_ key: CryptoKeyModel) {

        NSLock().synchronized {

            self._cryptoKeys.append(key)
        }
    }

    func updateCryptoKeys() {
        
        Network.getCryptoKeys { [weak self] (keys: CryptoKeysModel?) in

            guard let cryptoKeys = keys else { return }
            printInfo("\(cryptoKeys.keys.count) cryptoKeys found")

            // update data
            NSLock().synchronized {

                self?._cryptoKeys = cryptoKeys.keys
            }

            // inform of new data
            let userInfo: UserInfoDict = [ NNKeys.Data.keys.rawValue : cryptoKeys ]
            NotificationCenter.default.postMT(name: .cryptoKeys, userInfo: userInfo)
        }
    }

    func load() {

        // stub for readability on first singleton init
    }

    func clear() {

        let lock = NSLock()
        lock.synchronized() {

            self._cryptoKeys = []
        }
    }
}
