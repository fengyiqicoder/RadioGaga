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
    
    var currentSource: RadioSource? {
        didSet {
            
        }
    }
    
    func load(source: RadioSource) {
        titleTextField.stringValue = source.title
        urlTextField.stringValue = source.url
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
