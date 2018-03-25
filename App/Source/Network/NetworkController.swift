//
//  NetworkController.swift
//  IPFS1
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import UIKit

class NetworkController {

    ///////////////////////////////////////////////////////////
    // data members
    ///////////////////////////////////////////////////////////

    // setup singleton
    static let shared = NetworkController()

    // networking library
    var network: NetworkSupport? {

        didSet {

            if let network = network {

                printInfo("\(String(describing: type(of: network))) configured\n   api: \(Router.baseURLString)\n   rtc: \(Router.baseRtcURLString)")
            }
        }
    }

    ///////////////////////////////////////////////////////////
    // lifecycle
    ///////////////////////////////////////////////////////////

    private init() {

        printInfo("\(String.className(ofSelf: self)).\(#function)")
    }
}

extension NetworkController {

    ///////////////////////////////////////////////////////////
    // api
    ///////////////////////////////////////////////////////////

    func getCryptoKeys(completionHandler: @escaping (CryptoKeysModel?) -> Void) {

        // sanity check
        guard let network = network else { completionHandler(nil); return }

        // get request
        let route = Router.getCryptoKeys
        guard let request = try? route.asURLRequest() else { completionHandler(nil); return }

        // hit server specific implementation
        network.handleGetCryptoKeys(request: request, processingCompletionHandler: completionHandler)
    }

    func postNewText(text: String, completionHandler: @escaping (CryptoKeyModel?) -> Void) {

        // sanity check
        guard let network = network else { completionHandler(nil); return }

        // argument validation
        guard !text.isEmpty else { completionHandler(nil); return }

        // package up parameters
        let parameters: Attributes = [

            Router.SetText.type.rawValue : Router.SetText.text.rawValue,
            Router.SetText.text.rawValue : text
        ]
        printInfo("\(parameters)")

        // get request
        let route = Router.postCryptoKey(parameters)
        guard let request = try? route.asURLRequest(with: Settings.token) else { completionHandler(nil); return }

        // hit server specific implementation
        network.handlePostNewText(request: request, processingCompletionHandler: {(model: CryptoKeyModel?) in

            if model != nil {

                // save
            }

            // pass along
            completionHandler(model)
        })
    }
}


