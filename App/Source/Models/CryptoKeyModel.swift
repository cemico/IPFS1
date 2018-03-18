//
//  CryptoKeyModel.swift
//  IPFS1
//
//  Created by Dave Rogers on 3/13/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

struct CryptoKeysModel: Decodable {

    var keys: [CryptoKeyModel]
}

// NSCoding for archiving and Codable for json
class CryptoKeyModel: NSCoding, Codable, CustomStringConvertible, Equatable {

    ///////////////////////////////////////////////////////////
    // enums
    ///////////////////////////////////////////////////////////

    // json auto-serialization into object creation
    private enum CodingKeys: String, CodingKey {

        // keys converted from server key to new local key

        // converted for readability
        case key            = "id"
        case url            = "_self"
        case internalId     = "_id"

        // converted to wrap optionals
        case _error         = "error"
        case _version       = "version"

        // keys unchanged
        case type
        case nextId
        case userId
        case extra
        case date
    }

    // archiving
    enum ArchiveKeys: String {

        // swift 4/3.2 nice, will auto-rawValue a String to match enum case
        // note: enums do not allow you to assign value from struct, only literals
        case key
        case type
        case nextId
        case userId
        case extra
        case date
        case url
        case internalId
        case error

        // synthesized
        case version

        static var all: [ArchiveKeys] = [ .key, .type, .nextId, .userId, .extra, .date, .url, .internalId, .error, .version ]

        func value(for model: CryptoKeyModel) -> Any {

            // getter
            switch self {

                case .key:              return model.key
                case .type:             return model.type
                case .nextId:           return model.nextId
                case .userId:           return model.userId
                case .extra:            return model.extra
                case .date:             return model.date
                case .url:              return model.url
                case .internalId:       return model.internalId
                
                case .error:            return model.error
                case .version:          return model.version
            }
        }
    }

    private enum Versions: String {

        struct Constants {

            // number of fractional digits supported
            static let versionPrecision = modelObjectVersionPrecision
        }

        // version the model to allow upgrade path if model changes in future
        case v1_00 = "1.00"

        // latest version
        static var currentVersion = Versions.v1_00
    }

    ///////////////////////////////////////////////////////////
    // data members
    ///////////////////////////////////////////////////////////

    // see custom coding keys for matching variables / keys
    var key: String
    var type: String
    var nextId: String
    var userId: String
    var extra: String
    var date: String
    var url: String
    var internalId: String

    // optionals (note: private scope works with Codable protocol)
    private var _error: String?

    // synthesized / optional (note: private scope works with Codable protocol)
    private var _version: String?

    ///////////////////////////////////////////////////////////
    // computed properties to wrap optionals
    ///////////////////////////////////////////////////////////

    var error: String {

        return _error ?? ""
    }

    var version: String {

        return _version ?? Versions.currentVersion.rawValue
    }

    //
    // NSCoding protocol
    //

    required init?(coder aDecoder: NSCoder) {

        //
        // used to restore / unarchive a previous value which was archived / encoded
        //

        // strings
        key         = aDecoder.decodeObject(forKey: ArchiveKeys.key.rawValue) as? String ?? ""
        type        = aDecoder.decodeObject(forKey: ArchiveKeys.type.rawValue) as? String ?? ""
        nextId      = aDecoder.decodeObject(forKey: ArchiveKeys.nextId.rawValue) as? String ?? ""
        userId      = aDecoder.decodeObject(forKey: ArchiveKeys.userId.rawValue) as? String ?? ""
        extra       = aDecoder.decodeObject(forKey: ArchiveKeys.extra.rawValue) as? String ?? ""
        url         = aDecoder.decodeObject(forKey: ArchiveKeys.url.rawValue) as? String ?? ""
        internalId  = aDecoder.decodeObject(forKey: ArchiveKeys.internalId.rawValue) as? String ?? ""
        date        = aDecoder.decodeObject(forKey: ArchiveKeys.date.rawValue) as? String ?? ""

        _error      = aDecoder.decodeObject(forKey: ArchiveKeys.error.rawValue) as? String ?? ""
        _version    = aDecoder.decodeObject(forKey: ArchiveKeys.version.rawValue) as? String ?? ""

        // if NSObject is super, need init: after variables initialized
        //        super.init()

        // check for upgrade
        updateToCurrent()
    }

    func encode(with aCoder: NSCoder) {

        //
        // used to encode / archive this object
        //

        // save
        for key in ArchiveKeys.all {

            // coerce from Any into native types
            switch key {

                // string types
                case .key, .type, .nextId, .userId, .extra, .date, .url, .internalId, .error, .version:
                    let value = String.from(any: key.value(for: self))
                    aCoder.encode(value, forKey: key.rawValue)
            }
        }
    }

    ///////////////////////////////////////////////////////////
    // helpers
    ///////////////////////////////////////////////////////////

    private func updateToCurrent() {

        // check for no prior version
        guard !version.isEmpty else {

            _version = Versions.currentVersion.rawValue
            return
        }

        // example versioning logic
        guard version != Versions.currentVersion.rawValue else {

            // same version - no upgrade
            return
        }

        // upgrade older version to current, could be actions at each version change
        if version == Versions.v1_00.rawValue {

            // upgrade from 1.00 to current

            // udpate version
            _version = Versions.v1_00.rawValue
        }
    }

    ///////////////////////////////////////////////////////////
    // equality helper
    ///////////////////////////////////////////////////////////

    func equalTo(_ selfTest: CryptoKeyModel) -> Bool {

        // object check, i.e. same physical object
        guard self !== selfTest else { return true }

        // property level equality check
        guard self.key == selfTest.key else { return false }

        return true
    }
}

///////////////////////////////////////////////////////////
// global level protocol conformance
///////////////////////////////////////////////////////////

func ==(lhs: CryptoKeyModel, rhs: CryptoKeyModel) -> Bool {

    // call into class so class so any potential heirarchy is maintained
    return lhs.equalTo(rhs)
}

