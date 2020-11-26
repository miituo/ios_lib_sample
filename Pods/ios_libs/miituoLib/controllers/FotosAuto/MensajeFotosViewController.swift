//
//  MensajeFotosViewController.swift
//  miituoLib
//
//  Created by MACBOOK on 12/11/20.
//

import UIKit

class MensajeFotosViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)

    }
    

    @IBAction func closeWW(_ sender: Any) {
              
        self.dismiss(animated: true, completion: nil)
        
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
