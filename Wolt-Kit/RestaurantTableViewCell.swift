//
//  RestaurantTableViewCell.swift
//  Wolt-Kit
//
//  Created by Tatiana Podlesnykh on 4.1.2021.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descript: UILabel!
    @IBOutlet weak var status: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        img.layer.cornerRadius = img.frame.width/3
        img.layer.borderWidth = 1.0
        img.layer.borderColor = UIColor.white.cgColor
        img.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
