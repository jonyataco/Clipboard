//
//  Clips.swift
//  Clipboard
//
//  Created by Jonathan Yataco  on 5/24/20.
//  Copyright © 2020 JonYataco. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Clip: NSManagedObject {

    // class method that creates a Clip.
    // If no favicon is given, it uses the default asset.
    class func createClip(title: String, link: String, favicon: Data? = UIImage(named: "default_favicon")?.pngData()) -> Clip {
        let clip = Clip(context: AppDelegate.persistantContainer.viewContext)
        clip.title = title
        clip.link = link
        clip.favicon = favicon
        return clip
    }
}
