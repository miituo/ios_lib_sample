//
//  buttonExtension.swift
//  miituo
//
//  Created by John Alexis Cristobal Jimenez  on 19/05/21.
//  Copyright © 2021 John A. Cristobal. All rights reserved.
//

import Foundation
import UIKit

class loadingButton : UIButton{
    
    var loading : UIActivityIndicatorView?
    var originalText = ""
    
    func buttonOff(){
        originalText = self.titleLabel?.text ?? ""
        self.isEnabled = false
        self.setTitle("", for: .disabled)
        showLoading()
    }
    
    func buttonOn(){
        if (loading == nil) {
            self.loading = createActivityIndicator()
        }
        guard let indicator = self.loading else {
            return
        }

        indicator.stopAnimating()
        self.isEnabled = true
        self.setTitle(originalText, for: .normal)
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        return activityIndicator
    }
    
    func showLoading(){
        if (loading == nil) {
            self.loading = createActivityIndicator()
        }
        guard let indicator = self.loading else {
            return
        }
        indicator.hidesWhenStopped = true
        indicator.color = UIColor.white
        indicator.style = .whiteLarge
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(indicator)
        
        let centerXC = NSLayoutConstraint(item: indicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: .equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        self.addConstraint(centerXC)
        
        let centerYC = NSLayoutConstraint(item: indicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: .equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        self.addConstraint(centerYC)
        
        indicator.startAnimating()
    }
    
}
