//
//  SearchCell.swift
//  WhatToWatch
//
//  Created by Fran on 04/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    
    func configWitItem(_ item: Item) {
        self.selectionStyle = .none
        self.titleLbl.text = item.title
        self.descriptionLbl.text = item.overview
        self.dateLbl.text = item.releaseDate
        if let image = item.posterImage {
            thumbnailView.image = image
        } else {
            thumbnailView.image = UIImage(named: "empty_poster")
        }
    }
}
