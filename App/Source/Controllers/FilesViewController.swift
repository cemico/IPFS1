//
//  FilesViewController.swift
//  IPFS1
//
//  Created by Dave Rogers on 3/4/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import UIKit

///////////////////////////////////////////////////////////
// selector support
///////////////////////////////////////////////////////////

fileprivate extension Selector {

    // more readable selector handling when notification handler observed
    static let cryptoKeysUpdate = #selector(FilesViewController.cryptoKeysUpdate(notification:))
}

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
    private var cryptoKeys: [CryptoKeyModel] = []

    ///////////////////////////////////////////////////////////
    // system overrides
    ///////////////////////////////////////////////////////////

    override func viewDidLoad() {
        super.viewDidLoad()

        // listen for changes to crypto keys
        // note: released in base class
        Broadcast.addObserver(self,
                              selector: .cryptoKeysUpdate,
                              name: .cryptoKeys,
                              object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // update to latest
        cryptoKeys = DataCache.cryptoKeys
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let vc = segue.destination as? FileViewController {

            if let indexPath = tableView.indexPathForSelectedRow {

                vc.model = cryptoKeys[indexPath.row]
            }
        }
    }

    ///////////////////////////////////////////////////////////
    // notifications
    ///////////////////////////////////////////////////////////

    @objc func cryptoKeysUpdate(notification: Notification) {

        // extract data required data
        guard let cryptoKeys = notification.userInfo?[NNKeys.Data.keys.rawValue] as? CryptoKeysModel else { return }
        cryptoKeys.keys.forEach({ print("key:", $0.key) })

        // update local cache
        self.cryptoKeys = cryptoKeys.keys

        // note: comes in on main thread
        tableView.reloadData()
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

        return cryptoKeys.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // guaranteed cell
        let cell = tableView.dequeueReusableCell(withIdentifier: FileTableViewCell.className, for: indexPath)

        // make custom mods
        if let cell = cell as? FileTableViewCell {

            // get data
            let data = cryptoKeys[indexPath.row]
            cell.typeLabel.text = data.type
            cell.keyLabel.text = data.key
            cell.extraLabel.text = data.extra
            cell.dateLabel.text = data.date
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

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var extraLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
