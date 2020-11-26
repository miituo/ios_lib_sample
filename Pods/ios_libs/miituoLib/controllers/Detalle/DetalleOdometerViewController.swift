//
//  DetalleOdometerViewController.swift
//  miituoLib
//
//  Created by MACBOOK on 16/11/20.
//

import UIKit
class DetalleOdometerViewController: UIViewController {

    @IBOutlet weak var imagencarro: UIImageView!
    @IBOutlet weak var polizalabel: UILabel!

    @IBOutlet var fecha: UILabel!
    @IBOutlet var fechaabajo: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let selectedItem = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        self.tabBarController?.tabBar.items![0].setTitleTextAttributes(selectedItem, for: .selected)
        self.tabBarController?.tabBar.items![1].setTitleTextAttributes(selectedItem, for: .selected)

        // Do any additional setup after loading the view.
        let dateString = arregloPolizas[Int(valueToPass)!]["limitefecha"]! as String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        
        let dateaux = dateFormatter.date(from: dateString)
        let date = Calendar.current.date(byAdding: .day, value: -1, to: dateaux!)

        //get name month
        let dateFormattermes = DateFormatter()
        dateFormattermes.dateFormat = "MMM"
        let nameOfMonthcinco = dateFormattermes.string(from: date!)
        let valmes = getNombreMes(nombre: nameOfMonthcinco)
        dateFormattermes.dateFormat = "dd"
        let valdia = dateFormattermes.string(from: date!)
        dateFormattermes.dateFormat = "yyyy"
        _ = dateFormattermes.string(from: date!)
        fechaabajo.text = "al \(valdia) de \(valmes)"
        
        let tomorrow = Calendar.current.date(byAdding: .day, value: -4, to: dateaux!)
        dateFormattermes.dateFormat = "MMM"
        let nameOfMonthantes = dateFormattermes.string(from: tomorrow!)
        let valmesb = getNombreMes(nombre: nameOfMonthantes)
        dateFormattermes.dateFormat = "dd"
        let valdiab = dateFormattermes.string(from: tomorrow!)
        dateFormattermes.dateFormat = "yyyy"
        _ = dateFormattermes.string(from: date!)
        fecha.text = "del \(valdiab) de \(valmesb)"
        
        polizalabel.text = arregloPolizas[Int(valueToPass)!]["nopoliza"]!

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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
