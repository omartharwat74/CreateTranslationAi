//
//  TranslateCell.swift
//  
//
//  Created by Omar Tharwat on 18/05/2024.
//

import UIKit

class TranslateCell: UITableViewCell {

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var translateFromLabel: UILabel!
    @IBOutlet weak var countryFromImage: UIImageView!
    @IBOutlet weak var translateToLabel: UILabel!
    @IBOutlet weak var countryToImage: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var editView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func editClick(_ sender: Any) {
    }
    
}
