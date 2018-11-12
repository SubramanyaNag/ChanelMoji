//
//  SearchResultTableViewCell.swift
//  ChanelEmoji
//
//  Created by subramanya on 23/06/18.
//  Copyright © 2018 Subramanya. All rights reserved.
//

import Foundation
import UIKit

class SearchResultsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    func configureCell(result: SearchResults) {
            self.searchImage.image = result.image!
            self.nameLabel.text = result.name!
            self.colorLabel.text = result.color!
            self.typeLabel.text = result.type!
    }
}
