//
//  viewController+extension.swift
//  miituoLib
//
//  Created by MACBOOK on 14/11/20.
//

import Foundation
import UIKit

class GenericViewController: UIViewController {

    var activeField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
    }
 
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboardOnTap() {
        self.view.endEditing(true)
        if (self.activeField != nil) {
            self.activeField = nil
        }
    }
}

// MARK: UITextFieldDelegate
extension GenericViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        guard let scrollView = self.superScrollView else {
//            return true
//        }
        
        activeField = textField
//        lastOffset = scrollView.contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        return true
    }
}

extension UIViewController {
    func hideKeyboardOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
}
