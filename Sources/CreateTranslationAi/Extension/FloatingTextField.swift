//
//  FloatingTextField.swift
//
//  Created by MGAbouarab®.
//

import UIKit

class MGFloatingTextField: UITextField {
    
    enum Direction {
        case rtl
        case ltr
    }
    
    
    //MARK: - Properties -
    var isPassword = true
    var selectedBorderColor: UIColor =  UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
    var normalBorderColor =  UIColor(red: 1, green: 1, blue: 1, alpha: 0.1).cgColor
    lazy var padding = (self.direction == .ltr) ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) : UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var placeholderView: UIView?
    private var tempPlaceholder: String?
    private weak var timer: Timer?
    private var direction : Direction = .ltr
    
    @IBInspectable var leadingNormalImage : UIImage? = nil {
        didSet{
            self.setLeading(leadingNormalImage, imageWidth: 30, padding: 15)
        }
    }
    
    
    let secureButton = UIButton()
    var errorMessageLabel: UILabel?
    
    
    //MARK:- Overriden Properities -
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    //MARK:- Overriden Methods -
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialConfiguration()
    }
    
    
    //MARK:- Design Methods -
    private func initialConfiguration() {
        self.delegate = self
        self.layer.cornerRadius = 24
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1).cgColor
        self.backgroundColor = .clear
        self.borderStyle = .none
        self.attributedPlaceholder = NSAttributedString(
            string: self.placeholder ?? "please choose language".localized,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
    }
    
}
extension MGFloatingTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        guard textField.text?.isEmpty == true else {return}
        self.timer?.invalidate()
        self.layer.borderColor = self.selectedBorderColor.cgColor
        //        self.createLabelView()
        self.tempPlaceholder = self.placeholder
        self.placeholder = nil
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField.text?.isEmpty == true else {
            self.placeholder = self.tempPlaceholder
            return
        }
        self.layer.borderColor = self.normalBorderColor
        UIView.transition(with: self.superview!, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.placeholderView?.removeFromSuperview()
            self.errorMessageLabel?.removeFromSuperview()
        }, completion: nil)
        self.placeholder = self.tempPlaceholder
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            self.placeholder = nil
        }
    }
}
extension MGFloatingTextField {
    func setLeading(_ image: UIImage?, imageWidth: CGFloat, padding: CGFloat) {
        secureButton.setTitle(nil, for: .normal)
        secureButton.setImage(image, for: .normal)
        secureButton.imageView?.contentMode = .scaleAspectFit
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: imageWidth + 2 * padding, height: frame.height))
        containerView.addSubview(secureButton)
        secureButton.frame = containerView.frame
        leftView = containerView
        leftViewMode = .always
        self.padding = (self.direction == .rtl) ? UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 50) : UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 15)
    }
}


protocol DropDownItem {
    var id: String? { get }
    var name: String { get }
    var image: String { get }
}
protocol DropDownTextFieldDelegate {
    func dropDownList(for textField: UITextField) -> [DropDownItem]
    func didSelect(item: DropDownItem, for textField: UITextField)
    
}

class DropDownTextField: MGFloatingTextField {
    
    //MARK: - Properties -
    private lazy var picker = UIPickerView()
    var items: [DropDownItem] = []
    var selectedItem: DropDownItem?
    var dropDownDelegate: DropDownTextFieldDelegate?
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) || action == #selector(UIResponderStandardEditActions.cut(_:)) || action == #selector(UIResponderStandardEditActions.delete(_:)) || action == #selector(UIResponderStandardEditActions.select(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    private lazy var selectedImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: self.frame.height))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //MARK: - Lifecycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupDesign()
        self.addSelectedImageView()
    }
    
    private func addSelectedImageView() {
        self.selectedImageView.image = nil
        self.rightView = self.selectedImageView
        self.rightViewMode = .always
    }
    
    private func updateSelectedImage() {
        // Set a static image for testing
        self.selectedImageView.image = SCImage(named: "a")
    }

//    private func updateSelectedImage() {
//        guard let selectedItem = self.selectedItem else {
//            self.selectedImageView.image = nil
//            return
//        }
//        self.selectedImageView.image = SCImage(named: selectedItem.image)
//    }
    

    
    private func setupDesign() {
        self.picker.delegate = self
        self.inputView = picker
        self.inputView?.clipsToBounds = true
        tintColor = UIColor.white
        self.addDoneButtonOnKeyboard()
    }
    
    
    private func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        doneToolbar.tintColor = UIColor.white
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done".localized, style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        guard let selectedItem = self.selectedItem else {
            if let item = self.items.first {
                self.text = item.name
                self.dropDownDelegate?.didSelect(item: item, for: self)
            }
            self.resignFirstResponder()
            return
        }
        self.text = selectedItem.name
        self.dropDownDelegate?.didSelect(item: selectedItem, for: self)
        self.resignFirstResponder()
    }
    
}
extension DropDownTextField: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.items = self.dropDownDelegate?.dropDownList(for: self) ?? []
        return self.items.count
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerViewWidth = pickerView.frame.width
        let rowView = UIView(frame: CGRect(x: 0, y: 0, width: pickerViewWidth, height: 40))
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: pickerViewWidth - 60, height: 40))
        label.text = self.items[row].name
        label.textAlignment = .right
        label.textColor = UIColor(red: 0.09, green: 0.09, blue: 0.09, alpha: 1)
        rowView.addSubview(label)
        
        let imageView = UIImageView(frame: CGRect(x: pickerViewWidth - 40, y: 5, width: 30, height: 30))
        imageView.image = SCImage(named: self.items[row].image)
        imageView.contentMode = .scaleAspectFit
        rowView.addSubview(imageView)
        
        return rowView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row < self.items.count else {return}
        self.selectedItem = self.items[row]
        self.updateSelectedImage()
    }
}
