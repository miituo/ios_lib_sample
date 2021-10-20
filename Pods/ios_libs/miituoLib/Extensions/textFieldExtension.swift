//
//  textFieldExtension.swift
//  miituo
//
//  Created by John Alexis Cristobal Jimenez  on 08/04/21.
//  Copyright © 2021 John A. Cristobal. All rights reserved.
//

import Foundation
import UIKit

class customTextField: UITextField {
    
    let label = UILabel()
    let placeholderLabel = UILabel()

    var error = false
    var placeholderFlag = false
    
    var horizontalConstraint:NSLayoutConstraint?
    var verticalConstraint:NSLayoutConstraint?
    var leadingConstraint:NSLayoutConstraint?
    var widthConstraint:NSLayoutConstraint?
    var heightConstraint :NSLayoutConstraint?
    
    var horizontalConstraintplaceholder:NSLayoutConstraint?
    var verticalConstraintplaceholder:NSLayoutConstraint?
    var leadingConstraintplaceholder:NSLayoutConstraint?
    var widthConstraintplaceholder:NSLayoutConstraint?
    var heightConstraintplaceholder:NSLayoutConstraint?

    var horizontalConstraintplaceholderShow:NSLayoutConstraint?
    var verticalConstraintplaceholderShow:NSLayoutConstraint?
    var leadingConstraintplaceholderShow:NSLayoutConstraint?
    var widthConstraintplaceholderShow:NSLayoutConstraint?
    var heightConstraintplaceholderShow:NSLayoutConstraint?

    var horizontalConstraintError:NSLayoutConstraint?
    var verticalConstraintError:NSLayoutConstraint?
    var leadingConstraintError:NSLayoutConstraint?
    var widthConstraintError:NSLayoutConstraint?
    var heightConstraintError:NSLayoutConstraint?
    
    var view: UIView?
    var placeholderText: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(view: UIView, placeT: String){
        self.view = view
        self.placeholderText = placeT
        
        self.delegate = self
        
        label.font = UIFont.systemFont(ofSize: 12.0)// (name: "System", size: 10.0)
        label.textColor = UIColor.red
        self.label.alpha = 0.0

        placeholderLabel.text = placeholderText ?? ""
        placeholderLabel.font = UIFont.systemFont(ofSize: 12.0)
        placeholderLabel.textColor = UIColor.lightGray
        self.placeholderLabel.alpha = 0.0

        self.view!.addSubview(label)
        self.view!.addSubview(placeholderLabel)

        label.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // constraints to placeholderLabel
        horizontalConstraintplaceholder = NSLayoutConstraint(item: placeholderLabel, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: -8)
        leadingConstraintplaceholder = NSLayoutConstraint(item: placeholderLabel, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        widthConstraintplaceholder = NSLayoutConstraint(item: placeholderLabel, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.frame.width)
        heightConstraintplaceholder = NSLayoutConstraint(item: placeholderLabel, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.frame.height)
        
        // constraints to labelError
        horizontalConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        leadingConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        widthConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.frame.width)
        heightConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.frame.height)
            
        // this constraints are to move
        horizontalConstraintError = NSLayoutConstraint(item: label, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        horizontalConstraintplaceholderShow = NSLayoutConstraint(item: placeholderLabel, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)

        
        self.view!.addConstraints([
            //error
            horizontalConstraint!,
            leadingConstraint!,
            widthConstraint!,
            heightConstraint!,
            // placeholder
            horizontalConstraintplaceholder!,
            leadingConstraintplaceholder!,
            widthConstraintplaceholder!,
            heightConstraintplaceholder!,
        ])
        
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view!.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:.flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector((doneButtonAction)))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
        underlined()
        
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
    }
    
    @objc final private func textFieldDidChange(textField: UITextField){

        if textField.text?.count != 0 && !placeholderFlag{
            placeholderFlag = true
            showplaceHolderLabel()
        }
        
        if textField.text?.count == 0 {
            placeholderFlag = false
            hideplaceholderLabel()
        }
    }
    
    @objc func doneButtonAction() {
        self.view!.endEditing(true)
    }
    
    func hideErrorLabel(){
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
            
            self.view!.layoutIfNeeded()
            self.label.alpha = 0.0
            
        } completion: { (set) in
            self.view!.removeConstraints([self.horizontalConstraintError!])
            self.view!.addConstraints([self.horizontalConstraint!])
        }
    }
    
    func hideplaceholderLabel(){
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
            
            self.view!.layoutIfNeeded()
            self.placeholderLabel.alpha = 0

        } completion: { (set) in
            self.view!.removeConstraints([self.horizontalConstraintplaceholderShow!])
            self.view!.addConstraints([self.horizontalConstraintplaceholder!])
        }
    }
    
    func showplaceHolderLabel(){
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
            
            print(self.placeholderLabel.frame.origin.y)
            print(self.frame.height)
            
            self.view!.layoutIfNeeded()
            self.placeholderLabel.alpha = 1.0
            self.view!.removeConstraints([self.horizontalConstraintplaceholder!])
            self.view!.addConstraints([self.horizontalConstraintplaceholderShow!])
            
        } completion: { (set) in
            print("Set animation")
        }
    }
    
    func showError(errorT: String){
        label.text = errorT
        
        if !error{
            error = true
                        
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                
                self.view!.layoutIfNeeded()
                self.label.alpha = 1.0
                self.view!.removeConstraints([self.horizontalConstraint!])
                self.view!.addConstraints([self.horizontalConstraintError!])

            } completion: { (set) in
                print("Set animation")
            }
        }
    }
}

extension customTextField: UITextFieldDelegate{
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        error = false
        hideErrorLabel()

        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 10
        //return true
    }
}

extension UITextField {
    func underlined(){
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
