//
//  AddVideoView.swift
//
//
//  Created by Omar Tharwat on 10/05/2024.
//

import UIKit
import MobileCoreServices
import Photos

class AddVideoView: UIView {
    
    //MARK: - Outlets
    @IBOutlet weak var projectName: UILabel!{
        didSet{
            projectName.text = "Project Name".localized
        }
    }
    @IBOutlet weak var extractVideo: UILabel!{
        didSet{
            extractVideo.text = "Select the video from your files".localized
        }
    }
    @IBOutlet weak var chooseVideo: UILabel!{
        didSet{
            chooseVideo.text = "Choose the video".localized
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
    @IBOutlet weak var translateButton: UIButton!{
        didSet{
            translateButton.layer.cornerRadius = 24
            translateButton.configurationUpdateHandler = { button in
                var config = button.configuration
                config?.attributedTitle = AttributedString(NSLocalizedString("Get your translation".localized, comment: ""),
                                                           attributes: AttributeContainer([NSAttributedString.Key.foregroundColor: button.isEnabled ? UIColor.white : UIColor(red: 0.775, green: 0.775, blue: 0.775, alpha: 1)]))
                button.configuration = config
            }
            translateButton.configuration?.imagePadding = 10
            if Locale.current.language.languageCode!.identifier == "en" {
                translateButton.semanticContentAttribute = .forceLeftToRight
            }else if Locale.current.language.languageCode!.identifier == "ar" {
                translateButton.semanticContentAttribute = .forceRightToLeft
            }
            
        }
    }
    @IBOutlet weak var uploadStackView: UIStackView!
    @IBOutlet weak var videoView: RectangularDashedView!{
        didSet{
            videoView.layer.cornerRadius = 25
        }
    }
    @IBOutlet weak var videoImage: UIImageView!{
        didSet{
            videoImage.layer.cornerRadius = 25
        }
    }
    @IBOutlet weak var translateView: UIView!{
        didSet{
            translateView.layer.cornerRadius = 25
            translateView.layer.borderWidth = 1
            translateView.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1).cgColor
        }
    }
    @IBOutlet weak var translateFromLabel: UILabel!{
        didSet{
            translateFromLabel.text = "Add spoken language in video:".localized
        }
    }
    @IBOutlet weak var translateToLabel: UILabel!{
        didSet{
            translateToLabel.text = "Translate to:".localized
        }
    }
    @IBOutlet weak var translateFromTF: DropDownTextField!
    @IBOutlet weak var translateToTF: DropDownTextField!
    @IBOutlet weak var removeVideoButton: UIButton!
    @IBOutlet weak var videoName: UILabel!{
        didSet{
            videoName.font = UIFont(name: "DINNextLTArabic-Regular", size: 16)
        }
    }
    @IBOutlet weak var videoDuration: UILabel!{
        didSet{
            videoDuration.font = UIFont(name: "DINNextLTArabic-Regular", size: 13)
        }
    }
    
    
    let languageItems: [LanguageModel] = [
        LanguageModel(id: "1" ,name: "العربيه" , image: "a"),
        LanguageModel(id: "2" ,name: "الانجليزيه", image: "e"),
        LanguageModel(id: "3" ,name: "الاسبانيه" , image: "e"),
    ]
    
    var video: UIImage? = nil
    var selectedVideoURL: URL?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        configuration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        configuration()
    }
    
    private func commonInit() {
        let bundle = Bundle.module
        let nib = UINib(nibName: "AddVideoView", bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            addSubview(view)
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    
    func configuration(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewVideoTapped))
        uploadStackView.addGestureRecognizer(tapGesture)
        uploadStackView.isUserInteractionEnabled = true
        translateFromTF.dropDownDelegate = self
        translateToTF.dropDownDelegate = self
        removeVideoButton.isHidden = true
        videoName.isHidden = true
        videoDuration.isHidden = true
        videoView.showDashBorder()
        translateFromTF.attributedPlaceholder = NSAttributedString(
            string: languageItems[1].name,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        translateFromTF.selectedImageView.image = SCImage(named: languageItems[1].image)
        translateFromTF.selectedItem = languageItems[1]
        translateToTF.attributedPlaceholder = NSAttributedString(
            string: languageItems[0].name,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        translateToTF.selectedImageView.image = SCImage(named: languageItems[0].image)
        translateToTF.selectedItem = languageItems[0]
    }
    
    @objc func viewVideoTapped() {
        openGallery()
    }
    @IBAction func removeVideoClick(_ sender: Any) {
        removeVideoButton.isHidden = true
        uploadStackView.isHidden = false
        videoImage.image = nil
        video = nil
        translateButton.isEnabled = false
        videoName.isHidden = true
        videoDuration.isHidden = true
        videoView.showDashBorder()
        translateButton.backgroundColor = UIColor(red: 0.166, green: 0.271, blue: 0.269, alpha: 1)
    }
    @IBAction func translateClick(_ sender: Any) {
        if let parentVC = self.parentViewController {
            let destinationView = EditTranslateVC()
            destinationView.selectedVideoURL = selectedVideoURL
            destinationView.modalPresentationStyle = .fullScreen
            parentVC.present(destinationView, animated: true)
        }
    }
    
}

extension AddVideoView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openGallery() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            showImagePicker()
        case .denied, .restricted:
            print("Permission denied for accessing photo library.")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                guard let self = self else { return }
                if status == .authorized {
                    self.showImagePicker()
                } else {
                    print("Permission denied for accessing photo library.")
                }
            }
        @unknown default:
            fatalError("Unhandled case.")
        }
    }
    
    func showImagePicker() {
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = [UTType.movie.identifier]
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            if let parentVC = self.parentViewController {
                parentVC.present(imagePicker, animated: true)
            } else {
                print("Parent view controller not found")
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let mediaType = info[.mediaType] as? String else {
            return
        }
        
        if mediaType == UTType.movie.identifier {
            if let videoURL = info[.mediaURL] as? URL {
                print("Video URL: \(videoURL)")
                selectedVideoURL = videoURL
                
                // Get video asset
                let asset = AVAsset(url: videoURL)
                let generator = AVAssetImageGenerator(asset: asset)
                generator.appliesPreferredTrackTransform = true
                
                // Get video duration
                let durationInSeconds = CMTimeGetSeconds(asset.duration)
                let videoDurationString = formatTime(durationInSeconds)
                videoDuration.text = "Duration: \(videoDurationString)"
                
                // Get video name
                let videoNameString = videoURL.lastPathComponent
                videoName.text = "\(videoNameString).mp4"
                
                // Generate thumbnail
                let time = CMTime(seconds: 0.0, preferredTimescale: 1)
                do {
                    let imageRef = try generator.copyCGImage(at: time, actualTime: nil)
                    let thumbnail = UIImage(cgImage: imageRef)
                    videoImage.image = thumbnail
                    uploadStackView.isHidden = true
                    removeVideoButton.isHidden = false
                    video = thumbnail
                    videoView.hideDashBorder()
                    translateButton.backgroundColor = UIColor(red: 0.341, green: 0.584, blue: 0.58, alpha: 1)
                    translateButton.isEnabled = true
                    videoName.isHidden = false
                    videoDuration.isHidden = false
                } catch let error {
                    print("Error generating thumbnail: \(error)")
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func formatTime(_ seconds: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter.string(from: TimeInterval(seconds)) ?? "00:00"
    }
}

extension AddVideoView : DropDownTextFieldDelegate  {
    func dropDownList(for textField: UITextField) -> [any DropDownItem] {
        return languageItems
    }
    
    func didSelect(item: any DropDownItem, for textField: UITextField) {
        print("select\(item)")
    }
}


