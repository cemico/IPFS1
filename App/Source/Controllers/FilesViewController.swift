//
//  FilesViewController.swift
//  IPFS1
//
//  Created by Dave Rogers on 3/4/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import UIKit
import SwiftIpfsApi
import SwiftMultihash

class FilesViewController: BaseViewController {

    ///////////////////////////////////////////////////////////
    // outlets
    ///////////////////////////////////////////////////////////

    @IBOutlet weak var tableView: UITableView!

    ///////////////////////////////////////////////////////////
    // variables
    ///////////////////////////////////////////////////////////

    // convert dict into (k,v) sorted array
    private lazy var users: [(key: String, value: String)] = Settings.users.sorted(by: <)

    ///////////////////////////////////////////////////////////
    // system overrides
    ///////////////////////////////////////////////////////////

    override func viewDidLoad() {
        super.viewDidLoad()

        let ipfsGateway = "147.135.130.181"
        let localHost = "127.0.0.1"
        let port80 = 80
        let port5001 = 5001
        let text1 = "QmcDsbeSnw6Eoi8nPPw9vTiGAHEUfMbHbU6fpiuFx3xWpL"
        let jpg1 = "QmXWmucTKr86jNtRGNXgGAxjezwCkx2joumPiJ31RWtkY2"
        let png1 = "QmexmDJEV6oTNDs1nyj6pVuV4NLwgwfaeCAyZ64a9RLJhh"

        let host = ipfsGateway // localHost // ipfsGateway
        let port = port80      // port5001  // port80
        do {
            let api = try IpfsApi(host: host, port: port)
            let multihash = try! fromB58String(jpg1)
            print("mhash: ", multihash.string())
            try api.get(multihash, completionHandler: { (bits) in
                let data = Data(bytes: bits)
                print("bytes:", data.count)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
//                    self.addressLabel.text = "Address: \(host):\(port)"
//                    self.hashLabel.text = "Hash: \(multihash.string())"
//                    self.imageView.image = image
                }
            })
        } catch {
            print("There was an error connecting")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Network.getCryptoKeys { (keys) in

            print(keys)
        }
    }

    ///////////////////////////////////////////////////////////
    // actions
    ///////////////////////////////////////////////////////////

    @IBAction func onAddUser(_ sender: UIBarButtonItem) {
    }
}

///////////////////////////////////////////////////////////
// Localize Protocol
///////////////////////////////////////////////////////////

extension FilesViewController: LocalizeProtocol {

    func localize() {

        // localize this screen
    }
}

///////////////////////////////////////////////////////////
// UITableViewDataSource
///////////////////////////////////////////////////////////

extension FilesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // guaranteed cell
        let cell = tableView.dequeueReusableCell(withIdentifier: FileTableViewCell.className, for: indexPath)

        // make custom mods
        if let cell = cell as? FileTableViewCell {

            // get data
            let data = users[indexPath.row]
            cell.name.text = data.key
        }

        return cell
    }
}

///////////////////////////////////////////////////////////
// UITableViewDelegate
///////////////////////////////////////////////////////////

extension FilesViewController: UITableViewDelegate {

}

///////////////////////////////////////////////////////////
// FileTableViewCell
///////////////////////////////////////////////////////////

class FileTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var hashKey: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
