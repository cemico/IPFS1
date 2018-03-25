//
//  AddItemViewController.swift
//  IPFS1
//
//  Created by Dave Rogers on 3/20/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {

    ///////////////////////////////////////////////////////////
    // outlets
    ///////////////////////////////////////////////////////////

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    ///////////////////////////////////////////////////////////
    // variables
    ///////////////////////////////////////////////////////////

    var delegate: AddItemProtocol?

    ///////////////////////////////////////////////////////////
    // system overrides
    ///////////////////////////////////////////////////////////

    override func viewDidLoad() {
        super.viewDidLoad()

        updateSaveStatus()
        textView.becomeFirstResponder()
    }

    ///////////////////////////////////////////////////////////
    // helpers
    ///////////////////////////////////////////////////////////

    func updateSaveStatus() {

        saveButton.isEnabled = !textView.text.isEmpty
    }
}

///////////////////////////////////////////////////////////
// UITextView delegates
///////////////////////////////////////////////////////////

extension AddItemViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {

        updateSaveStatus()
    }
}

///////////////////////////////////////////////////////////
// actions
///////////////////////////////////////////////////////////

extension AddItemViewController {

    @IBAction func onCancel(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onSave(_ sender: Any) {

        self.delegate?.addTextItem(textView.text)
        self.dismiss(animated: true, completion: nil)
    }
}
