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
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var videoThumbnailImageView: UIImageView!
    @IBOutlet weak var playStopButton: UIButton!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var currentSecondLabel: UILabel!
    
    
    var selectedVideoURL: URL?
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var isPlaying = false
    var currentPlaybackTime: CMTime = CMTime.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupThumbnail()
        setupVideoDuration()
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
        if isPlaying {
            stopVideo()
        } else {
            playVideoInView()
        }
    }
    
    func setupThumbnail() {
        guard let videoURL = selectedVideoURL else {
            print("Video URL is not set")
            return
        }
        
        generateThumbnail(for: videoURL, at: CMTime(seconds: 0.0, preferredTimescale: 1))
    }
    
    func setupVideoDuration() {
        guard let videoURL = selectedVideoURL else {
            print("Video URL is not set")
            return
        }
        
        let asset = AVAsset(url: videoURL)
        let durationInSeconds = CMTimeGetSeconds(asset.duration)
        durationLabel.text = formatTime(durationInSeconds)
    }
    
    func generateThumbnail(for url: URL, at time: CMTime) {
        let asset = AVAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        do {
            let imageRef = try generator.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: imageRef)
            videoThumbnailImageView.image = thumbnail
        } catch let error {
            print("Error generating thumbnail: \(error)")
        }
    }
    
    func playVideoInView() {
        guard let videoURL = selectedVideoURL else {
            print("Video URL is not set")
            return
        }
        
        // Create an AVPlayer
        player = AVPlayer(url: videoURL)
        
        // Create an AVPlayerLayer
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = videoContainerView.bounds
        playerLayer?.videoGravity = .resizeAspect
        
        // Add the player layer to the container view
        if let playerLayer = playerLayer {
            videoContainerView.layer.addSublayer(playerLayer)
        }
        
        // Seek to the current playback time
        player?.seek(to: currentPlaybackTime, toleranceBefore: .zero, toleranceAfter: .zero)
        
        // Add time observer to update current playback time
        player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] time in
            self?.updateCurrentTimeLabel(time)
        }
        
        // Play the video
        player?.play()
        isPlaying = true
        playStopButton.setImage(SCImage(named: "video-pause"), for: .normal)
    }
    
    func stopVideo() {
        guard let player = player else { return }
        
        // Pause the video
        player.pause()
        
        // Get the current playback time
        currentPlaybackTime = player.currentTime()
        
        // Update the thumbnail to the current frame
        generateThumbnail(for: selectedVideoURL!, at: currentPlaybackTime)
        
        // Remove the player layer
        playerLayer?.removeFromSuperlayer()
        isPlaying = false
        playStopButton.setImage(SCImage(named:"video-play"), for: .normal)
    }
    
    func updateCurrentTimeLabel(_ time: CMTime) {
        let currentSeconds = CMTimeGetSeconds(time)
        currentSecondLabel.text = formatTime(currentSeconds)
    }
    
    func formatTime(_ seconds: Float64) -> String {
        let minutes = Int(seconds) / 60
        let seconds = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
