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
    private var oldSource: RadioSource? {
        didSet {
            titleTextField.stringValue = oldSource?.title ?? ""
            urlTextField.stringValue = oldSource?.url ?? ""
        }
    }
    
    func load(source: RadioSource?) {
        deleteButton.isHidden = source == nil
        currentUUID = source?.uuid ?? UUID().uuidString
        oldSource = source
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func delete(sender: NSButton) {
        RadioVC.shared.delete(sourceID: currentUUID)
        self.view.window?.close()
    }
    @IBAction func done(sender: NSButton) {
        let urlStr = urlTextField.stringValue.addHttpIfNot().autoChangeYoutubeUrlToEmbed()
        guard let url = URL(string: urlStr) ?? URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            //alert URL 输入有误
            let alert = NSAlert()
            alert.alertStyle = .informational
            alert.messageText = NSLocalizedString("URL is malformed", comment: "")
            alert.addButton(withTitle: NSLocalizedString("OK", comment: ""))
            alert.runModal()
            return
        }
        
        let currentSource = RadioSource(uuid: currentUUID,
                                        url: url.absoluteString,
                                        title: titleTextField.stringValue)
        if oldSource == nil {
            RadioVC.shared.addNew(source: currentSource)
        } else {
            RadioVC.shared.update(source: currentSource)
        }
        self.view.window?.close()
    }
}

fileprivate
extension RadioVC {
    
    var sourceController: RadioSourceController {
        RadioSourceController.shared
    }
    
    func addNew(source: RadioSource) {
        sourceController.list.append(source)
        turningRadioTo(sourceController.list.endIndex - 1, cache: false)
    }
    
    func delete(sourceID: String) {
        
        let index = sourceController.list.firstIndex { source in
            source.uuid == sourceID
        }
        
        guard var index = index else { return }
        sourceController.list.remove(at: index)
        
        index = index >= sourceController.list.count ? 0 : index
        turningRadioTo(index, cache: false)
    }
    
    func update(source: RadioSource) {
        let index = sourceController.list.firstIndex {
            $0.uuid == source.uuid
        }
        
        guard var index = index else { return }
        sourceController.list[index] = source
        print("@ Index \(index)")
        index = index >= sourceController.list.count ? 0 : index
        turningRadioTo(index, cache: false)
    }
}

fileprivate
extension String {
    func addHttpIfNot() -> String {
        if hasPrefix("https://") || hasPrefix("http://") {
            return self
        } else {
            return "https://" + self
        }
    }
    
    func autoChangeYoutubeUrlToEmbed() -> String {
        
        var isYoutube: Bool = false
        var hasvValue: Bool = false
        
        guard let url = URL(string: self) else { return self }
        
        if self.contains("youtube") {
            isYoutube = true
        }
        if self.contains("watch?v=") {
            hasvValue = true
        }
        
        let embedYoutubeURLPreFix = "https://www.youtube.com/embed/"
        if isYoutube, hasvValue, let idStr = getQueryStringParameter(url: url.absoluteString, param: "v") {
            return embedYoutubeURLPreFix + idStr
        }
        
        return self
        
    }
    
    private
    func getQueryStringParameter(url: String, param: String) -> String? {
      guard let url = URLComponents(string: url) else { return nil }
      return url.queryItems?.first(where: { $0.name == param })?.value
    }
}
