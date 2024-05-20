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
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainView.layer.shadowColor = UIColor(red: 0.341, green: 0.584, blue: 0.58, alpha: 0.15).cgColor
        mainView.layer.shadowOpacity = 1
        mainView.layer.shadowRadius = 15
        mainView.layer.shadowOffset = CGSize(width: 0, height: 0)
        mainView.layer.cornerRadius = 15
        editView.layer.cornerRadius = 6
        mainView.layer.borderWidth = 0.5
//        mainView.backgroundColor = UIColor(red: 0.208, green: 0.22, blue: 0.247, alpha: 0.15)
        mainView.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1).cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func activeBorder(){
        mainView.backgroundColor = .clear
        mainView.layer.borderColor = UIColor(red: 0.341, green: 0.584, blue: 0.58, alpha: 1).cgColor
        editView.backgroundColor = UIColor(red: 0.208, green: 0.22, blue: 0.247, alpha: 1)
    }
    
    @IBAction func editClick(_ sender: Any) {
    }
    
}
