//
//  ViewController.swift
//  Marshell
//
//  Created by Edmund Feng on 2022/4/3.
//

import Cocoa

class RadioVC: NSViewController {
    
    static let shared = RadioVC.instanceFromStoryboard()
    
    private static func instanceFromStoryboard() -> Self {
        let vc = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "RadioVC") as! Self
        return vc
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

