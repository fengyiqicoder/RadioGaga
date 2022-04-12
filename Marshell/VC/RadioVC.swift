//
//  ViewController.swift
//  Marshell
//
//  Created by Edmund Feng on 2022/4/3.
//

import Cocoa
import WebKit
import SnapKit

//Can't resize
class RadioVC: NSViewController {
    
    static let shared = RadioVC.instanceFromStoryboard()
    
    private static func instanceFromStoryboard() -> Self {
        let vc = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "RadioVC") as! Self
        return vc
    }
    
    //MARK: - Views outlet
    @IBOutlet weak var radioView: NSBox!
    @IBOutlet weak var radioTitleLabel: NSTextField!
    @IBOutlet weak var radioURLLabel: NSTextField!
    
    var currentWebview: WKWebView?
    var nextWebview: WKWebView?
    
    var model: [RadioSource] {
        RadioSourceController.shared.list
    }
    var currentPlaying: RadioSource = RadioSourceController.shared.list.first!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webview = WKWebView()
        self.view.addSubview(webview)
        webview.frame = radioView.frame
        webview.load(resource: currentPlaying)
        
        radioTitleLabel.stringValue = currentPlaying.title
        radioURLLabel.stringValue = webview.url?.absoluteString ?? ""
        
        currentWebview = webview
        
        let nextOrder = (1) % (model.count-1)
        nextWebview = createNextWebView(source: model[nextOrder])
    }
    
    @IBOutlet weak var pinButton: NSButton!
    @IBAction func pin(sender: NSButton) {
        
    }

    @IBAction func changeRadio(sender: NSButton) {
        guard let currentOrder = model.firstIndex(where: { $0.uuid == currentPlaying.uuid }) else { return }
        
        let nextOrder = (currentOrder + 1) % (model.count-1)
        let nextNextOrder = (nextOrder + 1) % (model.count-1)
        
        currentPlaying = model[nextOrder]
        load(source: model[nextOrder])
        nextWebview = createNextWebView(source: model[nextNextOrder])
    }
    
    @IBAction func more(sender: NSButton) {
        let menu = NSMenu()
        
        menu.addItem(withTitle: "Edit Radio Source", action: #selector(edit), keyEquivalent: "")
        menu.addItem(withTitle: "Open in Browser", action: #selector(openInBrowser), keyEquivalent: "")
        menu.addItem(withTitle: "Add New Source", action: #selector(addNewRadio), keyEquivalent: "")
        menu.addItem(withTitle: "Quit App", action: #selector(quitApp), keyEquivalent: "")
        
        menu.popUp(positioning: nil, at: sender.frame.center, in: sender.superview)
    }
    
    @objc
    func edit() {
        EditorWindowController.show(source: currentPlaying)
    }
    
    @objc
    func openInBrowser() {
        guard let url = URL(string: currentPlaying.url) else { return }
        NSWorkspace.shared.open(url)
    }
    
    @objc
    func addNewRadio() {
        EditorWindowController.show(source: nil)
    }
    
    @objc
    func quitApp() {
        NSApp.terminate(nil)
    }
    func createNextWebView(source: RadioSource) -> WKWebView? {
        
        guard let url = URL(string: source.url) else {
            return nil
        }
        
        let newWebView = WKWebView()
        newWebView.load(URLRequest(url: url))
        self.view.addSubview(newWebView)
        
        newWebView.frame = radioView.frame
        let radioViewSize = radioView.frame.width
        newWebView.frame.origin.x += radioViewSize
        
        return newWebView
    }
    
    func load(source: RadioSource) {
        
        guard let oldWebview = currentWebview else {
            print("报错-没有 old webview")
            return
        }
        
        radioTitleLabel.stringValue = source.title
        radioURLLabel.stringValue = source.url
    
        let newWebView = nextWebview ?? createNextWebView(source: source)
        let radioViewSize = radioView.frame.width

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.4
            
            newWebView?.animator().frame = radioView.frame
            oldWebview.animator().frame.origin.x -= radioViewSize
        } completionHandler: {
            oldWebview.removeFromSuperview()
        }

        currentWebview = newWebView
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


fileprivate extension WKWebView {
    func load(resource: RadioSource) {
        guard let url = URL(string: resource.url) else { return }
        load(URLRequest(url: url))
    }
}

extension CGRect {
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
}
