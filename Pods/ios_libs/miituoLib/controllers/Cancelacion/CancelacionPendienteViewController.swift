//
//  CancelacionPendienteViewController.swift
//  miituoLib
//
//  Created by MACBOOK on 16/11/20.
//

import UIKit

class CancelacionPendienteViewController: UIViewController {

    @IBOutlet var poliza: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        poliza.text = arregloPolizas[Int(valueToPass)!]["nopoliza"]!

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func closeW(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

