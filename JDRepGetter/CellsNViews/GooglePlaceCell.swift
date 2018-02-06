//
//  GooglePlaceCell.swift
//  JDRepGetter
//
//  Created by jonathan thornburg on 2/4/18.
//  Copyright © 2018 jon-thornburg. All rights reserved.
//

import UIKit

class GooglePlaceCell: UITableViewCell {

    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var barColorView: UIView!
    @IBOutlet weak var starsImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpForEven(isLate: Bool) {
        if isLate {
            barColorView.backgroundColor = .clear
            starsImageView.backgroundColor = .clear
            contentView.backgroundColor = .red
        } else {
            barColorView.backgroundColor = .red
            if let image = UIImage(named: "rightStars") {
                starsImageView.image = image
            }
        }
    }
    
    func setUpForOdd(isLate: Bool) {
        if isLate {
            barColorView.backgroundColor = .clear
            starsImageView.backgroundColor = .clear
            contentView.backgroundColor = .white
        } else {
            barColorView.backgroundColor = .white
            if let image = UIImage(named: "leftStars") {
                starsImageView.image = image
            }
        }
    }
}
