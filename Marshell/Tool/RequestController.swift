//
//  RequestController.swift
//  Cloud Sticker
//
//  Created by Edmund Feng on 2021/5/12.
//

import StoreKit

class ReviewController {
    static var shared = ReviewController()

    private var usedTime: Int {
        get {
            (UserDefaults.standard.object(forKey: "usedTime") as? Int) ?? 0
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "usedTime")
        }
    }

    func checkForReviewRequest() {
        usedTime += 1
        if usedTime == 1 || usedTime == 5 || usedTime == 10 {
            SKStoreReviewController.requestReview()
        }
    }
}
