//
//  CuponesViewController.swift
//  miituoLib
//
//  Created by MACBOOK on 14/11/20.
//

import UIKit
import Alamofire

class CuponesViewController: UIViewController {

    var rowsel = 0;
    var arregloFinal : [String:String] = [:]
    //@IBOutlet var toplinea: NSLayoutConstraint!
    //@IBOutlet var derecholinea: NSLayoutConstraint!
    
    @IBOutlet var odometrohoy: UILabel!
    // @IBOutlet var odometroanterior: NSLayoutConstraint!
    
    @IBOutlet var odometroanterior: UILabel!
    
    @IBOutlet var kilometrosrecorridos: UILabel!
    @IBOutlet var tarifaporkm: UILabel!
    @IBOutlet var promo: UILabel!
    @IBOutlet var promoshow: UILabel!
    
    //@IBOutlet var prima: UILabel!
    //@IBOutlet var basemes: UILabel!
    //@IBOutlet var baseshow: UILabel!
    
    @IBOutlet var totalapagar: UILabel!
    
    //@IBOutlet var primashow: UILabel!
    
    @IBOutlet var kms: UILabel!
    
    //@IBOutlet var startderecho: UILabel!
    
    @IBOutlet var letreroVacas: UILabel!
    @IBOutlet var toprecorridos: NSLayoutConstraint!    //40 normal
    
    @IBOutlet var starTope: UILabel!
    @IBOutlet var starCupon: UILabel!
    
    @IBOutlet var vacasshow: UILabel!
    @IBOutlet var vacastope: UILabel!
    //@IBOutlet var labeldos: UILabel!
    //@IBOutlet var startdos: UILabel!
    
    let alertaloading = UIAlertController(title: "Estamos realizando tu reporte.", message: "Esto puede tardar un momento, espere por favor...", preferredStyle: .alert)
    let alertaloadingmesonce = UIAlertController(title: "Atención", message: "Recuperando información, espere por favor...", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //perogress...
        /*let flag = true
         while flag {
         if odometro != "" {
         break;
         }
         }*/
        
        cargarinformacion();
        
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
    }
    
    func cargarinformacion(){
        
        valordevuelto = ""
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        //let finalnumber = numberFormatter.string(from: NSNumber(value: largeNumber))
        
        if odometro != "" {
            let _: Float = Float(odometro)!
            //odometrohoy.text = numberFormatter.string(from: NSNumber(value: Int(odometro)!))//odometro
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            
            odometrohoy.text = numberFormatter.string(from: NSNumber(value: Int(odometro)!))
            
            //odometrohoy.text = "\(String.localizedStringWithFormat("%.2f", valuehoy))"
            
            let _: Float = Float(odometroanteriorlast)!
            //odometroanterior.text = numberFormatter.string(from: NSNumber(value: Int(odometroanteriorlast)!))//odometroanteriorlast
            //odometroanterior.text = "\(String.localizedStringWithFormat("%.2f", valueanterior))"
            
            odometroanterior.text = numberFormatter.string(from: NSNumber(value: Int(odometroanteriorlast)!))
            
            let _: Float = Float(kilometrosrecorridoslast)!
            //kilometrosrecorridos.text = numberFormatter.string(from: NSNumber(value: Int(kilometrosrecorridoslast)!))//kilometrosrecorridoslast
            //kilometrosrecorridos.text = "\(String.localizedStringWithFormat("%.2f", valuerecorridos))"
            
            kilometrosrecorridos.text = numberFormatter.string(from: NSNumber(value: Int(kilometrosrecorridoslast)!))
            
            //let otrostring = Float(tarifaporkmlast)
            //let otrokmlast = numberFormatter.string(from: NSNumber(value: Double(tarifaporkmlast)!))
            tarifaporkm.text = "$ \((tarifaporkmlast))"
            
            //basemes.text = "$ \(basemeslast)"
            let _: Float = Float(basemeslast)!
            //basemes.text = "$ \(String.localizedStringWithFormat("%.2f", round(value)))"
            /*basemes.text = "$ \(String.localizedStringWithFormat("%.2f", (value)))"
            
            if basemeslast == "0.0"{
                baseshow.isHidden = true
                basemes.isHidden = true
            }*/
            
            //let otrototal = numberFormatter.string(from: NSNumber(value: Double(totalapagarlast)!))
            let valuetotal: Double = Double(totalapagarlast)!
            totalapagar.text = "$ \(String.localizedStringWithFormat("%.2f", valuetotal))"
            
            //let otrokms = numberFormatter.string(from: NSNumber(value: Double(tarifaneeeta)!))

            if banderacuponesvaca{
                /*
                arregloFinal["tope"] = "1,200"
                kilometrosrecorridoslast = "1200"
                kms.text = "1,200"
                */
                arregloFinal["tope"] = numberFormatter.string(from: NSNumber(value: Int(parametro_tope_kms))) //"1,200"
                kilometrosrecorridoslast = "\(parametro_tope_kms)"//"1200"
                kms.text = numberFormatter.string(from: NSNumber(value: Int(parametro_tope_kms)))
                                
                vacasshow.isHidden = false
                vacastope.isHidden = false
                
                vacastope.text = numberFormatter.string(from: NSNumber(value: Int(parametro_tope_kms)))
                //vacastope.text = numberFormatter.string(from: NSNumber(value: Int("1200")!))
                
                letreroVacas.isHidden = false
                toprecorridos.constant = 40
            }else{
                starTope.isHidden = true
                arregloFinal["tope"] = ""
                kms.text = numberFormatter.string(from: NSNumber(value: Int(kilometrosrecorridoslast)!))
                vacasshow.isHidden = true
                vacastope.isHidden = true
                
                letreroVacas.isHidden = true
                toprecorridos.constant = -40
            }
            
            if banderacuponesrefe{
                arregloFinal["cupon"] = "-\(kmscupon)"

                if kmscupon >= 50 {
                    promo.text = "-\(kmscupon)"
                }
                //pero si este tmb es true, entonces le restamos lo que venga en referidos
                //de momento fijo
                //let kmsfinales = Int(kilometrosrecorridoslast)! - kmscupon
                let kmsfinales = (kilometrosrecorridoslast as NSString).integerValue - kmscupon
                if kmsfinales < 0{
                    kms.text = "0"
                }else{
                    kms.text = numberFormatter.string(from: NSNumber(value: Int(kmsfinales)))//"\()"
                }
                //aparte, tenemos que restarle al amount los 100 kms
                _ = valorcuponrefe//Double(tarifaporkmlast)! * Double(kmscupon)
                let valuetotal: Double = Double(totalapagarlast)!
                let totalres = valuetotal// - arestar
                if totalres < 0 {
                    totalapagar.text = "$ 0.0"
                }else{
                    totalapagar.text = "$ \(String.localizedStringWithFormat("%.2f", totalres))"
                }
            }else{
                starCupon.isHidden = true
                arregloFinal["cupon"] = ""
                promo.isHidden = true
                promoshow.isHidden = true
            }
        }
        
        // Do any additional setup after loading the view.
        rowsel = Int(valueToPass)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Simolpement dice no aclarar....
    @IBAction func cancel(_ sender: Any) {
        
        //self.dismiss(animated: true, completion: {
        self.returntoodometer()
        //})
    }
    
    func salvarDatos(){
        
        var arraydob : [String:[String:String]] = ["":[:]]
        if let arregloFinal = UserDefaults.standard.value(forKey: "datoslast"){
            arraydob = arregloFinal as! [String : [String : String]]
        }else{
            //oculta boton, no hay datos aun
            //verdetalle.isHidden = true
            arraydob = ["":[:]]
        }
        
        let kmsrecorridos = kilometrosrecorridos.text!
        let primakm = tarifaporkm.text!
        let apagar = totalapagar.text!
        let odoactual = odometrohoy.text!
        let odoanterior = odometroanterior.text!
        //let cupon = promo.text!
        //let tope = vacastope.text!
        let kmsrec = kms.text!
        
        
        arregloFinal["kmsrecorridos"] = kmsrecorridos
        arregloFinal["kms"] = kmsrec
        arregloFinal["primakm"] = primakm
        arregloFinal["apagar"] = apagar
        arregloFinal["odoactual"] = odoactual
        arregloFinal["odoanterior"] = odoanterior
        arregloFinal["condonacion"] = ""
        
        let poliza = (arregloPolizas[Int(valueToPass)!]["idpoliza"]! as String)
        arraydob[poliza] = arregloFinal
        
        UserDefaults.standard.setValue(arraydob, forKey: "datoslast")

    }
    
    @IBAction func openTerminos(_ sender: UIButton) {
        //condiciones generales
//        if let requestUrl = NSURL(string: "https://www.miituo.com/Terminos/getPDF?Url=C%3A%5CmiituoFTP%5CCondiciones_Generales.pdf") {
//            //UIApplication.sharedApplication().openURL(requestUrl)
//            let svc = SFSafariViewController(url: requestUrl as URL)
//            present(svc, animated: true, completion: nil)
//        }
    }
    
    //confirma tarifa y enviamos a reportodometer/confirmreport
    @IBAction func lastStep(_ sender: Any) {
        
        //open alert to sincronizar
        openloading(mensaje: "Espere mientras llevámos a cabo el reporte...")
        
        let payment = arregloPolizas[rowsel]["payment"]!
        
        /// ----------- send confirmreport ------------ ///
        let todosEndpoint: String = "\(ip)ReportOdometer/Confirmreport"
        let tok = arreglo[self.rowsel]["token"]!
        
        guard let todosURL = URL(string: todosEndpoint) else {
            return
        }
        
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "POST"
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        todosUrlRequest.addValue(tok, forHTTPHeaderField: "Authorization")
        
        let newTodo: [String: Any] = [
            "Type":"1",
            "PolicyId":arregloPolizas[rowsel]["idpoliza"]!,
            "PolicyFolio":arregloPolizas[rowsel]["nopoliza"]!,
            "Odometer":odometro,
            "ClientId":arregloPolizas[rowsel]["idcliente"]!,
            "AppOdometer" : enterosFoto!
        ]
        
        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            todosUrlRequest.httpBody = jsonTodo
            
            _ = NSString(data: jsonTodo, encoding: String.Encoding.utf8.rawValue)
            
        } catch {
            return
        }

        let session = URLSession.shared
        
        let task = session.dataTask(with: todosUrlRequest) {
            (responseData, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200{
                    if let str = String(data: responseData!, encoding: String.Encoding.utf8) {
                        valordevuelto = str
                        
                        DispatchQueue.main.async {
                            //cerrando dialog...
                            self.alertaloading.dismiss(animated: true, completion: {
                                                                
                                var title = "Tu reporte se ha realizado."
                                var mensaje = "Gracias por ser parte del consumo equitativo."
                                
                                let valuetotal: Float = Float(totalapagarlast)!
                                if valuetotal == 0{
                                    mensaje = "Recibimos tu reporte mensual de odómetro."
                                    title = "Gracias"
                                }else if payment == "AMEX"{
                                    title = "Tu pago esta en proceso."
                                    mensaje = "En cuanto quede listo te lo haremos saber."
                                }
                                
                                if valordevuelto == "true" || valordevuelto == "false"{
                                    
                                    let deleteDataLog = Notification.Name("deleteDataLog")
                                    NotificationCenter.default.post(name: deleteDataLog, object: nil)
                                    
                                    let refreshAlert = createAlertMessageOrange(title: title, message: mensaje, preferredStyle: UIAlertController.Style.alert)
                                    
                                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                                                                
                                        self.launchPolizas()
                                    }))
                                    
                                    self.present(refreshAlert, animated: true, completion: nil)
                                } else {
                                    // parse the result as JSON, since that's what the API provides
                                    do {
                                        guard (try JSONSerialization.jsonObject(with: responseData!,                                                                                              options: []) as? [String: Any]) != nil else {
                                            
                                            return
                                        }
                                        
                                        //self.alertaloading.dismiss(animated: true, completion: {
                                            
                                            let backServiceName = Notification.Name("backServiceName")
                                            
                                            NotificationCenter.default.post(name: backServiceName, object: nil)
                                        
                                        let refreshAlert = createAlertMessageOrange(title: "Odómetro", message: "Error al enviar odómetro. Intente más tarde.", preferredStyle: UIAlertController.Style.alert)
                                        
                                        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                                
                                                self.launchPolizas()
                                                
                                            }))
                                            
                                            self.present(refreshAlert, animated: true, completion: nil)
                                        //})
                                    } catch  {
                                        //return 125445
                                    }
                                }
                            }) // end self loading dismiss
                        }
                        
                    } else {
                    }
                } else {
                    // parse the result as JSON, since that's what the API provides
                    do {
                        guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData!,                                                                                  options: []) as? [String: Any] else {
                            return
                        }

                        if receivedTodo.description.contains("Por el momento tu pago no se"){
                            if let meessage = receivedTodo["Message"] {
                                DispatchQueue.main.async {
                                self.alertaloading.dismiss(animated: true, completion: {
                                    
                                    let backServiceName = Notification.Name("backServiceName")
                                    
                                    NotificationCenter.default.post(name: backServiceName, object: nil)
                                    let refreshAlert = createAlertMessageOrange(title: "Odómetro", message: meessage as! String, preferredStyle: UIAlertController.Style.alert)

                                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                        
                                        self.launchPolizas()
                                        
                                    }))
                                    
                                    self.present(refreshAlert, animated: true, completion: nil)
                                })
                                }
                            }
                        }
                        else{
                            DispatchQueue.main.async {
                            self.alertaloading.dismiss(animated: true, completion: {
                                                                                             
                                let backServiceName = Notification.Name("backServiceName")
                                
                                NotificationCenter.default.post(name: backServiceName, object: nil)
                                let refreshAlert = createAlertMessageOrange(title: "Odómetro", message: "Error al enviar odómetro. Intente más tarde.", preferredStyle: UIAlertController.Style.alert)
                                
                                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                    
                                    self.launchPolizas()
                                    
                                }))
                                self.present(refreshAlert, animated: true, completion: nil)
                            })
                            }
                        }
                    } catch  {
                        DispatchQueue.main.async {
                        self.alertaloading.dismiss(animated: true, completion: {
                            
                            let backServiceName = Notification.Name("backServiceName")
                            
                            NotificationCenter.default.post(name: backServiceName, object: nil)
                            
                            let refreshAlert = createAlertMessageOrange(title: "Odómetro", message: "Error al enviar odómetro. Intente más tarde.", preferredStyle: UIAlertController.Style.alert)
                            
                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                
                                self.launchPolizas()
                                
                            }))
                            self.present(refreshAlert, animated: true, completion: nil)
                        })
                        }
                    }
                }
            }else{
                DispatchQueue.main.async {
                self.alertaloading.dismiss(animated: true, completion: {
                    let backServiceName = Notification.Name("backServiceName")
                    
                    NotificationCenter.default.post(name: backServiceName, object: nil)
                                                    
                    let refreshAlert = createAlertMessageOrange(title: "Odómetro", message: "Error al enviar odómetro. Intente más tarde.", preferredStyle: UIAlertController.Style.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        self.launchPolizas()
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                })
                }
            }
        }
        task.resume()
    }
    
//-----------------------------get back polizas view-------------------------
    func launchPolizas(){
        
        //validar mes 12
        let mensualidad = Int(arregloPolizas[rowsel]["mensualidad"]!)
        if mensualidad! == 10 {
            //consumir servicio para traer datos
            callFunciongetTarifa()
            
        }else if mensualidad!+1 >= 12 {
            //lanzo ventana de renovacion
            //ok => regreso a polizas, aqui viene el rollo de la nueva poliza en estatus de pendiente de pago renovacion
            //pinto poliza con pendiente de pago
            
            callFunciongetTarifaDoce()
        }else{
            actualizar = "1"
            let back_ticket_polizas = Notification.Name("back_ticket_polizas")
            self.dismiss(animated: false) {
                NotificationCenter.default.post(name: back_ticket_polizas, object: nil)
            }
                        
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let myAlert = storyboard.instantiateViewController(withIdentifier: "reveal") as! SWRevealViewController
//
//            myAlert.modalPresentationStyle = UIModalPresentationStyle.fullScreen
//            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//
//            //launch second view with data - show table and polizas
//            //let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
//            self.present(myAlert, animated: true, completion: nil)
        }
    }
    
//***************************update status poliza*****************************
    func callFunciongetTarifa(){
        openloading2(mensaje: "Consultando información...")

        _ = arreglo[self.rowsel]["token"]!
        let idpoliza = arregloPolizas[self.rowsel]["idpoliza"]

        if let value = idpoliza{
            //in value you will get non optional value
        
        let api = "\(ip)Quotation/GetPreQuotationInfo/\(value)"
        
            let _: [String: Any] = [:]//["Type": "6","ImageItem":datainter]
        // call api to get vehicle type data
            
        AF.request(api,method:.get,parameters:nil,encoding:JSONEncoding.default, headers: nil).responseJSON() { response in
            
            if response.error != nil{
                self.launch_alert_mes_once()
            }else{
                switch response.result {
                    
                case .success(let value):
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
                        guard let json = decoded as? [String:Any] else{
                            return
                        }
                        let status = response.response?.statusCode
                        if status != 200{
                            self.launch_alert()
                        }
                        else if json.count == 0 {
                            self.launch_alert_mes_once()
                        }else{
                            if let data = json["strNewRate"] as? String{
                                nueva_tarifa = data
                            }
                            //nueva_tarifa = json["strNewRate"].description// as String
                            if let data = json["PolicyCost"] as? String{
                                rco = data
                            }
                            //rco = json["PolicyCost"].description
                            if nueva_tarifa == "" || nueva_tarifa == "null"{
                                self.launch_alert()
                            }
                            else{
                            DispatchQueue.main.async {
                                self.alertaloadingmesonce.dismiss(animated: true, completion: {
                                    //lanzo ventana de renovacion
                                    //ok => regreso a polizas, aqui viene el rollo de la nueva poliza en estatus de pendiente de pago renovacion
                                    //pinto poliza con pendiente de pago
                                    let bundle = Bundle(for: RenovacionMesOnceViewController.self)
                                    let storyboard = UIStoryboard(name: "Renovacion", bundle: bundle)
                                    let myAlert = storyboard.instantiateViewController(withIdentifier: "RenovacionMesOnceViewController") as! RenovacionMesOnceViewController

                                    myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                    myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                                    self.present(myAlert, animated: true, completion: nil)
                                })
                            }
                            }
                        }
                    }
                    catch {
                        self.launch_alert_mes_once()
                    }
                    break
                case .failure( _):
                    self.launch_alert_mes_once()
                    break
                }
            }
        }
        }
    }

//***************************update status poliza*****************************
    func callFunciongetTarifaDoce(){
        openloading2(mensaje: "Consultando información...")
        
        _ = arreglo[self.rowsel]["token"]!
        let idpoliza = arregloPolizas[self.rowsel]["idpoliza"]

        if let value = idpoliza{
            //in value you will get non optional value
            
            let api = "\(ip)Quotation/GetPreQuotationInfo/\(value)"
            // show dialog loading
            //let progressHUD = ProgressHUD(text: "Recuperando información")
            //vistaloading.isHidden = false
            //vistaloading.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            //vistaloading.addSubview(progressHUD)
            
            //let datainter: [String: Any] = ["PolicyId":arregloPolizas[self.rowsel]["idpoliza"],"PolicyFolio":arregloPolizas[self.rowsel]["nopoliza"],"Odometer":"0","ClientId":arregloPolizas[self.rowsel]["idcliente"],"CancelacionVoluntaria":true]
            let _: [String: Any] = [:]//["Type": "6","ImageItem":datainter]
            // call api to get vehicle type data
            /*let parametros = ["Gender":"\(sexoDato)","VehicleTMMSDId":"\(VehicleTMMSDId)","BirthdayDate":"\(birthday)","HasGarage":"\(garageDato)","ZipCode":"\(ZipCode)","ClientIp":"","Device":"App"]*/
            //let header = ["Content-Type":"application/json"]
            
            //let headerss: HTTPHeaders = ["Content-Type": "application/json", "Authorization" : tok]
            AF.request(api,method:.get,parameters:nil,encoding:JSONEncoding.default, headers: nil).responseJSON() { response in
                
                if response.error != nil{
                    self.launch_alert_mes_once()
                }else{
                    switch response.result {
                        
                    case .success(let value):
                        do{
                        let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
                        guard let json = decoded as? [String:Any] else{
                            return
                        }
                        
                        let status = response.response?.statusCode
                        if status != 200{
                            self.launch_alert()
                        }
                        else{
                            if json.count == 0{
                                self.launch_alert_mes_once()
                            }else{
                                //let polizapadre = json["PolicyChild"]
                                if let data = json["strNewRate"] as? String{
                                    nueva_tarifa = data
                                }
                                //nueva_tarifa = json["strNewRate"].description// as String
                                if let data = json["PolicyCost"] as? String{
                                    rco = data
                                }
                                //rco = json["PolicyCost"].description
                                if nueva_tarifa == "" || nueva_tarifa == "null"{
                                    self.launch_alert()
                                }
                                else{
                                    DispatchQueue.main.async {
                                        self.alertaloadingmesonce.dismiss(animated: true, completion: {
                                            //lanzo ventana de renovacion
                                            //ok => regreso a polizas, aqui viene el rollo de la nueva poliza en estatus de pendiente de pago renovacion
                                            //pinto poliza con pendiente de pago
                                            let bundle = Bundle(for: RenovacionMesDoceViewController.self)
                                            let storyboard = UIStoryboard(name: "Renovacion", bundle: bundle)
                                            let myAlert = storyboard.instantiateViewController(withIdentifier: "RenovacionMesDoceViewController") as! RenovacionMesDoceViewController
                                            
                                            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                                            
                                            //launch second view with data - show table and polizas
                                            //let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
                                            self.present(myAlert, animated: true, completion: nil)
                                        })
                                    }
                                }

                            }
                        }
                        } catch {
                            self.launch_alert_mes_once()
                        }
                        break
                    case .failure( _):
                        self.launch_alert_mes_once()
                        break
                    }
                }
            }
        }
    }
    
//************************ launch odometer WS*******************************//
    func launch_alert_mes_once() {
        DispatchQueue.main.async {
            self.alertaloadingmesonce.dismiss(animated: true, completion: {
                
                /*let refreshAlert = UIAlertController(title: "Atención", message: "Error al recuperar información. Intente más tarde.", preferredStyle: UIAlertControllerStyle.alert)
                 
                 refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                 self.launcpolizas()
                 
                 //self.dismiss(animated: true, completion: nil)
                 }))
                 
                 self.present(refreshAlert, animated: true)*/
                self.launcpolizas()
            })
        }
    }
    
//************************ launch odometer WS*******************************//
    func launch_alert() {
        DispatchQueue.main.async {
            self.alertaloading.dismiss(animated: true, completion: {
                
                let refreshAlert = createAlertMessageOrange(title: "Atención", message: "Error al recuperar información. Intente más tarde.", preferredStyle: UIAlertController.Style.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    self.launcpolizas()
                    
                    //self.dismiss(animated: true, completion: nil)
                }))
                
                self.present(refreshAlert, animated: true)
            })
        }
    }
    
//************************ lauch polzas********************************//
    func launcpolizas(){
        actualizar = "1"
        //launch view to confirm odometer
        
        //TODO: - BACK TO POLIZAS
        let back_ticket_polizas = Notification.Name("back_ticket_polizas")
        self.dismiss(animated: false) {
            NotificationCenter.default.post(name: back_ticket_polizas, object: nil)
        }
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let myAlert = storyboard.instantiateViewController(withIdentifier: "reveal") as! SWRevealViewController
//
//        myAlert.modalPresentationStyle = UIModalPresentationStyle.fullScreen
//        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//
//        //launch second view with data - show table and polizas
//        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
//        self.present(myAlert, animated: true, completion: nil)
    }

//------------------------loading page------------------------------------------------
    func openloading(mensaje: String){
        
        alertaloading.view.tintColor = UIColor.black
        //CGRect(x: 1, y: 5, width: self.view.frame.size.width - 20, height: 120))
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:10, y:5, width:50, height:50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alertaloading.view.addSubview(loadingIndicator)
        present(alertaloading, animated: true, completion: nil)
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
    func returntoodometer(){
        //launch view to confirm odometer
        let back_ticket_odometer = Notification.Name("back_ticket_odometer")
        self.dismiss(animated: false) {
            NotificationCenter.default.post(name: back_ticket_odometer, object: nil)
        }
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let myAlert = storyboard.instantiateViewController(withIdentifier: "confirmOdo") as! ConfirmOdometerViewController
//        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//
//        self.present(myAlert, animated: true, completion: nil)
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
