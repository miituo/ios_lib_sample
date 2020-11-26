//
//  DetalleViewController.swift
//  miituoLib
//
//  Created by MACBOOK on 16/11/20.
//

import UIKit

class DetalleViewController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let tabBar = self.tabBarController?.tabBar else { return }
            
        tabBar.barTintColor = UIColor.white
        tabBar.unselectedItemTintColor = UIColor.lightGray

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

