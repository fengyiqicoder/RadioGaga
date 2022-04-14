//
//  ViewController.swift
//  Marshell
//
//  Created by Edmund Feng on 2022/4/3.
//

import Cocoa
import WebKit
import SnapKit
import MediaPlayer

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
        
        
        //手动初始化第一个电台
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
    
    //MARK: Interface
    
    @IBOutlet weak var pinButton: NSButton!
    
    private var pinnedWindow: NSWindow?
    @IBAction func pin(sender: NSButton) {
        guard let appDelegate = (NSApp.delegate as? AppDelegate) else { return }
        guard let statusBarButton = appDelegate.statusBarButton else { return }
        
        if pinnedWindow == nil {
            
            let windowController = NSWindowController(window: NSWindow(contentViewController: RadioVC.shared))
            
            let window = windowController.window
            window?.styleMask = [.titled, .fullSizeContentView]
            window?.titlebarAppearsTransparent = true
            window?.titleVisibility = .hidden
            
            window?.isMovableByWindowBackground = true
            window?.setFrame(NSRect(x: 0, y: 0, width: 395, height: 270), display: false)
            window?.center()
            
            windowController.showWindow(windowController.window)
            pinnedWindow = window
            
            statusBarButton.disablePopover = true
            pinButton.image = NSImage(systemSymbolName: "pin.circle", accessibilityDescription: nil)?.withSymbolConfiguration(NSImage.SymbolConfiguration(pointSize: 17, weight: .medium))
        } else {
            appDelegate.updateStatusBarPopover()
            pinnedWindow?.close()
            pinnedWindow = nil
            
            statusBarButton.disablePopover = false
            pinButton.image = NSImage(systemSymbolName: "pin.circle.fill", accessibilityDescription: nil)?.withSymbolConfiguration(NSImage.SymbolConfiguration(pointSize: 17, weight: .medium))

        }
        
        
    }

    
    @IBAction func changeRadio(sender: NSButton) {
        guard let currentOrder = model.firstIndex(where: {
            $0.uuid == currentPlaying.uuid
        }) else { return }
        
        turningRadioTo(currentOrder + 1)
    }
    
    @IBAction func more(sender: NSButton) {
        let menu = NSMenu()
        menu.addItem(withTitle: "Add New Source", action: #selector(addNewRadio), keyEquivalent: "")
        menu.addItem(withTitle: "Edit This Source", action: #selector(edit), keyEquivalent: "")
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Raload", action: #selector(reloadWebView), keyEquivalent: "")
        menu.addItem(withTitle: "Open in Browser", action: #selector(openInBrowser), keyEquivalent: "")
        menu.addItem(withTitle: "Quit App", action: #selector(quitApp), keyEquivalent: "")
        
        menu.popUp(positioning: nil, at: sender.frame.center, in: sender.superview)
    }
    
    //Button Action
    @objc
    func reloadWebView() {
//        print("@ \(currentWebview?.url) \(nextWebview?.url)")
        currentWebview?.reload()
        nextWebview?.reload()
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
    
    //MARK: - Change radio
    
    func turningRadioTo(_ nextOrder: Int, cache: Bool = true) {
        
        let nextOrder = nextOrder % model.count
        let nextNextOrder = (nextOrder + 1) % model.count
                
        currentPlaying = model[nextOrder]
        load(source: currentPlaying, cache: cache)
        nextWebview = createNextWebView(source: model[nextNextOrder])
    }
    
    fileprivate
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
    
    fileprivate
    func load(source: RadioSource, cache: Bool = true) {
        
        guard let oldWebview = currentWebview else {
            print("报错-没有 old webview")
            return
        }
        
        radioTitleLabel.stringValue = source.title
        radioURLLabel.stringValue = source.url
        
        //选择是否使用之前生成的WebView
        var newWebView: WKWebView?
        if cache {
            newWebView = nextWebview ?? createNextWebView(source: source)
        } else {
            newWebView = createNextWebView(source: source)
        }
        let radioViewSize = radioView.frame.width

        if #available(macOS 12.0, *) {
            oldWebview.pauseAllMediaPlayback()
        }
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


fileprivate
extension WKWebView {
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
