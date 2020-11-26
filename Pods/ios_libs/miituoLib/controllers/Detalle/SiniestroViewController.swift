//
//  SiniestroViewController.swift
//  miituoLib
//
//  Created by MACBOOK on 16/11/20.
//

import UIKit

class SiniestroViewController: UIViewController {

    @IBOutlet weak var imagencarro: UIImageView!
    @IBOutlet weak var polizalabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let selectedItem = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        self.tabBarController?.tabBar.items![0].setTitleTextAttributes(selectedItem, for: .selected)
        self.tabBarController?.tabBar.items![1].setTitleTextAttributes(selectedItem, for: .selected)

        polizalabel.text = arregloPolizas[Int(valueToPass)!]["nopoliza"]!

        // Do any additional setup after loading the view.
        let pliza = arregloPolizas[Int(valueToPass)!]["idpoliza"]! as String
        let pathfoto = "\(pathPhotos)\(pliza)/FROM_VEHICLE.png"

        imagencarro.downloaded(from: pathfoto)
        imagencarro.layer.masksToBounds = false
        imagencarro.layer.cornerRadius = imagencarro.frame.height / 2
        imagencarro.clipsToBounds = true

        //imagencarro.sd_setImage(with: URL(string: pathfoto), placeholderImage: UIImage(named: "vista_auto_2"))
    }
    
    @IBAction func verPdf(_ sender: Any) {
        tipopdf = "poliza"
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerPdfViewController") as! VerPdfViewController
        //vc?.modalTransitionStyle = .partialCurl
        //vc.isHeroEnabled = true
        //vc?.heroModalAnimationType = .slide(direction: .left)
        //vc.heroModalAnimationType = .selectBy(presenting: .slide(direction: .left), dismissing: .slide(direction: .right))
        
        //vc?.heroModalAnimationType = .zoomSlide(direction: .left)
        //vc?.heroModalAnimationType = .pageIn(direction: .left)
        //vc.cadenas = valueToPass
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func makeCall(_ sender: Any) {
        
        guard let url = URL(string: "telprompt://8008493917") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
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

