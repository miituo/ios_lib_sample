//
//  ConfirmOdoPopViewController.swift
//  miituoLib
//
//  Created by MACBOOK on 14/11/20.
//

import UIKit
import CoreData
import Alamofire

class ConfirmOdoPopViewController: UIViewController {

    var rowsel = 0
    
    let manager = DataManager.shared

    @IBOutlet var labelodo: UILabel!
    
    //@IBOutlet var labelodometro: UILabel!
    let alertaloadingodo = UIAlertController(title: "Odómetro", message: "Subiendo información...", preferredStyle: .alert)

    let back_odometer = Notification.Name("back_odometer")
    let back_ticket_odometer = Notification.Name("back_ticket_odometer")
    let back_ticket_polizas = Notification.Name("back_ticket_polizas")
    let back_polizas = Notification.Name("back_polizas")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal

        //set number odometre
        labelodo.text = numberFormatter.string(from: NSNumber(value: Int(odometro)!)) //odometro
        
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        rowsel = Int(valueToPass)!
        
        odometroanteriorlast = ""
        odometroaactuallast = ""
        kilometrosrecorridoslast = ""
        tarifaporkmlast = ""
        primalast = ""
        basemeslast = ""
        promolast = ""
        totalapagarlast = ""
        derechopolizad = ""
        esperando = ""
        
        tarifaneeeta = ""
        
        banderaPushPago = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(returntoodometer), name: back_ticket_odometer, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(launcpolizas), name: back_ticket_polizas, object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closePop(_ sender: Any) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                //self.dismiss(animated: true, completion: {
                    self.returntoodometer()
                //})
            }
        }
    }
    
    @IBAction func sendOdometrofinal(_ sender: Any) {
        
        if solofotos == 1{
            solofotos = 0
            updatestatusone()
        }
        else if tipoodometro == "first"{
            enviarodometro()
        }else if tipoodometro == "mensual" {
            sendReportOdometer()
        }
        else if tipoodometro == "cancela" {
            ajustaReportOdometer()
        }
        else if tipoodometro == "ajuste" {
            ajustaReportOdometer()
        }
    }
    
//****************Functionupdatetcasification************************
    func upstatecasification()
    {
        /// ----------- send confirmreport ------------ ///
        //Para actualizar el campo de Id_Estatus de la tabla de Clientes_Ticket
        let todosEndpoint: String = "\(ip)UpStateCasification"
        let tok = arreglo[self.rowsel]["token"]!
        let cadenaidticket = arregloPolizas[self.rowsel]["idticket"]
        
        idticket = Int(cadenaidticket!)!
        
        guard let todosURL = URL(string: todosEndpoint) else {
            return
        }
        
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "PUT"
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        todosUrlRequest.addValue(tok, forHTTPHeaderField: "Authorization")

        let newTodo: [String: Any] = ["Id":idticket,"sTiket":9,"GodinName":"App","GodynSolution":""]
        
        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            todosUrlRequest.httpBody = jsonTodo
            _ = NSString(data: jsonTodo, encoding: String.Encoding.utf8.rawValue)
            
        } catch {
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: todosUrlRequest) { (responseData, response, error) in

            if let httpResponse = response as? HTTPURLResponse
            {
                if httpResponse.statusCode == 200{
                    if let str = String(data: responseData!, encoding: String.Encoding.utf8) {
                        valordevuelto = str
                    } else {
                    }
                } else {
                    // parse the result as JSON, since that's what the API provides
                     do {
                        guard (try JSONSerialization.jsonObject(with: responseData!,
                                                                options: []) as? [String: Any]) != nil else {
                            return
                         }
                         
                         self.alertaloadingodo.dismiss(animated: true, completion: {
                         
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
        task.resume()
    }
    
//***************************update dometer tkcet****************************
    func ticketupload(){

        //Se actualiza el  odometro en la tabla de Clientes ticket en el campo
        let todosEndpoint: String = "\(ip)Ticket/"
        let tok = arreglo[self.rowsel]["token"]!

        guard let todosURL = URL(string: todosEndpoint) else {
            return
        }
        
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "PUT"
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        todosUrlRequest.addValue(tok, forHTTPHeaderField: "Authorization")

        let newTodo: [String: Any] = ["OdomCorrect": 0, "OdomMoment": odometro, "idTicket":idticket, "idPolicy":arregloPolizas[self.rowsel]["nopoliza"]!]
        
        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            _ = NSString(data: jsonTodo, encoding: String.Encoding.utf8.rawValue)
            todosUrlRequest.httpBody = jsonTodo
            
        } catch {
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: todosUrlRequest) { (responseData, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200{
                    if let str = String(data: responseData!, encoding: String.Encoding.utf8) {
                        valordevuelto = str
                    } else {
                    }
                } else {
                     // parse the result as JSON, since that's what the API provides
                     do {
                        guard (try JSONSerialization.jsonObject(with: responseData!,
                                                                options: []) as? [String: Any]) != nil else {
                            return
                         }
                         
                         self.alertaloadingodo.dismiss(animated: true, completion: {
                            
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
        task.resume()
    }

//***************************update status poliza***************************
    func updatestatus(){
        
        let todosEndpoint: String = "\(ip)Policy/UpdatePolicyStatusReport/\(arregloPolizas[rowsel]["idpoliza"]!)/12"
        let tok = arreglo[self.rowsel]["token"]!

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

                        self.alertaloadingodo.dismiss(animated: true, completion: {
                            
                            //si es true o false => pasa sin problermas y cierra
                            if lastvalordev == "true"{
                                
                                let refreshAlert = createAlertMessageOrange(title: "Gracias", message: "Información del odómetro actualizada.", preferredStyle: UIAlertController.Style.alert)
                                
                                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                    
                                    self.launcpolizas()
                                }))
                                
                                self.present(refreshAlert, animated: true, completion: nil)
                            }
                            else
                            {
                                let refreshAlert = createAlertMessageOrange(title: "Atención", message: "Error al cargar información, intente más tarde", preferredStyle: UIAlertController.Style.alert)
                                
                                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                    
                                    self.launcpolizas()
                                }))
                                
                                self.present(refreshAlert, animated: true)
                            }
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
                     
                     self.alertaloadingodo.dismiss(animated: true, completion: {
                                              
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
        
         /*while true {
            if lastvalordev != ""{
                break;
            }
         }*/
    }

//***************************update status poliza*******************************
    func updatestatusone(){
        
        //alertaloading.dismiss(animated: true, completion: nil)
        openloading(mensaje: "nanana")
        
        let todosEndpoint: String = "\(ip)Policy/UpdatePolicyStatusReport/\(arregloPolizas[rowsel]["idpoliza"]!)/12/\(odometro)"
        let tok = arreglo[self.rowsel]["token"]!
        
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
                            
                            self.alertaloadingodo.dismiss(animated: true, completion: {
                                //si es true o false => pasa sin problermas y cierra
                                if lastvalordev == "true"{
                                                                    
                                    let refreshAlert = createAlertMessageOrange(title: "Gracias", message: "Información actualizada.", preferredStyle: UIAlertController.Style.alert)
                                    
                                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                        
                                        self.launcpolizas()
                                        
                                        //openview
                                        //self.present(odometerview, animated: true, completion: nil)
                                        
                                    }))
                                    
                                    self.present(refreshAlert, animated: true, completion: nil)
                                }
                                else
                                {
                                    let refreshAlert = createAlertMessageOrange(title: "Atención", message: "Error al cargar información, intente más tarde", preferredStyle: UIAlertController.Style.alert)
                                    
                                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                        
                                        self.launcpolizas()
                                    }))
                                    
                                    self.present(refreshAlert, animated: true)
                                }
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
                        
                        self.alertaloadingodo.dismiss(animated: true, completion: {
                            
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
    
//***************************Function to send token to ws*********************
    func ajustaReportOdometer(){

        //open alert to sincronizar
        openloading(mensaje: "Espere mientras llevámos a cabo el reporte...")
        
        //servicio para actualiza status en UpStateCasification------------------------------------
        upstatecasification()   //ok
        ticketupload()
        updatestatus()
    }
    
//enviar odometro first time----------------------------------------
    func enviarodometro(){
        
        //open alert to sincronizar
        openloading(mensaje: "Espere mientras llevámos a cabo el reporte...")
        
        //DispatchQueue.global(qos: .userInitiated).async {

        let todosEndpoint: String = "\(ip)ImageProcessing/ConfirmOdometer"
         let tok = arreglo[self.rowsel]["token"]!

         guard let todosURL = URL(string: todosEndpoint) else {
             return
         }
         
         var todosUrlRequest = URLRequest(url: todosURL)
         todosUrlRequest.httpMethod = "POST"
         todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
         todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
         todosUrlRequest.addValue(tok, forHTTPHeaderField: "Authorization")
                
        let newTodo: [String: Any] = ["Type": "5", "Odometer": odometro, "PolicyId":arregloPolizas[self.rowsel]["idpoliza"]!,"PolicyFolio":arregloPolizas[self.rowsel]["nopoliza"]!]

        let jsonTodo: Data
            //var jsonString = ""
         
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            //jsonString = NSString(data: jsonTodo, encoding: String.Encoding.utf8.rawValue)! as String
            todosUrlRequest.httpBody = jsonTodo
            

         } catch {
             return
         }
        
         let session = URLSession.shared
         
         let task = session.dataTask(with: todosUrlRequest) {
         (responseData, response, error) in
            
         if let httpResponse = response as? HTTPURLResponse {
             if httpResponse.statusCode == 200 {
                 if let str = String(data: responseData!, encoding: String.Encoding.utf8) {
                    valordevuelto = str
                                        
                    DispatchQueue.main.async {
                    self.alertaloadingodo.dismiss(animated: true, completion: {
                        
                        //si es true o false => pasa sin problermas y cierra
                        if valordevuelto == "true"{
                            
                            let deleteDataLog = Notification.Name("deleteDataLog")
                            NotificationCenter.default.post(name: deleteDataLog, object: nil)
                            
                            let refreshAlert = createAlertMessageOrange(title: "Gracias", message: "Tu información ha sido actualizada.", preferredStyle: UIAlertController.Style.alert)
                            
                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                
                                self.launcpolizas()
                            }))
                            
                            self.present(refreshAlert, animated: true)
                            
                        }else{
                            let backServiceName = Notification.Name("backServiceName")
                            
                            NotificationCenter.default.post(name: backServiceName, object: nil)
                            
                            DispatchQueue.main.async {
                                
                                let refreshAlert = createAlertMessageOrange(title: "Atención", message: "Error al cargar información, intente más tarde", preferredStyle: UIAlertController.Style.alert)
                            
                                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                
                                self.launcpolizas()
                            }))
                            
                            self.present(refreshAlert, animated: true)
                            }
                            
                        }//, completion: nil)
                    })
                    }
                 } else {
                 }
             }else {
                // parse the result as JSON, since that's what the API provides
                 do {
                    guard (try JSONSerialization.jsonObject(with: responseData!,
                                                            options: []) as? [String: Any]) != nil else {
                    return
                 }
                                        
                    DispatchQueue.main.async {

                        let backServiceName = Notification.Name("backServiceName")
                        NotificationCenter.default.post(name: backServiceName, object: nil)

                        let refreshAlert = createAlertMessageOrange(title: "Atención", message: "Error al cargar información, intente más tarde", preferredStyle: UIAlertController.Style.alert)
                    
                        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        
                        self.launcpolizas()
                    }))
                    
                    self.present(refreshAlert, animated: true)
                    }
                 } catch  {
                 }
            }
         }
         }
         task.resume()
    }

//enviar odometro monthly-----------------------------------------------
    func  sendReportOdometer(){
        let cadena = odometro
        banderacuponesvaca = false
        banderacuponesrefe = false

        // to base64 => yhis is going to be in the thread to send photos
        //open alert to sincronizar
        openloading(mensaje: "Subiendo información...")

        let todosEndpoint: String = "\(ip)ReportOdometer/"
        let tok = arreglo[self.rowsel]["token"]!

        guard let todosURL = URL(string: todosEndpoint) else {
            return
        }
        
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "POST"
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        todosUrlRequest.addValue(tok, forHTTPHeaderField: "Authorization")

        let datainter: [String: Any] = ["PolicyId":arregloPolizas[self.rowsel]["idpoliza"]!,"PolicyFolio":arregloPolizas[self.rowsel]["nopoliza"]!,"Odometer":cadena,"ClientId":arregloPolizas[self.rowsel]["idcliente"]!]
        let newTodo: [String: Any] = ["Type": "1","ImageItem":datainter]
        let headerss: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : tok
        ]
        
        let jsonTodo: Data
        //var jsonString = ""
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            todosUrlRequest.httpBody = jsonTodo
            
            //jsonString = NSString(data: jsonTodo, encoding: String.Encoding.utf8.rawValue)! as String
        } catch {
            return
        }
        
        AF.request(todosEndpoint, method: .post, parameters: newTodo, encoding: JSONEncoding.default, headers: headerss, interceptor: nil, requestModifier: nil).responseJSON { (response) in

            if response.error != nil{
                DispatchQueue.main.async {
                    let backServiceName = Notification.Name("backServiceName")
                    NotificationCenter.default.post(name: backServiceName, object: nil)
                    
                    self.alertaloadingodo.dismiss(animated: true, completion: {
                        let refreshAlert = createAlertMessageOrange(title: "Atención", message: "Tenemos problemas para reportar, intente más tarde.", preferredStyle: UIAlertController.Style.alert)
                        
                        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                            
                            //self.dismiss(animated: true, completion: {
                            self.returntoodometer()
                            //})
                        }))
                        self.present(refreshAlert, animated: true)
                    })
                }
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
                            DispatchQueue.main.async {
                                self.alertaloadingodo.dismiss(animated: true, completion: {
                                    
                                    if json.count == 1{
                                        //recupera mensaje de error
                                        guard let error = json["Message"] as? String else{
                                            return
                                        }
                                        //let error = json["Message"].description
                                                                                                            
                                        let backServiceName = Notification.Name("backServiceName")
                                        NotificationCenter.default.post(name: backServiceName, object: nil)

                                        let refreshAlert = createAlertMessageOrange(title: "Atención", message: error, preferredStyle: UIAlertController.Style.alert)
                                        
                                        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                            
                                            //self.dismiss(animated: true, completion: {
                                            self.returntoodometer()
                                            //})
                                        }))
                                        self.present(refreshAlert, animated: true)
                                    }else{
                                        
                                        let backServiceName = Notification.Name("backServiceName")
                                        NotificationCenter.default.post(name: backServiceName, object: nil)

                                        let refreshAlert = createAlertMessageOrange(title: "Atención", message: "Tenemos problemas para reportar, intente más tarde.", preferredStyle: UIAlertController.Style.alert)
                                    
                                        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                        
                                        //self.dismiss(animated: true, completion: {
                                        self.returntoodometer()
                                        //})
                                    }))
                                    self.present(refreshAlert, animated: true)
                                    }
                                })
                            }
                        }
                        else
                        {
                            if json.count == 1{
                                //recupera mensaje de error
                                guard let error = json["Message"] as? String else{
                                    return
                                }
                                DispatchQueue.main.async {
    
                                    self.alertaloadingodo.dismiss(animated: true, completion: {
    
                                        let backServiceName = Notification.Name("backServiceName")
                                        NotificationCenter.default.post(name: backServiceName, object: nil)
    
                                        let refreshAlert = createAlertMessageOrange(title: "Atención", message: error, preferredStyle: UIAlertController.Style.alert)
    
                                        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
    
                                            //self.dismiss(animated: true, completion: {
                                            self.returntoodometer()
                                            //})
                                        }))
                                        self.present(refreshAlert, animated: true)
                                    })
                                }
                            }else{
    
                                //intentemos ller el arreglo de cupines
                                var feefinal = 0.0
                                var basemensual = 0.0
                                var odometrofinalnuevo = 0
                                var odometrofinalanterior = 0
                                var promo = 0.0
                                var ivadp = 0.0
                                var cantidadderecorridos = 0
                                var ivabasemensual = 0.0
                                var dereccc = 0.0
    
                                var tarifnaneta = 0.0
                                var ivaneta = 0.0
                                var parametrotopekms = 0.0
    
                                var kmsdescuento = 0
    
                                //let cupones = JSON(json["Cupons"])
                                guard let cupones = json["Cupons"] as? [[String : Any]] else{
                                    return
                                }
                                if cupones.count == 0{
                                    //no hay cupones, ni existe, vamonos
                                }
                                else if cupones.count != 0 {
                                    for item in cupones{
                                        guard let type = item["Type"] as? Int else{
                                            return
                                        }
                                        switch type{
                                        case 3:
                                            banderacuponesvaca = true
                                            if let data = item["Kms"] as? Int{
                                                kmscuponlimite = data
                                            }
                                            break
                                        case 2:
                                            banderacuponesrefe = true
                                            if let data = item["Kms"] as? Int{
                                                kmscupon = data
                                            }
                                            if let data = item["Amount"] as? Double{
                                                valorcuponrefe = data
                                            }
                                            break
                                        case 1:
                                            banderacuponesrefe = true
                                            if let data = item["Kms"] as? Int{
                                                kmscupon = data
                                            }
                                            if let data = item["Amount"] as? Double{
                                                valorcuponrefe = data
                                            }
                                            break
                                        default:
                                            break
                                        }
                                    }
                                }
    
                                guard let rateList = json["Parameters"] as? [[String : Any]] else{
                                    return
                                }
                                guard let totalmestemp = json["Amount"] as? Double else{
                                    return
                                }
                                totalapagarlast = String(totalmestemp)
                                for item in rateList{
                                    guard let name = item["Name"] as? String else{
                                        return
                                    }
                                    
                                    switch name{
                                    case "Fee":
                                        if let data = item["Amount"] as? Double{
                                            basemensual = data
                                        }
                                        break
                                    case "tarifa":
                                        if let data = item["Amount"] as? Double{
                                            feefinal = data
                                        }
                                        break
                                    case "kilometroAct":
                                        if let data = item["Amount"] as? Int{
                                            odometrofinalnuevo = data
                                        }
                                        break
                                    case "kilometroReg":
                                        if let data = item["Amount"] as? Int{
                                            odometrofinalanterior = data
                                        }
                                        break
                                    case "promocion":
                                        if let data = item["Amount"] as? Double{
                                            promo = data
                                        }
                                        break
                                    case "KmCobrado":
                                        if let data = item["Amount"] as? Int{
                                            cantidadderecorridos = data
                                        }
                                        break
                                    case "IVA":
                                        if let data = item["Amount"] as? Double{
                                            ivaneta = data
                                        }
                                        break
                                    case "TarifaNeta":
                                        if let data = item["Amount"] as? Double{
                                            tarifnaneta = data
                                        }
                                        break
                                    case "FIva":
                                        if let data = item["Amount"] as? Double{
                                            ivabasemensual = data
                                        }
                                        break
                                    case "IT":
                                        if let data = item["Amount"] as? Double{
                                            ivaneta = data
                                        }
                                        break
                                    case "IDP":
                                        if let data = item["Amount"] as? Double{
                                            ivadp = data
                                        }
                                        break
                                    case "DerechoPolizaNeto":
                                        if let data = item["Amount"] as? Double{
                                            dereccc = data
                                        }
                                        break
                                    case "DerechoPoliza":
                                        if let data = item["Amount"] as? Double{
                                            dereccc = data
                                        }
                                        break
                                    case "parametro_tope_kms":
                                        if let data = item["Amount"] as? Double{
                                            parametrotopekms = data
                                        }
                                        break
                                    case "KmsDescuento":
                                        if let data = item["Amount"] as? Int{
                                            kmsdescuento = data
                                        }
                                        break;
                                    default:
                                        break
                                    }
                                }
    
                                derechopolizad = String(dereccc + ivadp)
                                basemeslast = String(basemensual + ivabasemensual)
                                promolast = String(promo)
                                tarifaporkmlast = String(feefinal)
    
                                odometroanteriorlast = String(odometrofinalanterior)
                                odometroaactuallast = String(odometrofinalnuevo)
                                kilometrosrecorridoslast = String(cantidadderecorridos)
    
                                tarifaneeeta = String(ivaneta + tarifnaneta)
    
                                fiva = String(ivabasemensual)
                                ivait = String(ivaneta)
                                ivaderecho = String(ivadp)
    
                                parametro_tope_kms = parametrotopekms
    
                                DispatchQueue.main.async {
                                    self.alertaloadingodo.dismiss(animated: true, completion: {
    
                                        //validamos si viene condonacion;
                                        if kmsdescuento != 0 {
                                            //show alert with data
                                            let bundle = Bundle(for: CondonacionViewController.self)
                                            let storyboard = UIStoryboard(name: "Ticket", bundle: bundle)
                                            let myAlert = storyboard.instantiateViewController(withIdentifier: "CondonacionViewController") as! CondonacionViewController
    
                                            myAlert.kmsdescuentovalor = kmsdescuento
    
                                            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    
                                            self.present(myAlert, animated: true, completion: nil)
                                        }else if banderacuponesvaca || banderacuponesrefe{
                                            //show alert with data
                                            let bundle = Bundle(for: CuponesViewController.self)
                                            let storyboard = UIStoryboard(name: "Ticket", bundle: bundle)
                                            let myAlert = storyboard.instantiateViewController(withIdentifier: "CuponesViewController") as! CuponesViewController
                                            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    
                                            self.present(myAlert, animated: true, completion: nil)
                                        }
                                        else {
                                            //ojo con cupones referidos
                                            //show alert with data
                                            let bundle = Bundle(for: TicketNormalViewController.self)
                                            let storyboard = UIStoryboard(name: "Ticket", bundle: bundle)
                                            let myAlert = storyboard.instantiateViewController(withIdentifier: "TicketNormalViewController") as! TicketNormalViewController
    
                                            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    
                                            self.present(myAlert, animated: true, completion: nil)
                                        }
                                    })
                                }
                            }
                        }
                        break
                    } catch {
                    }
                    
                    break
                case .failure( _):
                    DispatchQueue.main.async {
                        let backServiceName = Notification.Name("backServiceName")
                        NotificationCenter.default.post(name: backServiceName, object: nil)
                        
                        self.alertaloadingodo.dismiss(animated: true, completion: {
                            let refreshAlert = createAlertMessageOrange(title: "Atención", message: "Tenemos problemas para reportar, intente más tarde.", preferredStyle: UIAlertController.Style.alert)
                            
                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                
                                //self.dismiss(animated: true, completion: {
                                self.returntoodometer()
                                //})
                            }))
                            self.present(refreshAlert, animated: true)
                        })
                    }
                    break
                }
            }
        }
    }

//loading-------------------------------------------------------------------
    func openloading(mensaje: String){
        
        alertaloadingodo.view.tintColor = UIColor.black
        //CGRect(x: 1, y: 5, width: self.view.frame.size.width - 20, height: 120))
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:10, y:5, width:50, height:50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alertaloadingodo.view.addSubview(loadingIndicator)
        present(alertaloadingodo, animated: true, completion: nil)
    }

//elaunch polizas-------------------------------------------------------------
    @objc func launcpolizas(){
        //launch view to confirm odometer
        actualizar = "1"
        //TODO: - Back to polizas
        self.dismiss(animated: false, completion: {
            NotificationCenter.default.post(name: self.back_polizas, object: nil)
            NotificationCenter.default.post(name: reloadData, object: nil)
        })
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
    
//regresa a doometro-----------------------------------------------------------
    @objc func returntoodometer(){
        //launch view to confirm odometer
        
        /*let odometerview = self.storyboard?.instantiateViewController(withIdentifier: "confirmOdo") as! ConfirmOdometerViewController
        //openview
        self.present(odometerview, animated: true, completion: nil)
        */
        
        //TODO: - pop to set again odometer...
        actualizar = "1"
        self.dismiss(animated: false, completion: {
            NotificationCenter.default.post(name: self.back_odometer, object: nil)
            NotificationCenter.default.post(name: reloadData, object: nil)
        })
        
        //self.navigationController?.popViewController(animated: true)

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

