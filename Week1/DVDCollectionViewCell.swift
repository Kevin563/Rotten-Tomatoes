//
//  DVDDetailsCollectionViewCell.swift
//  Week1
//
//  Created by Kevin Chang on 2015/6/17.
//  Copyright (c) 2015年 Kevin Chang. All rights reserved.
//

import UIKit

class DVDCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var poster: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var ratings_critics_score: UILabel!
    @IBOutlet var ratings_audience_score: UILabel!
    @IBOutlet var mapp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.poster.image = nil
    }
}
