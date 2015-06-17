//
//  MovieViewCell.swift
//  kevin563-Week1
//
//  Created by Kevin Chang on 2015/6/13.
//  Copyright (c) 2015年 Kevin Chang. All rights reserved.
//

import UIKit

class MovieViewCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var synosis: UILabel!
    @IBOutlet var poster: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.poster.image = nil
    }
}
