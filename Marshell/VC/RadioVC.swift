//
//  ViewController.swift
//  Marshell
//
//  Created by Edmund Feng on 2022/4/3.
//

import Cocoa
import WebKit

class RadioVC: NSViewController {
    
    static let shared = RadioVC.instanceFromStoryboard()
    
    private static func instanceFromStoryboard() -> Self {
        let vc = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "RadioVC") as! Self
        return vc
    }
    
    //MARK: - Views outlet
    @IBOutlet weak var radioWebView: WKWebView!
    @IBOutlet weak var radioTitleLabel: NSTextField!
    @IBOutlet weak var radioURLLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        radioWebView.load(URLRequest(url: URL(string: "https://www.youtube.com/embed/oVi5gtzTDx0")!))

    
    }
    
    @IBOutlet weak var pinButton: NSButton!
    @IBAction func pin(sender: NSButton) {
        
    }

    @IBAction func changeRadio(sender: NSButton) {
        
    }
    
    @IBAction func more(sender: NSButton) {
        
    }
}

extension RadioVC: NSCollectionViewDataSource, NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let radioItem = RadioCollectionViewItem()
        return radioItem
    }
    
    
}
