//
//  AppDelegate.swift
//  Marshell
//
//  Created by Edmund Feng on 2022/4/3.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        initStatusBar()
        ReviewController.shared.checkForReviewRequest()
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    //MARK: - statusBar Item
    var statusBarButton: StatusBarController?

    var statusItem: NSStatusItem?

    
    fileprivate
    func initStatusBar() {
        
        if statusBarButton != nil { return }
        
        //Genarete suatus item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let statusBarButton = statusItem?.button {
            statusBarButton.image = NSImage(systemSymbolName: "radio", accessibilityDescription: nil)?.withSymbolConfiguration(NSImage.SymbolConfiguration(pointSize: 14, weight: .medium, scale: .medium))
            statusBarButton.image?.isTemplate = true
        }
        //Make popover
        let popover = NSPopover.init()
        popover.behavior = .transient
        popover.contentViewController = RadioVC.shared
        
        statusBarButton = StatusBarController(popover, item: statusItem!)
        statusBarButton?.show()
    }
    
    func updateStatusBarPopover() {
        //Make popover
        let popover = NSPopover.init()
        popover.behavior = .transient
        popover.contentViewController = RadioVC.shared
        statusBarButton?.popover = popover
    }
}


class StatusBarController {
    var statusItem: NSStatusItem
    
    var popover: NSPopover

    func hide() {
        statusItem.isVisible = false
    }

    func show() {
        statusItem.isVisible = true
    }

    init(_ popover: NSPopover, item: NSStatusItem) {
        self.statusItem = item
        self.popover = popover

        if let statusBarButton = statusItem.button {
            statusBarButton.action = #selector(togglePopover)
            statusBarButton.target = self
        }
    }

    var disablePopover: Bool = false
    @objc func togglePopover() {
        guard !disablePopover else { return }
        if(popover.isShown) {
            hidePopover()
        }
        else {
            NSApp.activate(ignoringOtherApps: true)
            showPopover()
        }
    }

    func showPopover() {
        if let statusBarButton = statusItem.button {
            popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
        }
    }

    func hidePopover() {
        popover.performClose(nil)
    }
}
