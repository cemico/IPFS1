//
//  NetworkSupportAlamoFire.swift
//  IPFS1
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation
import Alamofire

///////////////////////////////////////////////////////////
// Alamofire implementation
///////////////////////////////////////////////////////////

class NetworkSupportAlamoFire: NetworkSupport {

    func handleGetCryptoKeys(request: URLRequest, processingCompletionHandler: @escaping (CryptoKeysModel?) -> Void) {

        Alamofire.request(request).responseJSON { [weak self] (response: DataResponse) in

            // capture strong reference
            guard let strongSelf = self else { processingCompletionHandler(nil); return }

            // extract results
            let data = response.data
            let error = response.result.error
//            let json = response.result.value as? Attributes

            // use common handler
            strongSelf.handleGetCryptoKeysResults(data: data, error: error, json: nil, resultsCompletionHandler: { (model: CryptoKeysModel?) in

                // pass results up
                processingCompletionHandler(model)
            })
        }
    }

    func handlePostNewText(request: URLRequest, processingCompletionHandler: @escaping (CryptoKeyModel?) -> Void) {

        Alamofire.request(request).responseJSON { [weak self] (response: DataResponse) in

            // capture strong reference
            guard let strongSelf = self else { processingCompletionHandler(nil); return }

            // extract results
            let data = response.data
            let error = response.result.error
            let json = response.result.value as? Attributes
            print(json)

            // use common handler
            strongSelf.handlePostNewTextResults(data: data, error: error, json: nil, resultsCompletionHandler: { (model: CryptoKeyModel?) in

                // pass results up
                processingCompletionHandler(model)
            })
        }
    }
}
