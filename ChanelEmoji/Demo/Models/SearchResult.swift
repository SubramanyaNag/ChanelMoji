//
//  SearchResult.swift
//  ChanelEmoji
//
//  Created by subramanya on 23/06/18.
//  Copyright © 2018 Subramanya. All rights reserved.
//

import Foundation
import UIKit

public class SearchResults {
    let name: String?
    let type: String?
    let image: UIImage?
    let color: String?
    
    public init(name: String, type: String, image: UIImage, color: String) {
        self.name = name
        self.type = type
        self.image = image
        self.color = color
    }
}
