//
//  EditTranslateVC.swift
//
//
//  Created by Omar Tharwat on 15/05/2024.
//

import UIKit
import AVKit
import AVFoundation

class EditTranslateVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var projectName: UILabel!{
        didSet{
            projectName.text = "Project Name".localized
        }
    }
    
    @IBOutlet weak var backButton: UIButton!{
        didSet{
            if Locale.current.language.languageCode!.identifier == "en" {
                backButton.setImage( UIImage(systemName: "arrow.right"), for: .normal)
            }else if Locale.current.language.languageCode!.identifier == "ar" {
                backButton.setImage( UIImage(systemName: "arrow.lest"), for: .normal)
            }
        }
    }
    @IBOutlet weak var saveButton: UIButton!{
        didSet{
            saveButton.setTitle("save".localized, for: .normal)
        }
    }
    @IBOutlet weak var videoView: UIView!{
        didSet{
            videoView.layer.cornerRadius = 15
            videoView.layer.borderWidth = 0.5
            videoView.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1).cgColor
        }
    }
    
    var selectedVideoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    public init() {
        super.init(nibName: "EditTranslateVC", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func backClick(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func saveClick(_ sender: Any) {
        print("save")
    }
    
    @IBAction func playVideoButtonTapped(_ sender: Any) {
        playVideo()
    }
    
    func playVideo() {
        guard let videoURL = selectedVideoURL else {
            print("Video URL is not set")
            return
        }
        
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        present(playerViewController, animated: true) {
            player.play()
        }
    }
}
