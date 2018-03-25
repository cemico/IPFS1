//
//  NetworkSupportMockAsync.swift
//  IPFS1
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

class NetworkSupportMockAsync: NetworkSupportMockSync {
    
    override func handleGetCryptoKeys(request: URLRequest, processingCompletionHandler: @escaping (CryptoKeysModel?) -> Void) {

        Concurrency.backgroundAsync { [weak self] in

            // call common handler since protocol derived classes don't play well with super
            self?.doGetCryptoKeys(request: request, processingCompletionHandler: processingCompletionHandler)
        }
    }

    override func handlePostNewText(request: URLRequest, processingCompletionHandler: @escaping (CryptoKeyModel?) -> Void) {

        super.handlePostNewText(request: request, processingCompletionHandler: processingCompletionHandler)
        Concurrency.backgroundAsync { [weak self] in

            // call common handler since protocol derived classes don't play well with super
            self?.doPostNewText(request: request, processingCompletionHandler: processingCompletionHandler)
        }
    }
}
