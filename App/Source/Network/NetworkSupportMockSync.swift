//
//  NetworkSupportMockSync.swift
//  IPFS1
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

class NetworkSupportMockSync: NetworkSupport {

    func handleGetCryptoKeys(request: URLRequest, processingCompletionHandler: @escaping (CryptoKeysModel?) -> Void) {

        // common handler for any derived protocol classes
        doGetCryptoKeys(request: request, processingCompletionHandler: processingCompletionHandler)
    }

    func handlePostNewText(request: URLRequest, processingCompletionHandler: @escaping (CryptoKeyModel?) -> Void) {

        // common handler for any derived protocol classes
        doPostNewText(request: request, processingCompletionHandler: processingCompletionHandler)
    }

    func doGetCryptoKeys(request: URLRequest, processingCompletionHandler: @escaping (CryptoKeysModel?) -> Void) {

        // simulated response - move out into seperate file with perhaps path being environment variable
        let body: Attributes = [ "id"     : "QmcDsbeSnw6Eoi8nPPw9vTiGAHEUfMbHbU6fpiuFx3xWpL",
                                 "type"   : "text",
                                 "nextId" : "",
                                 "userId" : "",
                                 "extra"  : "dynamic text",
                                 "date"   : "2018-03-16"  ]

        // serialize
        var data: Data?
        var error: Error?
        do {

            data = try JSONSerialization.data(withJSONObject: [body], options: [])
        }
        catch(let err) {

            error = err
        }

        // use common handler
        handleGetCryptoKeysResults(data: data, error: error, json: nil, resultsCompletionHandler: { (model: CryptoKeysModel?) in

            // pass results up
            processingCompletionHandler(model)
        })
    }

    func doPostNewText(request: URLRequest, processingCompletionHandler: @escaping (CryptoKeyModel?) -> Void) {

        // simulated response
        let body: Attributes = [ "text" : "Hi Mom abc",
                                 "type" : "text"  ]

        // serialize
        var data: Data?
        var error: Error?
        do {

            data = try JSONSerialization.data(withJSONObject: body, options: [])
        }
        catch(let err) {

            error = err
        }

        // use common handler
        handlePostNewTextResults(data: data, error: error, json: nil, resultsCompletionHandler: { (model: CryptoKeyModel?) in

            // pass results up
            processingCompletionHandler(model)
        })
    }
}
