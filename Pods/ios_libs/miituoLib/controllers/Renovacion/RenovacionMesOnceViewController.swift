//
//  RenovacionMesOnceViewController.swift
//  miituoLib
//
//  Created by MACBOOK on 14/11/20.
//

import UIKit

class RenovacionMesOnceViewController: UIViewController {

    @IBOutlet var top00: NSLayoutConstraint!
    @IBOutlet var top0: NSLayoutConstraint!
    @IBOutlet var top1: NSLayoutConstraint!
    
    @IBOutlet var top3: NSLayoutConstraint!
    @IBOutlet var top2: NSLayoutConstraint!
    var fechavigencia = ""
    @IBOutlet var labelFecha: UILabel!
    @IBOutlet var labelPagoUnico: UILabel!
    @IBOutlet var labelTarifa: UILabel!
    @IBOutlet var vistaPago: UIView!
    @IBOutlet var plantippLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //imagengif.loadGif(name: "miituosplash")
        let screenSize = UIScreen.main.bounds
        _ = screenSize.width
        let screenHeight = screenSize.height
                
        if screenHeight > 560 {
            top00.constant = 20
            top0.constant = 20
            top1.constant = 10
            top2.constant = 10
            top3.constant = 15
        }
        if screenHeight > 660 {
            top00.constant = 60
            top0.constant = 40
            top1.constant = 40
            top2.constant = 35
            top3.constant = 25
        }
        if screenHeight > 730 {
            top00.constant = 60
            top0.constant = 40
            top1.constant = 40
            top2.constant = 35
            top3.constant = 25
        }
        
        //vistaPago.layer.borderWidth = 2.0
        //vistaPago.layer.cornerRadius = 15.0
        _ = UIColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        //vistaPago.layer.borderColor = gris.cgColor
        
        labelPagoUnico.text = "$\(rco)"
        labelTarifa.text = "$\(nueva_tarifa)"
        
        if valueToPass == ""{
            labelFecha.text = fecha_vigencia
            plantippLabel.text = plantipo
        }else{
            let rowsel = Int(valueToPass)!
            let coverage = arregloPolizas[rowsel]["coverage"]!
            let dateString = arregloPolizas[rowsel]["fechavigencia"]!
            //let dateString = "2014-07-15" // change to your date format
            //let dateString = arregloPolizas[Int(valueToPass)!]["limitefecha"]! as String
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
            let valanio = dateFormattermes.string(from: date!)
            labelFecha.text = "\(valdia) de \(valmes) de \(valanio)"
            plantippLabel.text = coverage
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getNombreMes(nombre: String) -> String{
        if nombre == "ene" || nombre == "Jan" || nombre == "jan" || nombre == "Ene"{
            return "enero"
        }else if nombre == "feb" || nombre == "Feb"{
            return "febrero"
        }else if nombre == "mar" || nombre == "Mar"{
            return "marzo"
        }else if nombre == "abr" || nombre == "apr" || nombre == "Apr"{
            return "abril"
        }else if nombre == "may" || nombre == "May"{
            return "mayo"
        }else if nombre == "jun" || nombre == "Jun"{
            return "junio"
        }else if nombre == "jul" || nombre == "Jul"{
            return "julio"
        }else if nombre == "ago" || nombre == "aug" || nombre == "Aug" || nombre == "Ago"{
            return "agosto"
        }else if nombre == "sep" || nombre == "Sep"{
            return "septiembre"
        }else if nombre == "oct" || nombre == "Oct"{
            return "octubre"
        }else if nombre == "nov" || nombre == "Nov"{
            return "noviembre"
        }else if nombre == "dic" || nombre == "dec" || nombre == "Dic" || nombre == "Dec"{
            return "diciembre"
        }else{
            return nombre
        }
    }
    
    @IBAction func actionOk(_ sender: Any) {
        actualizar = "1"
        
        //TODO: - back to polizas
        let bundle = Bundle(for: PolizasViewController.self)
        let storyboard = UIStoryboard(name: "Polizas", bundle: bundle)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "navpolizas") as! UINavigationController
        
        myAlert.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(myAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func callOut(_ sender: UIButton) {
        let numbertel = "5584210500"
        guard let number = URL(string: "tel://" + numbertel) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(number)
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    @IBAction func callOutDos(_ sender: Any) {
        
        let numbertel = "8009530059"
        guard let number = URL(string: "tel://" + numbertel) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(number)
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
