//
//  ViewController.swift
//  UsingLibSample
//
//  Created by John Alexis Cristobal Jimenez  on 03/11/20.
//

import UIKit
import ios_libs

class ViewController: UIViewController {

    @IBOutlet weak var celField: UITextField!
    @IBOutlet weak var developmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func launchLib(_ sender: Any) {
        let bundle = Bundle(for: PolizasViewController.self)
        let storyboard = UIStoryboard(name: "Polizas", bundle: bundle)
        
        let myAlert = storyboard.instantiateViewController(withIdentifier: "navpolizas") as! UINavigationController
        myAlert.modalPresentationStyle = .fullScreen
        let vc = myAlert.viewControllers[0] as! PolizasViewController
        
        if celField.text != ""{
            vc.phoneDataFromView = celField.text
            
            let development = (developmentControl.selectedSegmentIndex == 0) ? true : false
            vc.dev = development
            
            present(myAlert, animated: true, completion: nil)
        }
    }
}
