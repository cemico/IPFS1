//
//  NetworkSupportNative.swift
//  IPFS1
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

///////////////////////////////////////////////////////////
// native iOS implementation
///////////////////////////////////////////////////////////

class NetworkSupportNative: NetworkSupport {

    func handleGetCryptoKeys(request: URLRequest, processingCompletionHandler: @escaping (CryptoKeysModel?) -> Void) {

        // wrap native iOS networking support
        URLSession.dataRequest(request: request) { [weak self] (data: Data?, error: Error?) in

            // capture strong reference
            guard let strongSelf = self else { processingCompletionHandler(nil); return }

            // use common handler
            strongSelf.handleGetCryptoKeysResults(data: data, error: error, json: nil, resultsCompletionHandler: { (model: CryptoKeysModel?) in

                // pass results up
                processingCompletionHandler(model)
            })
        }
    }

    func handlePostNewText(request: URLRequest, processingCompletionHandler: @escaping (CryptoKeyModel?) -> Void) {

        // wrap native iOS networking support
        URLSession.dataRequest(request: request) { [weak self] (data: Data?, error: Error?) in

            // capture strong reference
            guard let strongSelf = self else { processingCompletionHandler(nil); return }

            // use common handler
            strongSelf.handlePostNewTextResults(data: data, error: error, json: nil, resultsCompletionHandler: { (model: CryptoKeyModel?) in

                // pass results up
                processingCompletionHandler(model)
            })
        }
    }
}

