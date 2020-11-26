//
//  DataManager.swift
//  miituoLib
//
//  Created by John Alexis Cristobal Jimenez  on 11/11/20.
//

import Foundation
import CoreData
import Alamofire
//import SwiftyJSON

class DataManager{

    static let shared = DataManager()
    var tokensecured = ""
    var tokensecuredAna = ""
    var idsimulacion = ""
    var value : NSDictionary? = nil
    var jsonPolizas: AnyObject?

    private init(){
        
    }
    
    func getDataClient(telefono:String, ip:String, completion: @escaping (AnyObject) -> Void){
        
        //use thread to async this action
        let url = URL(string: "\(ip)InfoClientMobil/Celphone/"+telefono)!
        
        let session = URLSession.shared
        let loadTask = session.dataTask(with: url){
            (data,response,error) in
            if error != nil {
                completion("error" as AnyObject)
            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode == 200{
                        if let str = String(data: data!, encoding: String.Encoding.utf8) {
                            valordevuelto = str
                            
                            if str == "null" || str == "[]"{
                                completion("null" as AnyObject)
                            }
                            else {
                                sinpolizas = 0
                                
                                UserDefaults.standard.setValue(telefono, forKey: "celular")
                                
                                if let urlContent = data{
                                    do {
                                        let json = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                        
                                        guard json.value(forKey: "Client") != nil else{
                                            throw(("client" as AnyObject) as! Error)
                                        }
                                        
                                        tienepolizas = "si"
                                        jsoncorrecto = "1"
                                        self.jsonPolizas = json
                                        
                                        let resp = self.saveCoreData(json: json, telefon: telefono)
                                        completion(resp as AnyObject)
                                    } catch {
                                        completion("error" as AnyObject)
                                    }
                                    
                                }else{
                                    completion("error" as AnyObject)
                                }
                            }
                        } else {
                            completion("error" as AnyObject)
                        }
                    }else{
                        //catch error to log
                        // parse the result as JSON, since that's what the API provides
                        do {
                            guard let receivedTodo = try JSONSerialization.jsonObject(
                                    with: data!,
                                    options: []) as? [String: Any] else {
                                
                                return
                            }
                            jsoncorrecto = "0"
                            //Disparamos error y regresamos a polzias
                            //Disparamos error y regresamos a polzias
                            let mess = receivedTodo["Message"] as! String
                            completion(mess as AnyObject)                            
                        } catch  {
                            completion("error" as AnyObject)
                            return
                        }
                    }
                }
            }
        }
        loadTask.resume()
    }

/*********************** save hotos********************************/
    func savePhotos(json: AnyObject, telefon: String) -> String{
        
        //get data from client....
        let cliente = json.value(forKey: "Client") as! NSArray
        
        //forach to get all tjhe polizas here :) ***************************************
        totalfotos = cliente.count
        for index in 0...cliente.count-1 {
            
            let polizas = json.value(forKey: "Policies") as! NSArray
            let poli = polizas[index] as! NSDictionary
            _ = cliente[index] as! NSDictionary
            //now the turn os for polizas
            let noolizasss = (poli["NoPolicy"] as! String).description
            _ = (poli["Id"] as! Int).description
            //var tokene = ""
//            if (cli["Token"] as? String) != nil{
//                tokene = (cli["Token"] as! String).description
//            }
            
            // ----------------- get image from web service if not exists ------
            let pliza = noolizasss
            let fileManager = FileManager.default
            let filename = getDocumentsDirectory().appendingPathComponent("frontal_\(pliza).png")
            if !(fileManager.fileExists(atPath: filename.path)) && (poli["HasVehiclePictures"] as! Bool){
                
                fotoscantidad += 1
                //bandera fotos -- si es true entonecs al menos una foto no esta en la app
                banderafotos = true
                //recuoeramos imagen llamando a WS y guardamos en App
                //getImage(polizid: idpolizzz,polizatemp: pliza, tok:tokene)
            }else{
                
            }
        }//Fin del for...
        
        //todas las fotos existen...lanzo polizas...
        if banderafotos == false{
            let tokenaqui = self.isKeyPresentInUserDefaults(key:"sesion")
            if tokenaqui != false{
                return "session"
            }
            else{
                return "sms"
            }
        }else{
            return "ok"
        }
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }

//*******************Function to get image with id***************************
    func getImage(polizid: String, polizatemp: String ,tok:String){
        
        //let url = URL(string: "\(ip)ImageSendProcess/GetFrontImageCarApp/"+polizid)!
        let todosEndpoint: String = "\(ip)ImageSendProcess/GetFrontImageCarApp/"+polizid
        
        guard let todosURL = URL(string: todosEndpoint) else {
            return
        }
        
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "GET"
        todosUrlRequest.addValue(tok, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared;
        let loadTask = session.dataTask(with: todosUrlRequest){(data,response,error) in
            if error != nil {
                //showmessage(message: "Error de conexiòn... \(error)", controller: self)
            } else {
                if let httpResponse = response as? HTTPURLResponse {

                    if httpResponse.statusCode == 200{
                        if let str = String(data: data!, encoding: String.Encoding.utf8) {
                            valordevuelto = str
                            
                            if let urlContent = data {
                                //do{
                                    //let json = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                    if let decodedData = Data(base64Encoded: urlContent, options: .ignoreUnknownCharacters) {
                                        let image = UIImage(data: decodedData)
                                        
                                        if let data = image!.pngData() {
                                            
                                            //let polizatemp = arregloPolizas[self.rowsel]["nopoliza"]!
                                            let filename = getDocumentsDirectory().appendingPathComponent("frontal_\(polizatemp).png")
                                            try? data.write(to: filename)
                                            
                                        }
                                    }
                                //} catch {
                                    //showmessage(message: "Error en JSON token.", controller: self)
                                //}
                            }
                        }
                    } else {
                        return
                    }
                }
            }
        }
        loadTask.resume()
    }
    
/*********************** launch polizas**************************************/
    func saveCoreData(json: AnyObject, telefon: String) -> String {
        
        arreglo = [[String:String]]()
        arregloPolizas = [[String:String]]()
        arreglocarro = [[String:String]]()
        
        //store do core data
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //var context : NSManagedObjectContext? = nil
        //let context : NSManagedObjectContext? = Storage.shared.context
                
        //let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        //privateMOC.parent = context
        
        //privateMOC.perform {
        //do{
            //get data from client....
            let cliente = json.value(forKey: "Client") as! NSArray
            
            //forach to get all tjhe polizas here :) ************************
            
            for index in 0...cliente.count-1{
                
//***** - Data de cliente ****************************************************
                var tempdict = [String:String]()
                let cli = cliente[index] as! NSDictionary
                                    
                let idcliente = cli.value(forKey: "Id") as! Int
                tempdict["id"] = String(idcliente)

                //newUser.setValue(idcliente, forKey: "id")
                //managedObject Core Data
                //let noolizasss = (poli["NoPolicy"] as! String).description
                let lastnma = (cli["LastName"] as! String).description
                tempdict["lastname"] = lastnma
                let motherna = (cli["MotherName"] as! String).description
                tempdict["mothername"] = motherna
                let username = (cli["Name"] as! String).description
                tempdict["name"] = username
                nombrecliente = username
                UserDefaults.standard.set(username, forKey: "nombre")

                //newUser.setValue(nameee, forKey: "name")
                var tokene = ""
                if (cli["Token"] as? String) != nil{
                    tokene = (cli["Token"] as! String).description
                }
                tempdict["token"] = tokene
                
                var NameContract = ""
                var CelphoneContract = ""
                if cli["NameContract"] != nil{
                    NameContract = cli["NameContract"] as! String
                }
                tempdict["contraName"] = NameContract

                if cli["CelphoneContract"] != nil{
                    CelphoneContract = cli["CelphoneContract"] as! String
                }
                tempdict["celphone"] = CelphoneContract
                tempdict["contraCel"] = CelphoneContract
                celular = CelphoneContract

                var cupon = ""
                if cli["Cupon"] != nil{
                    cupon = cli["Cupon"] as! String
                }
                tempdict["cupon"] = cupon
                cuponInfo = cupon
                arreglo.append(tempdict)
                
//***** - Data de poliza ****************************************************
                let polizas = json.value(forKey: "Policies") as! NSArray
                let poli = polizas[index] as! NSDictionary
                
                var tempdict2 = [String:String]()
                tempdict2["idcliente"] = String(idcliente)
                
                let noolizasss = (poli["NoPolicy"] as! String).description
                tempdict2["nopoliza"] = noolizasss
                //newPoli.setValue(noolizasss, forKey: "nopoliza")
                
                //fecha limite reporte...
                let dateString = (poli["LimitReportDate"] as! String).description
                let dateFormatter = DateFormatter()
                let localeStr = "us" // this will succeed
                dateFormatter.locale = NSLocale(localeIdentifier: localeStr) as Locale?
                
                if dateString.contains(".") {
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                }else{
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                }
                let s = dateFormatter.date(from:dateString)
                dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                let dateStringfin = dateFormatter.string(from:s!)
                tempdict2["limitefecha"] = dateStringfin
                //newPoli.setValue(s, forKey: "limitefecha")
                
                //fecha vigencia
                let dateStringVigencia = (poli["VigencyDate"] as! String).description
                let dateFormatterVigencia = DateFormatter()
                let localeStrVigencia = "us" // this will succeed
                dateFormatterVigencia.locale = NSLocale(localeIdentifier: localeStrVigencia) as Locale?
                
                if dateStringVigencia.contains(".") {
                    dateFormatterVigencia.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                }else{
                    dateFormatterVigencia.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                }
                let svigencia = dateFormatterVigencia.date(from:dateStringVigencia)
                dateFormatterVigencia.dateFormat = "dd-MM-yyyy HH:mm:ss"
                let dateStringfinvigencia = dateFormatterVigencia.string(from:svigencia!)
                tempdict2["fechavigencia"] = dateStringfinvigencia
                //newPoli.setValue(svigencia, forKey: "fechavigencia")
                
                //newPoli.setValue(idcliente, forKey: "idcliente")
                
                //managedObject Core Data
                let coverage = poli["Coverage"] as! NSDictionary
                tempdict2["coverage"] = coverage["Description"] as? String
                //newPoli.setValue(coverage["Description"], forKey: "coverage")
                
                let insu = poli["InsuranceCarrier"] as! NSDictionary
                tempdict2["insurance"] = insu["Name"] as? String
                //newPoli.setValue(insu["Name"], forKey: "insurance")
                
                if insu["Name"] as! String == "ANA seguros"{
                    tokensecuredAna = tokene
                }else{
                    tokensecured = tokene
                }
                
                let stringodo = (poli["LastOdometer"] as! Int).description
                tempdict2["lastodometer"] = String(stringodo)
                //newPoli.setValue(String(stringodo), forKey: "lastodometer")
                
                var stringmensualidad = 0
                if (poli["Mensualidad"] as? Int) != nil {
                    stringmensualidad = poli["Mensualidad"] as! Int
                }
                tempdict2["mensualidad"] = stringmensualidad.description
                //newPoli.setValue(stringmensualidad, forKey: "mensualidad")
                
                let idpolizzz = (poli["Id"] as! Int).description
                polizaparasms = idpolizzz
                tempdict2["idpoliza"] = idpolizzz
                //newPoli.setValue(idpolizzz, forKey: "idpoliza")
                
                _ = poli["NoPolicy"]
                
                let odometerbool = (poli["HasOdometerPicture"] as! Bool).description
                tempdict2["odometerpie"] = odometerbool
                //newPoli.setValue(odometerbool, forKey: "odometerpie")
                
                let vehiclepool = (poli["HasVehiclePictures"] as! Bool).description
                tempdict2["vehiclepie"] = vehiclepool
                //newPoli.setValue(vehiclepool, forKey: "vehiclepie")
                
                let rattt = (poli["Rate"] as! Double).description
                tempdict2["rate"] = rattt
                //newPoli.setValue(rattt, forKey: "rate")
                
                let reportsta = (poli["ReportState"] as! Int).description
                tempdict2["reportstate"] = reportsta
                //newPoli.setValue(reportsta, forKey: "reportstate")
                
                let pay = (poli["PaymentType"] as! String).description //"AMEX"
                tempdict2["payment"] = pay
                //newPoli.setValue(pay, forKey: "payment")
                
                let state = poli["State"] as! NSDictionary
                tempdict2["state"] = state["Description"] as? String
                //newPoli.setValue(state["Description"], forKey: "state")
                
                if (poli["Tickets"] as? NSNull) != nil{
                    tempdict2["idticket"] = "0"
                    //newPoli.setValue(0, forKey: "idticket")
                }else{
                    let ticket = poli["Tickets"] as! NSArray //as! NSArray
                    
                    if ticket.count == 0{
                        tempdict2["idticket"] = "0"
                        //newPoli.setValue(0, forKey: "idticket")
                    }else{
                        let idticketdic = ticket[0] as! NSDictionary
                        
                        if reportsta == "15" || reportsta == "14" {
                            idticket = (idticketdic["Id"] as! Int)
                            tempdict2["idticket"] = String(idticket)
                            //newPoli.setValue(idticket, forKey: "idticket")
                        }
                    }
                }
                arregloPolizas.append(tempdict2)
                
//***** - Data de vehiculo ****************************************************
                let vehiculo = poli["Vehicle"] as! NSDictionary
                let vei = vehiculo//[0] as! NSDictionary
                var tempdict3 = [String:String]()
                                    
                tempdict3["idpolizas"] = noolizasss
                //newCar.setValue(plizasid, forKey: "idpolizas")
                //managedObject Core Data
                let brand = vei["Brand"] as! NSDictionary
                tempdict3["brand"] = brand["Description"] as? String
                //newCar.setValue(brand["Description"], forKey: "brand")
                
                let capac = String(describing:vei["Capacity"])
                tempdict3["capacidad"] = capac
                //newCar.setValue(capac, forKey: "capacidad")
                tempdict3["color"] = vei["Color"] as? String
                //newCar.setValue(vei["Color"], forKey: "color")
                
                let descrii = vei["Description"] as! NSDictionary
                tempdict3["descripcion"] = descrii["Description"] as? String
                //newCar.setValue(descrii["Description"], forKey: "descripcion")
                
                let modell = vei["Model"] as! NSDictionary
                let modelito = (modell["Model"] as! Int).description
                tempdict3["model"] = modelito
                //newCar.setValue(modelito, forKey: "model")
                tempdict3["plates"] = vei["Plates"] as? String
                //newCar.setValue(vei["Plates"], forKey: "plates")
                
                let subtyoe = vei["Subtype"] as! NSDictionary
                tempdict3["subtype"] = subtyoe["Description"] as? String
                //newCar.setValue(subtyoe["Description"], forKey: "subtype")
                
                let tyype = vei["Type"] as! NSDictionary
                tempdict3["type"] = tyype["Description"] as? String
                //newCar.setValue(tyype["Description"], forKey: "type")
                
                let idc = String(describing:vei["Id"])
                tempdict3["idcarro"] = idc
                //newCar.setValue(idc, forKey: "idcarro")
                arreglocarro.append(tempdict3)

            }
            
            return "ok"
            
//        } catch {
//            return "error"
//            //showmessage(message: "Tuvimos un problema al guardar. Intente más tarde.")
//        }
        //}
    }

//***************Function to send token to ws************************
    func sendToken(telefono: String, ip: String, completion: @escaping (String) -> Void) {

        let todosEndpoint: String = "\(ip)ClientUser/"
        //get info mobile

        let appversion = 8.3
        let datacel = "{\"name\":\"\(UIDevice.current.name)\",\"os\":\"\(UIDevice.current.systemName)\",\"osVersion\":\"\(UIDevice.current.systemVersion)\",\"appVersion\":\(appversion)}"

        token = "TOKEN PRUEBA"

        
        guard let todosURL = URL(string: todosEndpoint) else {
            //throw(("error") as! Error)
            return
            //completion("error")
        }
        
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "PUT"
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        todosUrlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

        if ip.contains("ana"){
            todosUrlRequest.addValue(tokensecuredAna, forHTTPHeaderField: "Authorization")
        }else{
            todosUrlRequest.addValue(tokensecured, forHTTPHeaderField: "Authorization")
        }
        
        //let newTodo: [String: Any] = ["Celphone":"5534959778","Id":"0","Token":"aaaaaaaaaaa"]
        let newTodo: [String: Any] = ["Celphone": telefono, "Token": token, "Id":"0","Datacelphone":datacel]
        //let newTodo: [String: Any] = ["Celphone": telefono, "Token": token, "Id":"0"]
        
        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            _ = NSString(data: jsonTodo, encoding: String.Encoding.utf8.rawValue)
            todosUrlRequest.httpBody = jsonTodo
            
        } catch {
            //throw(("error") as! Error)
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: todosUrlRequest) {
            (data, response, error) in
            guard error == nil else {
                return//completion("error")
            }
            guard let responseData = data else {
                return//completion("error")
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200{
                    if let str = String(data: responseData, encoding: String.Encoding.utf8) {
                        valordevuelto = str
                        completion(str)

                    } else {
                        completion("error")
                    }
                }else{
                    do {
                        guard let receivedTodo = try JSONSerialization.jsonObject(
                                with: responseData,
                                options: []) as? [String: Any] else {
                            return
                        }
                        
                        guard let todoID = receivedTodo["Message"] as? String else {
                            return
                        }
                        valordevuelto = todoID
                        completion(todoID)
                        
                    } catch  {
                        completion("error")
                    }
                }
            }
            
        }
        task.resume()
    }

//*******************Function to get data with the celphone*************/
    func getSms(telefon:String, completion: @escaping (String) -> Void){
        
        flagmensaje = 1
        
        if jsoncorrecto != "0"
        {
            let url = URL(string: "\(ip)TemporalToken/GetTemporalTokenPhone/"+telefon+"/"+polizaparasms!+"/AppToken")!
            let session = URLSession.shared;
            let loadTask = session.dataTask(with: url){(data,response,error) in
                if error != nil {
                    //launchpolizas(vista: vistafrom)
                    completion("error")
                } else {
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200{
                            if let str = String(data: data!, encoding: String.Encoding.utf8) {
                                valordevuelto = str
                                
                                if let urlContent = data{
                                    do{
                                        let json = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                        
                                        let dato = json as! NSArray
                                        tokentemp = dato[0] as? String
                                        completion(tokentemp!)
                                        /*DispatchQueue.main.async {
                                            //DispatchQueue.main.async {
                                            alertaloadingtoken.dismiss(animated: true, completion: {
                                                //launchpolizas(vista: vistafrom)
                                                launchtoken(v: vistafrom)
                                            })
                                        }*/
                                    } catch{
                                        completion("error")
                                        /*alertaloadingtoken.dismiss(animated: true, completion: {
                                            //launchpolizas(vista: vistafrom)
                                            showmessage(message: "Error en JSON token.")
                                        })*/
                                    }
                                }
                            }
                        } else {
                            completion("error")
                            /*alertaloadingtoken.dismiss(animated: true, completion: {
                                //launchpolizas(vista: vistafrom)
                                showmessage(message: "Error al sincronizarte. Contacta a miituo para mayor informaciòn")
                            })*/
                        }
                    }
                }
            }
            loadTask.resume()
        }
    }
    
//============================call methods and load garage data===========
    func getCuponReferido(celphone: String, completion: @escaping ([String]) -> Void){
        
        //let api = "http://apiatlas.netdev.miituo.com/api/Emulation/reportar"
        let api = "\(ip)Cupon/getReferredClientCoupon/\(celphone)"
                
        //let header = ["Content-Type":"application/json"]
        let headerss: HTTPHeaders = [
            "Authorization" : seguidad
        ]
        
        AF.request(
            api,
            method:.get,
            encoding:JSONEncoding.default,
            headers: headerss)
            .responseJSON() { response in
                
                if response.error != nil{
                    completion(["error"])
                }else{
                    switch response.result {
                    case .success(let value):
                        do{
                            let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
                            guard let json = decoded as? [[String:Any]] else{
                                return
                            }
                            
                            if json.count == 0{
                                completion(["error"])
                            }
                            else
                            {
                                guard let data = json[0]["Cupones"] as? [String:Any] else{
                                    completion(["error"])
                                    return
                                }
                                //let data = json[0]["Cupones"]
                                guard let kms = data["Kms"] as? Int else{
                                    completion(["error"])
                                    return
                                }
                                guard let description = data["Description"] as? String else{
                                    completion(["error"])
                                    return
                                }
                                //let description = data["Description"].string
                                completion([description, "\(kms)"])
                            }
                            
                        }catch {
                            completion(["error"])
                        }
                    default:
                        completion(["error"])
                    }
                }

        }
    }    
}
