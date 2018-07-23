//
//  Champion.swift
//  swift_formation
//
//  Created by Guillaume Malo on 2018-07-19.
//  Copyright © 2018 Guillaume Malo. All rights reserved.
//

import Foundation
import UIKit

struct Champion: Codable {
    var name: String
    var title: String
    var lore: String
    var base64Image: String?
    var encodableId: String = ""
    
    var image: UIImage {
        get {
            guard let base64Image = base64Image else { return #imageLiteral(resourceName: "Mordekaiser") }
            let data = Data(base64Encoded: base64Image, options: .ignoreUnknownCharacters)
            if let data = data, let image = UIImage(data: data) {
                return image
            } else {
                return #imageLiteral(resourceName: "no-image")
            }
        }
        set {
            if let imageData = UIImagePNGRepresentation(newValue) {
                base64Image = imageData.base64EncodedString(options: .lineLength64Characters)
            } else {
                base64Image = nil
            }
        }
    }
    
    var id: UUID {
        get {
            if let id = UUID(uuidString: encodableId) {
                return id
            } else {
                return UUID()
            }
        }
        set {
            encodableId = newValue.description
        }
    }
    init(name: String, title: String, lore: String, image: String){
        self.name = name
        self.title = title
        self.lore = lore
        if let iconImage = UIImage(named: image){
            self.image = iconImage
        }
    }
    
    init?(json: [String: Any]) {
        guard let name = json["name"] as? String,
            let title = json["title"] as? String,
            let lore = json["lore"] as? String,
            let image = json["image"] as? String
            else {
                return nil
            }
        self.name = name
        self.title = title
        self.lore = lore
        if let iconImage = UIImage(named: image){
            self.image = iconImage
        }
    }
}
