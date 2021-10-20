//
//  ReportConfirmViewController.swift
//  miituoLib
//
//  Created by MACBOOK on 14/11/20.
//

import UIKit

class ReportConfirmViewController: GenericViewController {
    
    var datareturned = [String:String]()
        
    @IBOutlet weak var textres: customTextField!
    @IBOutlet weak var imagenodo: UIImageView!
    
    var blurEffect:UIBlurEffect? = nil
    
    let back_odometer = Notification.Name("back_odometer")
    let back_polizas = Notification.Name("back_polizas")

    override func viewDidLoad() {
        super.viewDidLoad()

        odometro = ""
        flag = false
        textres.text = odometro
        textres.setup(view: self.view, placeT: "Confirma odómetro")
        
        let rowsel = Int(valueToPass)!
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(popView), name: back_odometer, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(popAll), name: back_polizas, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func popView(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func popAll(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func closeWW(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendOdo(_ sender: Any) {
        let odometroaenviar = textres.text! as String
        
        if odometroaenviar == "" {
            textres.showError(errorT: "Captura los kms. que marca el odómetro.")
            //createAlertMessage(title: "Atención", message: "Es necesario capturar los kms. que marca el odómetro.", controller: self)
        }else if odometroaenviar != odometrouno {
            textres.showError(errorT: "Los odómetros no coinciden.")
            //createAlertMessage(title: "Atención", message: "Los odómetros no coinciden, por favor verifícalos", controller: self)
        }
        else{
            odometro = odometroaenviar
            let myAlert = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmOdoPopViewController") as! ConfirmOdoPopViewController
            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            
            self.present(myAlert, animated: true, completion: nil)
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
