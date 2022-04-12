//
//  EditorWindonController.swift
//  Marshell
//
//  Created by Edmund Feng on 2022/4/12.
//

import Cocoa

class EditorWindowController: NSWindowController {
    static var instance: EditorWindowController? {
        NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "editorWindowController") as? EditorWindowController
    }
    static func show(source: RadioSource?) {
        guard let editorWindowController = instance else { return }
        
        let window = editorWindowController.window!
        let vc = window.contentViewController as? EditorViewController
        window.setFrame(CGRect(x: 0, y: 0, width: 343, height: 242), display: true)
        window.center()
        
        vc?.load(source: source ?? .zero)
        
        editorWindowController.showWindow(window)
        
    }
    
}




