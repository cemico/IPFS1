//
//  NetworkSupportMockSync.swift
//  IPFS1
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

class NetworkSupportMockSync: NetworkSupport {

    func handleCryptoKeys(request: URLRequest, processingCompletionHandler: @escaping (CryptoKeysModel?) -> Void) {

        // common handler for any derived protocol classes
        doCryptoKeys(request: request, processingCompletionHandler: processingCompletionHandler)
    }

    func handleRoute2(request: URLRequest, processingCompletionHandler: @escaping (Route2Model?) -> Void) {

        // common handler for any derived protocol classes
        doRoute2(request: request, processingCompletionHandler: processingCompletionHandler)
    }

    func doCryptoKeys(request: URLRequest, processingCompletionHandler: @escaping (CryptoKeysModel?) -> Void) {

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
        handleCryptoKeysResults(data: data, error: error, json: nil, resultsCompletionHandler: { (model: CryptoKeysModel?) in

            // pass results up
            processingCompletionHandler(model)
        })
    }

    func doRoute2(request: URLRequest, processingCompletionHandler: @escaping (Route2Model?) -> Void) {

        // simulated response
        let body: Attributes = [ "a" : "123",
                                 "b" : 123,
                                 "c" : "mama"  ]

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
        handleRoute2Results(data: data, error: error, json: nil, resultsCompletionHandler: { (model: Route2Model?) in

            // pass results up
            processingCompletionHandler(model)
        })
    }
}
