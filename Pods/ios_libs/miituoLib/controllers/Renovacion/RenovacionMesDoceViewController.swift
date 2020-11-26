//
//  RenovacionMesDoceViewController.swift
//  miituoLib
//
//  Created by MACBOOK on 14/11/20.
//

import UIKit

class RenovacionMesDoceViewController: UIViewController {

    @IBOutlet var viewPago: UIView!
    @IBOutlet var labelPago: UILabel!
    
    let alertaloadingmesonce = UIAlertController(title: "Atención", message: "Recuperando información, espere por favor...", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()

        viewPago.layer.borderWidth = 2.0
        viewPago.layer.cornerRadius = 15.0
        let gris = UIColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        viewPago.layer.borderColor = gris.cgColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionOk(_ sender: Any) {

        updatestatus()
        
    }
    
    func launcpolizas(){
        actualizar = "1"
        
        //TODO: - back to polizas
        let bundle = Bundle(for: PolizasViewController.self)
        let storyboard = UIStoryboard(name: "Polizas", bundle: bundle)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "navpolizas") as! UINavigationController
        
        myAlert.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(myAlert, animated: true, completion: nil)
    }
    
    func openloading2(mensaje: String){
        
        alertaloadingmesonce.view.tintColor = UIColor.black
        //CGRect(x: 1, y: 5, width: self.view.frame.size.width - 20, height: 120))
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:10, y:5, width:50, height:50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alertaloadingmesonce.view.addSubview(loadingIndicator)
        present(alertaloadingmesonce, animated: true, completion: nil)
    }
    
    
//***************************update status poliza***************************
    func updatestatus(){
        
        openloading2(mensaje: "Consultando información...")
        
        let todosEndpoint: String = "\(ip)Policy/UpdatePolicyStatusReport/\(polizaPadreId)/12"
        let rowsel = Int(valueToPass)!
        let tok = arreglo[rowsel]["token"]!
        
        guard let todosURL = URL(string: todosEndpoint) else {
            return
        }
        
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "PUT"
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        todosUrlRequest.addValue(tok, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let loadTask = session.dataTask(with: todosUrlRequest) { (responseData,response,error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200{
                    if let str = String(data: responseData!, encoding: String.Encoding.utf8) {
                        lastvalordev = str
                        
                        DispatchQueue.main.async {
                            
                            self.alertaloadingmesonce.dismiss(animated: true, completion: {
                                self.launcpolizas()
                            })
                        }
                    } else {
                        
                    }
                }//sTATUS DIFerente a 200
                else {
                    // parse the result as JSON, since that's what the API provides
                    do {
                        guard (try JSONSerialization.jsonObject(with: responseData!,options: []) as? [String: Any]) != nil else {
                            return
                        }
                        
                        self.alertaloadingmesonce.dismiss(animated: true, completion: {
                            
                            let refreshAlert = createAlertMessageOrange(title: "Odómetro", message: "Error al enviar odómetro. Intente más tarde.", preferredStyle: UIAlertController.Style.alert)
                            
                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                
                                self.launcpolizas()
                            }))
                            
                            self.present(refreshAlert, animated: true, completion: nil)
                        })
                        
                    } catch  {
                    }
                }
            }
        }
        loadTask.resume()

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
