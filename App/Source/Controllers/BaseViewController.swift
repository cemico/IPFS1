//
//  BaseViewController.swift
//  IPFS1
//
//  Created by Dave Rogers on 3/12/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import UIKit

///////////////////////////////////////////////////////////
// selector support
///////////////////////////////////////////////////////////

fileprivate extension Selector {

    // more readable selector handling when notification handler observed
    static let changeLanguage = #selector(BaseViewController.changeLanguage(notification:))
}

class BaseViewController: UIViewController {

    ///////////////////////////////////////////////////////////
    // system overrides
    ///////////////////////////////////////////////////////////

    override func viewDidLoad() {
        super.viewDidLoad()

        // listen for bluetooth characteristics
        Broadcast.addObserver(self,
                              selector: .changeLanguage,
                              name: .changeLanguage,
                              object: nil)

        // initial localization
        doLocalize()
    }

    deinit {

        Broadcast.removeObserver(self)
    }

    ///////////////////////////////////////////////////////////
    // notifications
    ///////////////////////////////////////////////////////////

    @objc func changeLanguage(notification: Notification) {

        // extract data required data
        guard let newLanguageId = notification.userInfo?[NNKeys.Language.newLanguageId.rawValue] as? String else { return }

        // extract optional data
        var oldLanguageId = ""
        if let languageId = notification.userInfo?[NNKeys.Language.oldLanguageId.rawValue] as? String {

            oldLanguageId = languageId
        }

        printInfo("new language: \(newLanguageId), old language: \(oldLanguageId)")
        doLocalize()
    }

    ///////////////////////////////////////////////////////////
    // helpers
    ///////////////////////////////////////////////////////////

    private func doLocalize() {

        if let localizeVC = self as? LocalizeProtocol {

            // allow any vc which supports localization to update itself
            localizeVC.localize()
        }
    }
}
