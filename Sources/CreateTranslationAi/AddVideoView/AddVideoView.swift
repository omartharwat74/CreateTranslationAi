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
    @IBOutlet weak var videoView: UIView!{
        didSet{
            videoView.layer.cornerRadius = 25
            videoView.layer.borderWidth = 1
            videoView.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1).cgColor
        }
    }
    @IBOutlet weak var videoImage: UIImageView!{
        didSet{
            videoImage.layer.cornerRadius = 25
        }
    }
    
    
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
    }
    
    @objc func viewVideoTapped() {
        openGallery()
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
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        imagePicker.delegate = self
        if let parentVC = self.parentViewController {
            parentVC.present(imagePicker, animated: true)
        } else {
            print("Parent view controller not found")
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let mediaType = info[.mediaType] as? String else {
            return
        }

        if mediaType == kUTTypeMovie as String {
            if let videoURL = info[.mediaURL] as? URL {
                print("Video URL: \(videoURL)")
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
