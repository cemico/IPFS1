//
//  ExternalViewController.swift
//  IPFS1
//
//  Created by Dave Rogers on 3/19/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import UIKit
import WebKit

class ExternalViewController: UIViewController, WKNavigationDelegate {

    ///////////////////////////////////////////////////////////
    // outlets
    ///////////////////////////////////////////////////////////

    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var webView: WKWebView! { didSet { webView.navigationDelegate = self; updateBrowser() } }

    ///////////////////////////////////////////////////////////
    // variables
    ///////////////////////////////////////////////////////////

    var url: String? { didSet { updateBrowser() }}

    // one-time web load
    var isLoading = false

    ///////////////////////////////////////////////////////////
    // system overrides
    ///////////////////////////////////////////////////////////

    override func viewDidLoad() {
        super.viewDidLoad()

        updateBrowser()
    }

    ///////////////////////////////////////////////////////////
    // helpers
    ///////////////////////////////////////////////////////////

    func updateBrowser() {

        guard let webView = webView else { return }
        guard let urlString = url else { return }
        guard !isLoading else { return }
        guard let url = URL(string: urlString) else { return }

        isLoading = true
        urlLabel.text = urlString
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = false
    }
}
