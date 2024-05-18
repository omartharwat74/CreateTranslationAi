//
//  TranslateCell.swift
//  
//
//  Created by Omar Tharwat on 18/05/2024.
//

import UIKit

class TranslateCell: UITableViewCell {

    @IBOutlet weak var translateTime: UILabel!
    @IBOutlet weak var translateFrom: UILabel!
    @IBOutlet weak var translateFromImage: UIImageView!
    @IBOutlet weak var translateTo: UILabel!
    @IBOutlet weak var translateToImage: UIImageView!
    @IBOutlet weak var editTextButton: UIButton!
    @IBOutlet weak var editView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
          super.layoutSubviews()
          let margins = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
          contentView.frame = contentView.frame.inset(by: margins)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func editClick(_ sender: Any) {
    }
    
}
