//
//  ConfirmOdometerViewController.swift
//  miituoLib
//
//  Created by MACBOOK on 14/11/20.
//

import UIKit

class ConfirmOdometerViewController: GenericViewController {

    @IBOutlet weak var textres: customTextField!
    
    @IBOutlet weak var imagenodo: UIImageView!
        
    //@IBOutlet var upconstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        odometrouno = ""
        textres.delegate = self
        textres.text = odometrouno
        textres.setup(view: self.view, placeT: "Odómetro")

        let rowsel = Int(valueToPass)!
        let poliza = arregloPolizas[rowsel]["lastodometer"]! as String
        
        if poliza == "0"{
            
            //lastodo.isHidden = true
            //textoantes.isHidden = true
            //upconstraint.constant = -25
        }
        
        //set picture loaded
        let pliza = arregloPolizas[rowsel]["nopoliza"]! as String
        let fileManager = FileManager.default
        let filename = getDocumentsDirectory().appendingPathComponent("odometro_\(pliza).png")
        if fileManager.fileExists(atPath: filename.path){
            let image = UIImage(contentsOfFile: filename.path)
            imagenodo.layer.cornerRadius = 10.0
            //imagencarro.transform = imagencarro.transform.rotated(by: CGFloat(Double.pi/2))
            imagenodo.layer.masksToBounds = true
            imagenodo.image = image
        } else {
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func closeW(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
         self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backToPolizas(_ sender: Any) {
        //recupero texto
        //valido que no sea vacio
        //envio a siguiente pantalla para volver a colocar odometro
        let cadena = textres.text
        
        if cadena == "" {
            textres.showError(errorT: "Captura los kms. que marca el odómetro.")
            //showmessage(message: "Es necesario capturar los kms. que marca el odómetro.", controller: self)
        }else{
            odometrouno = cadena!
            //launch view to confirm odometer
            let odometerview = self.storyboard?.instantiateViewController(withIdentifier: "ReportConfirmViewController") as! ReportConfirmViewController
            
            //openview
            self.navigationController?.pushViewController(odometerview, animated: true)
            //self.present(odometerview, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "backcamera"{
//            if flagSimulacion || flagProyeccion{
//                dismiss(animated: true, completion: nil)
//            }
//        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
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
