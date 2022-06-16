//
//  PerfilViewController.swift
//  miituoLib
//
//  Created by MACBOOK on 16/11/20.
//

import UIKit

class PerfilViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var vistaEstado: UIView!
    @IBOutlet var formPagoView: UIView!

    @IBOutlet weak var imagencarro: UIImageView!
    @IBOutlet weak var polizalabel: UILabel!
    
    @IBOutlet var middleLabel: UILabel!
    
    @IBOutlet var conductorName: UILabel!
    @IBOutlet var conductorCel: UILabel!
    @IBOutlet var contraName: UILabel!
    @IBOutlet var contraCel: UILabel!
    
    @IBOutlet var autoDes: UILabel!

    @IBOutlet var placas: UILabel!
    @IBOutlet var modelo: UILabel!

    @IBOutlet var ultimoreporte: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let selectedItem = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        self.tabBarController?.tabBar.items![0].setTitleTextAttributes(selectedItem, for: .selected)
        self.tabBarController?.tabBar.items![1].setTitleTextAttributes(selectedItem, for: .selected)

        //carrolabel.text = arreglocarro[Int(valueToPass)!]["descripcion"] as! String
        autoDes.text = arreglocarro[Int(valueToPass)!]["descripcion"]!
        polizalabel.text = arregloPolizas[Int(valueToPass)!]["nopoliza"]!

        _ = arregloPolizas[Int(valueToPass)!]["rate"]
//        var tarifaShow = ""
//        if let datotemp = taifa{
//            tarifaShow = datotemp
//        }
        
        //placaslabel.text = ""
        placas.text = arreglocarro[Int(valueToPass)!]["plates"]!
        modelo.text = arreglocarro[Int(valueToPass)!]["model"]!
        
        conductorName.text = arreglo[Int(valueToPass)!]["name"]!
        conductorCel.text = arreglo[Int(valueToPass)!]["celphone"]!

        contraName.text = arreglo[Int(valueToPass)!]["contraName"]!
        contraCel.text = arreglo[Int(valueToPass)!]["contraCel"]!

        let odomtemp = arregloPolizas[Int(valueToPass)!]["lastodometer"]
        let mes = arregloPolizas[Int(valueToPass)!]["mensualidad"]
        //let decim = Double(odomtemp!)
        //let suma = Int((odomtemp?.description)!)! + 0
        let lastodo = NumberFormatter().string(from: NSNumber(value: Int(odomtemp!)!))
        ultimoreporte.text = lastodo
        
        //set picture loaded
        let pliza = arregloPolizas[Int(valueToPass)!]["idpoliza"]! as String
        let pathfoto = "\(pathPhotos)\(pliza)/FROM_VEHICLE.png"
        
        imagencarro.downloaded(from: pathfoto)
        imagencarro.layer.masksToBounds = false
        imagencarro.layer.cornerRadius = imagencarro.frame.height / 2
        imagencarro.clipsToBounds = true


        //imagencarro.sd_setImage(with: URL(string: pathfoto), placeholderImage: UIImage(named: "vista_auto_2"))
        
        //self.isHeroEnabled = true
        //imagencarro.heroID = "imagen"
        //imagencarro.heroModifiers = [.duration(0.5)]
        
        let tapGesturpostal = UITapGestureRecognizer(target: self, action: #selector(self.showImage(_:)))
        imagencarro.isUserInteractionEnabled = true
        imagencarro.addGestureRecognizer(tapGesturpostal)
                
        if mes != "0"{
            vistaEstado.isHidden = false
            middleLabel.isHidden = false
            //formPagoView.frame = CGRect(x: formPagoView.frame.midX, y: formPagoView.frame.midY, width: self.view.frame.width, height: formPagoView.frame.height)
        }
    }
    
    @objc func showImage (_ sender: UITapGestureRecognizer) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "showprofile") as! showImagesViewController
//        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func closeW(_ sender: Any) {
         dismiss(animated: true, completion: nil)
     }
    
    @IBAction func openDetalle(_ sender: UIButton) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailsLast") as! DetalleLastViewController
//        //vc?.modalTransitionStyle = .partialCurl
//        //vc.isHeroEnabled = true
//        //vc?.heroModalAnimationType = .slide(direction: .left)
//        //vc.heroModalAnimationType = .selectBy(presenting: .slide(direction: .left), dismissing: .slide(direction: .right))
//
//        //vc?.heroModalAnimationType = .zoomSlide(direction: .left)
//        //vc?.heroModalAnimationType = .pageIn(direction: .left)
//        //vc.cadenas = valueToPass
//        self.present(vc, animated: true, completion: nil)
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
    
    @IBAction func verEstadoCuenta(_ sender: Any) {
        tipopdf = "cuenta"
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
    
    @IBAction func cambiarPago(_ sender: Any) {
        
        let bundle = Bundle(for: FormaPagoViewController.self)
        let storyboard = UIStoryboard(name: "Pago", bundle: bundle)
        let vc = storyboard.instantiateViewController(withIdentifier: "FormaPagoViewController") as! FormaPagoViewController

        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "formapago") as! FormaPagoViewController
        //vc?.modalTransitionStyle = .partialCurl
        //vc.isHeroEnabled = true
        //vc?.heroModalAnimationType = .slide(direction: .left)
        //vc.heroModalAnimationType = .selectBy(presenting: .slide(direction: .left), dismissing: .slide(direction: .right))
        
        //vc?.heroModalAnimationType = .zoomSlide(direction: .left)
        //vc?.heroModalAnimationType = .pageIn(direction: .left)
        //vc.cadenas = valueToPass
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func facturasView(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "invoiceVC") as! InvoiceViewController

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
