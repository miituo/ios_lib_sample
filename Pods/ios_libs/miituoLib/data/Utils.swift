//
//  Utils.swift
//  miituoLib
//
//  Created by John Alexis Cristobal Jimenez  on 11/11/20.
//

import Foundation
import UIKit

func getDocumentsDirectory() -> URL {
    //let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

var seguidad = "Basic yTZ/1bWv6Mpi85ZDkwK4AvJVZH2zA6hcdk0BecEoP4upNOLi2hLM4fzzcPmmSe8UUI5EcJoT4dySqIStZaqvCnlo4dLCASmhjZInXhRlcdc="


func showmessage(message: String, controller: UIViewController){
    let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    controller.present(alert, animated: true, completion: nil)
}

func createAlertMessageOrange(title : String, message : String, preferredStyle: UIAlertController.Style) -> UIAlertController {
    let alert = UIAlertController.init(title: title, message: message, preferredStyle: preferredStyle)
    return alert
}

func createAlertMessage(title : String, message : String, controller: UIViewController) {
    let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)    
    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    controller.present(alert, animated: true, completion: nil)
}

func getNombreMes(nombre: String) -> String {
    if nombre == "ene" || nombre == "Jan" || nombre == "jan" || nombre == "Ene"{
        return "ene"
    }else if nombre == "feb" || nombre == "Feb"{
        return "feb"
    }else if nombre == "mar" || nombre == "Mar"{
        return "mar"
    }else if nombre == "abr" || nombre == "apr" || nombre == "Apr"{
        return "abr"
    }else if nombre == "may" || nombre == "May"{
        return "may"
    }else if nombre == "jun" || nombre == "Jun"{
        return "jun"
    }else if nombre == "jul" || nombre == "Jul"{
        return "jul"
    }else if nombre == "ago" || nombre == "aug" || nombre == "Aug" || nombre == "Ago"{
        return "ago"
    }else if nombre == "sep" || nombre == "Sep"{
        return "sept"
    }else if nombre == "oct" || nombre == "Oct"{
        return "oct"
    }else if nombre == "nov" || nombre == "Nov"{
        return "nov"
    }else if nombre == "dic" || nombre == "dec" || nombre == "Dic" || nombre == "Dec"{
        return "dic"
    }else{
        return nombre
    }
}

func animateImage(image: UIImageView) {
    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {

        image.alpha = 1
        image.bounds.size.width += 60.0
        image.bounds.size.height += 60.0
        
    }) { _ in

        //self.derechoCompImage.alpha = 0
        //self.derechoCircularProgress.isHidden = true
        //self.derechopic.alpha = 1.0
    }
}
