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
        updateStatusBar()
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    //MARK: - statusBar Item
    private var statusBarButton: StatusBarController?

    var statusItem: NSStatusItem?

    
    func updateStatusBar() {
        
        statusBarButton?.show()
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
        
    }
}


class StatusBarController {
    var statusItem: NSStatusItem
    
    private var popover: NSPopover

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

    @objc func togglePopover() {
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
