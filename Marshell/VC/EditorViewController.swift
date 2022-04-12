//
//  EditorViewController.swift
//  Marshell
//
//  Created by Edmund Feng on 2022/4/12.
//

import AppKit

class EditorViewController: NSViewController {
    
    @IBOutlet var titleTextField: NSTextField!
    @IBOutlet var urlTextField: NSTextField!
    
    @IBOutlet var doneButton: NSButton!
    @IBOutlet var deleteButton: NSButton!
    
    private var currentUUID: String!
    private var currentSource: RadioSource? {
        didSet {
            titleTextField.stringValue = currentSource?.title ?? ""
            urlTextField.stringValue = currentSource?.url ?? ""
        }
    }
    
    func load(source: RadioSource?) {
        deleteButton.isHidden = source == nil
        currentSource = source
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func delete(sender: NSButton) {
        self.view.window?.close()
    }
    @IBAction func done(sender: NSButton) {
        self.view.window?.close()
    }
}
