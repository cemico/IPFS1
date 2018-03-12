//
//  Router.swift
//  IPFS1
//
<<<<<<< HEAD
//  Created by Dave Rogers on 3/11/18.
=======
//  Created by Dave Rogers on 3/6/18.
>>>>>>> 4f4328a04c5b0fc34a549f30ebbb03ba973200ca
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation
<<<<<<< HEAD

// used for encoding routines
import Alamofire

///////////////////////////////////////////////////////////
// alias for ease of reading
///////////////////////////////////////////////////////////

public typealias PinnAttributes = [String: Any]

///////////////////////////////////////////////////////////
// router definition
//
// decent article: https://grokswift.com/router/
//
///////////////////////////////////////////////////////////

enum Router {

    ///////////////////////////////////////////////////////////
    // router enums
    ///////////////////////////////////////////////////////////

    // each case can have various arguments if IDs and such need to be passed in
    case health

    // registers
    case regSendSmsCode(PinnAttributes)
    case regRedeemSmsCode(PinnAttributes)
    case regUsDriverLicense(PinnAttributes)
    case regReverify(PinnAttributes)
    case regPasscode(PinnAttributes)
    case regEnroll(PinnAttributes)
    case regFinalize(PinnAttributes)

    // auths
    case qrToken(PinnAttributes)
    case authenticate(PinnAttributes)
    case authenticateLocal(PinnAttributes)
    case socketConnect

    case joinOrg(PinnAttributes)
}

extension Router {

    ///////////////////////////////////////////////////////////
    // constants
    ///////////////////////////////////////////////////////////

    fileprivate struct Constants {

        struct Api {

            // schemes / protocols
            static let httpsScheme              = "https://"
            static let currentScheme            = Api.httpsScheme

            // canonical names / subdomains
            static let wwwCName                 = "www."
            static let idCName                  = "api."
            static let rtcCName                 = "rtc."
            static let currentRtcCName          = Api.rtcCName
            static let currentCName             = Api.idCName

            // hosts / domains
            static let stagingHost              = "pinnstaging.com"
            static let devHost                  = "pinndev.com"
            static let prodHost                 = "pinn.com"

            // versions
            static let vNone                    = ""
            static let v1                       = "/v1"
            static let currentVersion           = Api.vNone

            // pulling it all together
            #if PN_CNF_DBG

            static let currentHost              = Api.devHost
            static let currentBase              = Api.currentScheme + Api.idCName         + Api.currentHost
            #elseif PN_CNF_BETA

            static let currentHost              = Api.stagingHost
            static let currentBase              = Api.currentScheme + Api.idCName         + Api.currentHost
            #else

            static let currentHost              = Api.prodHost
            static let currentBase              = Api.currentScheme + Api.currentCName    + Api.currentHost + Api.currentVersion
            #endif
            static let currentRtcBase           = Api.currentScheme + Api.currentRtcCName + Api.currentHost + Api.currentVersion

        }

        struct Endpoints {

            static let health                   = "/ra/health"
            static let joinOrg                  = "/join-organization"

            struct Register {

                // multiple registration paths
                static let registerBase         = "/register"

                static let sendSmsCode          = registerBase + "/send-sms-code"
                static let redeemSmsCode        = registerBase + "/redeem-sms-code"
                static let usDriverLicense      = registerBase + "/documents/dl"
                static let reverify             = registerBase + "/reverify"
                static let passcode             = registerBase + "/passcode"
                static let enroll               = registerBase + "/enroll"
                static let finalize             = registerBase + "/finalize"
            }

            struct Auth {

                static let qrToken              = "/login-token"                // qr scans
                static let authenticate         = "/authenticate"
                static let authenticateLocal    = "/authenticate-local"
                static let socketConnect        = "/connect"
            }
        }

        struct HeaderKeys {

            static let authorization            = "Authorization"
            static let appId                    = "App-ID"
        }

        struct HeaderValues {

            static let authorization            = "prk_xAGJxEME6k3nKPNTm1lQidQWeyWCVOx6wd6TyPed"
        }
    }

    struct ServerKeys {

        struct Auth {

            // keys both sent and received
            static let contextId                = "context_id"
            static let signature                = "signature"
            static let token                    = "token"
            static let secret                   = "secret"
            static let passcode                 = "passcode"
            static let face                     = "face"
            static let keystroke                = "keystroke"
            static let force                    = "force"
            static let verificationResponse     = "verification_response"
            static let platform                 = "platform"
            static let platformVersion          = "platform_version"
            static let deviceName               = "device_name"
            static let deviceToken              = "device_token"
            static let deviceCheckToken         = "device_check_token"
            static let publicKey                = "public_key"
            static let bioPublicKey             = "bio_public_key"
            static let samples                  = "samples"
            static let code                     = "code"
            static let device                   = "device"
            static let mobileNumber             = "mobile_number"
            static let error                    = "error"
            static let barcode                    = "barcode"
        }

        struct Sockets {

            static let url                      = "url"
        }

        struct JoinOrg {

            static let email                    = "email"
        }
    }

    struct ServerValues {

        static let platform                     = "ios"
    }
}

extension Router {

    ///////////////////////////////////////////////////////////
    // computed properties
    ///////////////////////////////////////////////////////////

    static var baseURLString: String = {

        // all static parts of the url
        return Constants.Api.currentBase
    }()

    static var hostname: String = {

        return Constants.Api.idCName + Constants.Api.currentHost
    }()

    static var baseRtcURLString: String = {

        // all static parts of the url
        return Constants.Api.currentRtcBase
    }()

    static var token: String = {

        // default - token changes per network step, thus the variable versus a user default
        return Constants.HeaderValues.authorization
    }()

    var method: Alamofire.HTTPMethod {

        switch self {

        // GETs
        case .health:
            return .get

            // POSTs

        // registers
        case .regSendSmsCode:        fallthrough
        case .regRedeemSmsCode:    fallthrough
        case .regUsDriverLicense:    fallthrough
        case .regReverify:        fallthrough
        case .regPasscode:        fallthrough
        case .regEnroll:            fallthrough
        case .regFinalize:        fallthrough

        // auths
        case .qrToken:            fallthrough
        case .authenticate:        fallthrough
        case .authenticateLocal:    fallthrough
        case .socketConnect:        fallthrough
        case .joinOrg:
            return .post
        }
    }

    var path: String {

        switch self {

        case .health:
            return Constants.Endpoints.health

            //
            // registers
            //

        case .regSendSmsCode:
            return Constants.Endpoints.Register.sendSmsCode

        case .regRedeemSmsCode:
            return Constants.Endpoints.Register.redeemSmsCode

        case .regUsDriverLicense:
            return Constants.Endpoints.Register.usDriverLicense

        case .regReverify:
            return Constants.Endpoints.Register.reverify

        case .regPasscode:
            return Constants.Endpoints.Register.passcode

        case .regEnroll:
            return Constants.Endpoints.Register.enroll

        case .regFinalize:
            return Constants.Endpoints.Register.finalize

            //
            // auths
            //

        case .qrToken:
            return Constants.Endpoints.Auth.qrToken

        case .authenticate:
            return Constants.Endpoints.Auth.authenticate

        case .authenticateLocal:
            return Constants.Endpoints.Auth.authenticateLocal

        case .socketConnect:
            return Constants.Endpoints.Auth.socketConnect

        case .joinOrg:
            return Constants.Endpoints.joinOrg
        }
    }

    var addHeaders: Bool {

        // all secure except few
        switch self {

        case .health:
            return false

        // most add the header
        default:
            return true
        }
    }

    ///////////////////////////////////////////////////////////
    // header fields
    ///////////////////////////////////////////////////////////

    static var headers: [String: String] {

        // common headers
        get {

            var tmpHeaders: [String: String] = [:]

            // header - bearer
            var token = Router.token
            if token.isEmpty {

                // use first accessor token
                token = Constants.HeaderValues.authorization
            }

            if !token.isEmpty {

                //                tmpHeaders[Constants.HeaderKeys.authorization] = "Bearer \(token)"
                tmpHeaders[Constants.HeaderKeys.authorization] = "\(token)"
            }

            // header - app id
            if let bundleId = Bundle.main.bundleIdentifier {

                // thought it would be nice to push this to server too, in case
                // another app comes out, can distinguish where the call is being made
                tmpHeaders[Constants.HeaderKeys.appId] = bundleId
            }

            return tmpHeaders
        }
    }
}

extension Router {

    ///////////////////////////////////////////////////////////
    // support enums
    ///////////////////////////////////////////////////////////

    enum RouterErrors: Error {

        case UnableToCreateURL
    }

    ///////////////////////////////////////////////////////////
    // internal request type enum
    ///////////////////////////////////////////////////////////

    fileprivate enum EncodeRequestType {

        case url, json, array, `default`
    }
}

extension Router: URLRequestConvertible {

    // helper function to wrap token setting before request generated
    func asURLRequest(with token: String) throws -> URLRequest {

        // update for this call's use only
        Router.token = token
        return try asURLRequest()
    }

    //
    // returns a URL request or throws if an `Error` was encountered
    //
    // - throws: An `Error` if the underlying `URLRequest` is `nil`
    //
    // - returns: A URL request
    //

    public func asURLRequest() throws -> URLRequest {

        // setup URL
        guard let URL = Foundation.URL(string: Router.baseURLString) else {

            throw RouterErrors.UnableToCreateURL
        }

        // setup physical request
        var mutableURLRequest = URLRequest(url: URL.appendingPathComponent(path))
        mutableURLRequest.httpMethod = method.rawValue

        // add any headers if needed
        if addHeaders {

            for (key, value) in Router.headers {

                mutableURLRequest.setValue(value, forHTTPHeaderField: key)
            }
        }

        // provide any parameter encoding if needed
        switch self {

            // perhaps blocks for each type of EncodeRequestType

        // json encoding
        case .regSendSmsCode(let parameters):
            return encodeRequest(mutableURLRequest, requestType: .json, parameters: parameters)
        case .regRedeemSmsCode(let parameters):
            return encodeRequest(mutableURLRequest, requestType: .json, parameters: parameters)
        case .regUsDriverLicense(let parameters):
            return encodeRequest(mutableURLRequest, requestType: .json, parameters: parameters)
        case .regReverify(let parameters):
            return encodeRequest(mutableURLRequest, requestType: .json, parameters: parameters)
        case .regPasscode(let parameters):
            return encodeRequest(mutableURLRequest, requestType: .json, parameters: parameters)
        case .regEnroll(let parameters):
            return encodeRequest(mutableURLRequest, requestType: .json, parameters: parameters)
        case .regFinalize(let parameters):
            return encodeRequest(mutableURLRequest, requestType: .json, parameters: parameters)
        case .qrToken(let parameters):
            return encodeRequest(mutableURLRequest, requestType: .json, parameters: parameters)
        case .authenticate(let parameters):
            return encodeRequest(mutableURLRequest, requestType: .json, parameters: parameters)
        case .authenticateLocal(let parameters):
            return encodeRequest(mutableURLRequest, requestType: .json, parameters: parameters)
        case .socketConnect:
            return encodeRequest(mutableURLRequest, requestType: .json, parameters: nil)
        case .joinOrg(let parameters):
            return encodeRequest(mutableURLRequest, requestType: .json, parameters: parameters)

            //            // url example
            //            case .updateABC(let parameters):
            //                return encodeRequest(mutableURLRequest, requestType: .url, parameters: parameters)
            //
            //            // array example (body encoding of array values)
            //            case .postABCResponses(let arrayItems):
            //                return encodeRequest(mutableURLRequest, requestType: .array, arrayItems: arrayItems)

            // simple call, no parameters / no encoding
        //            case .health:       fallthrough
        default:
            return encodeRequest(mutableURLRequest, requestType: .default)
        }
    }

    private func encodeRequest(_ mutableURLRequest: URLRequest,
                               requestType: EncodeRequestType,
                               parameters: PinnAttributes? = nil,
                               arrayItems: [PinnAttributes]? = nil) -> URLRequest {

        var encodedMutableURLRequest = mutableURLRequest

        // encode requested data
        switch requestType {

            case .json:
                encodedMutableURLRequest = try! Alamofire.JSONEncoding.default.encode(mutableURLRequest, with: parameters)

            case .url:
                encodedMutableURLRequest = try! Alamofire.URLEncoding.default.encode(mutableURLRequest, with: parameters)

            case .array:

                if let arrayItems = arrayItems {

                    // encode array to body
                    do {

                        // pass data in body of request
                        let data = try JSONSerialization.data(withJSONObject: arrayItems, options: [])
                        encodedMutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        encodedMutableURLRequest.httpBody = data
                    }
                    catch let error as NSError {

                        printError("ERROR Array JSON serialization failed: \(error)")

                    }
                }

            default:
                // no encoding - use passed in mutableURLRequest
                break
        }

        if let url = encodedMutableURLRequest.url {

            printInfo("URL: \(url)")
        }
        return encodedMutableURLRequest
    }
}

extension Router: URLConvertible {

    func asURL() throws -> URL {

        do {

            // reuse existing framework to get fully composed url
            let urlRequest = try asURLRequest()
            if let url = urlRequest.url {

                return url
            }
        }
        catch let error as NSError {

            printError("ERROR \(#function): \(error)")
        }

        // error mapping
        throw RouterErrors.UnableToCreateURL
    }
}
=======
>>>>>>> 4f4328a04c5b0fc34a549f30ebbb03ba973200ca
