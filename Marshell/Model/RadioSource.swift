//
//  RadioSource.swift
//  Marshell
//
//  Created by Edmund Feng on 2022/4/12.
//

import AppKit

struct RadioSource: Codable {
    private(set) var uuid: String = UUID().uuidString
    var url: String
    var title: String
    
    static let defualt: [RadioSource] =
    [
        RadioSource(url: "https://www.youtube.com/embed/oVi5gtzTDx0", title: "Nice Guy"),
//        RadioSource(url: "https://lofi.cafe", title: "Lofi Cafe"),
        RadioSource(url: "https://www.youtube.com/embed/6uddGul0oAc", title: "Jazz Bar"),
        RadioSource(url: "https://www.youtube.com/embed/5qap5aO4i9A", title: "Lofi HipHop"),
        RadioSource(url: "https://www.youtube.com/embed/9UMxZofMNbA", title: "Chill Out"),
        RadioSource(url: "https://www.youtube.com/embed/Dx5qFachd3A", title: "Jazz Piano"),
        RadioSource(url: "https://www.youtube.com/embed/DWcJFNfaw9c", title: "Lofi on Bed"),
        RadioSource(url: "https://www.youtube.com/embed/_fVjJmX2GYs", title: "Rick and Morty"),
    ]
    
    static var zero: RadioSource {
        RadioSource(url: "", title: "")
    }
}

class RadioSourceController {
    
    static let shared = RadioSourceController()
    
    var list: [RadioSource] {
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: "RadioSourceController.list")
        }
        get {
//            UserDefaults.standard.set(nil, forKey: "RadioSourceController.list")

            let data = (UserDefaults.standard.object(forKey: "RadioSourceController.list") as? Data) ?? Data()
            let resource = try? JSONDecoder().decode([RadioSource].self, from: data)
//            print("@____________________")
//            resource?.forEach({ source in
//                print("@", source.uuid, source.title, source.url)
//            })
            return resource ?? RadioSource.defualt
        }
    }
    
    
    
}
