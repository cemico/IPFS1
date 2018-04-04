//
//  FileViewController.swift
//  IPFS1
//
//  Created by Dave Rogers on 3/19/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import UIKit
import SwiftIpfsApi
import SwiftMultihash
import MessageUI

class FileViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    ///////////////////////////////////////////////////////////
    // outlets
    ///////////////////////////////////////////////////////////

    @IBOutlet weak var contentTextLabel: UILabel!
    @IBOutlet weak var contentImageLabel: UIImageView!
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var extraLabel: UILabel!
    @IBOutlet weak var bytesLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    ///////////////////////////////////////////////////////////
    // variables
    ///////////////////////////////////////////////////////////

    var ipfsImage: UIImage?
    var ipfsText: String?
    var ipfsIsLoading = false

    var model: CryptoKeyModel? {

        didSet {

            updateModel()
        }
    }

    var isImageModel: Bool {

        guard contentImageLabel != nil else { return false }
        guard let model = model else { return false }

        return (model.type.lowercased() == "image")
    }

    var ipfsGatewayUrl: String {

        guard let model = model else { return "" }
        return "https://ipfs.io/ipfs/\(model.key)"
    }
    
    ///////////////////////////////////////////////////////////
    // system overrides
    ///////////////////////////////////////////////////////////

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let model = model else { return }
        dateLabel.text = model.date
        extraLabel.text = model.extra
        keyLabel.text = model.key

        updateModel()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let vc = segue.destination as? ExternalViewController {

            // construct ipfs gateway hash lookup url
            vc.url = ipfsGatewayUrl
        }
    }

    ///////////////////////////////////////////////////////////
    // actions
    ///////////////////////////////////////////////////////////

    @IBAction func onShare(_ sender: Any) {

        guard MFMessageComposeViewController.canSendText() else { return }

        let messageVC = MFMessageComposeViewController()
        messageVC.body = "From a land far, far away...\n\n\(ipfsGatewayUrl)"
//        messageVC.recipients = ["4082342285"]
        messageVC.recipients = []
        messageVC.messageComposeDelegate = nil
        self.present(messageVC, animated: true, completion: nil)

        print("share")
    }

    ///////////////////////////////////////////////////////////
    // message delegate
    ///////////////////////////////////////////////////////////

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {

        switch result.rawValue {

            case MessageComposeResult.cancelled.rawValue:
                print("Message was cancelled")

            case MessageComposeResult.failed.rawValue:
                print("Message failed")

            case MessageComposeResult.sent.rawValue:
                print("Message was sent")

            default:
                break
        }

        controller.dismiss(animated: true, completion: nil)
    }

    ///////////////////////////////////////////////////////////
    // helpers
    ///////////////////////////////////////////////////////////

    private func updateModel() {

        // optional in case model set before outlets wired
        guard contentImageLabel != nil else { return }

        // show active type
        contentImageLabel.isHidden = !isImageModel
        contentTextLabel.isHidden = isImageModel

        if isImageModel && ipfsImage != nil {

            // image
            contentImageLabel.image = ipfsImage
        }
        else if !isImageModel && ipfsText != nil {

            // text
            contentTextLabel.text = ipfsText
        }
        else {

            // one-time load
            loadFromIpfs()
        }
    }

    private func loadFromIpfs() {

        guard let model = model else { printInfo("No model set"); return }

        ipfsIsLoading = true
        spinner.startAnimating()
        spinner.isHidden = false

        // external
        let ipfsGateway = "147.135.130.181"
        let port80 = 80

        // local
//        let localHost = "127.0.0.1"
//        let port5001 = 8005

//        let text1 = "QmcDsbeSnw6Eoi8nPPw9vTiGAHEUfMbHbU6fpiuFx3xWpL"
//        let jpg1 = "QmXWmucTKr86jNtRGNXgGAxjezwCkx2joumPiJ31RWtkY2"
//        let png1 = "QmexmDJEV6oTNDs1nyj6pVuV4NLwgwfaeCAyZ64a9RLJhh"

        let host = ipfsGateway // localHost // ipfsGateway
        let port = port80      // port5001  // port80
        do {

            // get multihash from cryptographic has key
            let multihash = try fromB58String(model.key)
            printInfo("chash: \(model.key)")
            printInfo("mhash: \(multihash.string())")

            // setup ipfs api
            let api = try IpfsApi(host: host, port: port)

            // request data
            printInfo("ipfs api request call")
            try api.get(multihash, completionHandler: { (bits) in

                let data = Data(bytes: bits)
                printInfo("bytes received: \(data.count)")

                DispatchQueue.main.async { [weak self] in

                    guard let strongSelf = self else { return }
                    strongSelf.ipfsIsLoading = false
                    strongSelf.bytesLabel.text = "bytes: \(data.count)"

                    // extract data
                    if strongSelf.isImageModel {

                        // image data
                        strongSelf.ipfsImage = UIImage(data: data)
                    }
                    else {

                        // text data
                        if let text = data.string(as: .utf8) {

                            strongSelf.ipfsText = text
                        }
                        else {

                            strongSelf.ipfsText = "Unable to unencode data"
                        }
                    }

                    // show
                    strongSelf.spinner.stopAnimating()
                    strongSelf.updateModel()
                }
            })
        }
        catch {

            let msg = "\(error)"
            ipfsText = msg
            printError("There was an error connecting: \(msg)")
            spinner.stopAnimating()
        }
    }
}
