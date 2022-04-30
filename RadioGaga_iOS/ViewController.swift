//
//  ViewController.swift
//  RadioGaga_iOS
//
//  Created by Edmund Feng on 2022/4/18.
//

import UIKit
import WebKit
import SnapKit
import AVFoundation

class ViewController: UIViewController {

    var webview: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(true)
        
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        
        webview = WKWebView(frame: .zero, configuration: config)
        webview.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.88 Safari/537.36"
        webview.load(URLRequest(url: URL(string: "https://www.youtube.com/embed/oVi5gtzTDx0?playsinline=1&autoplay=1")!))
//        webview.load(URLRequest(url: URL(string: "https://lofi.cafe")!))
        view.addSubview(webview)
        
        webview.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(200)
        }
        
        
    }


}

