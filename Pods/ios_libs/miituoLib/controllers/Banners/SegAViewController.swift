//
//  SegAViewController.swift
//  miituoLib
//
//  Created by MACBOOK on 10/11/20.
//

import UIKit
//import Toast_Swift

class SegAViewController: UIViewController {

    @IBOutlet var cuponText: UILabel!
    @IBOutlet var buttonTapped: UIImageView!
    @IBOutlet weak var kmsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    let sendCuponReferido = Notification.Name("sendCuponReferido")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        buttonTapped.isUserInteractionEnabled = true
        buttonTapped.addGestureRecognizer(tapGestureRecognizer)
        
        var palabra = ""
        cuponInfo.forEach{ item in
            palabra += "\(item) "
        }
        
        cuponText.text = palabra
     
        NotificationCenter.default.addObserver(self, selector: #selector(getCuponUpdate), name: sendCuponReferido, object: nil)
        
    }
    
    @objc func getCuponUpdate(){
        let attributedString = NSMutableAttributedString(string: "\(kmsCuponReferido) km")
        attributedString.addAttribute(.kern,value: -3.0,range: NSRange(location: 0, length: attributedString.length - 1))
        self.kmsLabel.attributedText = attributedString
        
        //self.kmsLabel.text = "\(kmsCuponReferido) km"
        self.descriptionLabel.text = descriptipnCuponReferido
        
        var palabra = ""
        cuponInfo.forEach{ item in
            palabra += "\(item) "
        }
        
        cuponText.text = palabra
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        
        UIPasteboard.general.string = cuponInfo // or use  sender.titleLabel.text
        showmessage(message: "Cupón copiado al portapapeles.", controller: self)
        //self.view.makeToast("Cupón copiado.",duration:2.0,position:.center)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
