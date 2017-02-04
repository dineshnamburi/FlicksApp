//
//  MovieCell.swift
//  FlicksApp
//
//  Created by dinesh on 03/02/17.
//  Copyright © 2017 dinesh. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var movieLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
