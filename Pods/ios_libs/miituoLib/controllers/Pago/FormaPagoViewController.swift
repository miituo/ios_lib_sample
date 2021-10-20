//
//  FormaPagoViewController.swift
//  miituoLib
//
//  Created by MACBOOK on 16/11/20.
//

import UIKit
import Alamofire
import WebKit

class FormaPagoViewController: UIViewController {

    @IBOutlet weak var vistaPagoWeb: WKWebView!
    @IBOutlet var bottonOk: UIButton!
    //@IBOutlet var vistaPagoWeb: UIWebView!
    //@IBOutlet weak var vistaPagoWeb: WKWebView!
    
    let loading = UIAlertController(title: "Informaciòn...", message: "Recuperando datos...", preferredStyle: .alert)

    var referenciaPago = ""
    var flagPago = false
    var timer: Timer? = nil
    
    var idpoliza = ""
    var idcliente = ""
    
    var tipoPago = 1
    var tokenCliente = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        idpoliza = arregloPolizas[Int(valueToPass)!]["idpoliza"]!
        idcliente = arreglo[Int(valueToPass)!]["id"]!

        let date = Date().addingTimeInterval(5)
        timer = Timer(fireAt: date, interval: 5, target: self, selector: #selector(verifypayment), userInfo: nil, repeats: true)
        
        tipoPago = 1
        tokenCliente = DataManager.shared.tokensecured
        getTDCPayment(idcliente: idcliente, idpoliza: idpoliza, tipoPago: 1)
    }
    
    
    @IBAction func visaAction(_ sender: Any) {
        tipoPago = 3
        getTDCPayment(idcliente: idcliente, idpoliza: idpoliza, tipoPago: 3)
    }
    
    @IBAction func amexAction(_ sender: Any) {
        tipoPago = 1
        getTDCPayment(idcliente: idcliente, idpoliza: idpoliza, tipoPago: 1)
    }
    
    
    func getTDCPayment(idcliente: String, idpoliza: String, tipoPago: Int){
        showLoading()
        
        //call service
        let api = "\(ip)distancePayment"
                
        let headerss: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : tokenCliente
        ]
        
        let parametros : [String:Any] = [
            "PolicyId":idpoliza,
            "PaymentType": tipoPago
        ]
        
        AF.request(api,method:.post,parameters:parametros,encoding:JSONEncoding.default, headers: headerss).responseJSON { response in
            
            let estatus = response.response?.statusCode
            if estatus != 200{
                self.loading.dismiss(animated: true, completion: nil)
                do{
                    let value = try response.result.get()
                    let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
                    guard let json = decoded as? [String:Any] else{
                        return
                    }
                    //let json = JSON(value)
                    if let data = json["Message"] as? String{
                        let mensaje = data
                        if mensaje != "null"{
                            self.showAlert(mensaje:mensaje)
                        }
                    }
                } catch {
                    return
                }
            }else{
                switch response.result {
                case .success:
                    let jsonDecoder = JSONDecoder()
                    //jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    do {
                        let value = try response.result.get()
                        let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let decodedPayment = try jsonDecoder.decode(DistancePaymentResponse.self, from: jsonData)
                        
                        banderapago = 0
                        if let reference = decodedPayment.reference, let urlpayment = decodedPayment.url {
                            
                            self.referenciaPago = reference
                            if let urldata = URL(string: urlpayment) {
                                let request = URLRequest(url: urldata)
                                self.vistaPagoWeb.load(request)
                            }
                            self.loading.dismiss(animated: true, completion: nil)
                            
                            //despues que lanza...inicio pull para veirifcar pago
                            RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.common)
                        }else{
                            self.loading.dismiss(animated: true, completion: nil)
                        }
                        
                    } catch {
                        print("Error: \(error.localizedDescription)")
                        self.loading.dismiss(animated: true, completion: nil)
                    }
                    
//                    do {
//                        let value = try response.result.get()
//                        let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
//                        let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
//                        guard let json = decoded as? [String] else{
//                            return
//                        }
//                        self.referenciaPago = json[1]
//
//                        banderapago = 0
//
//                        if let urldata = URL(string: json[0].description) {
//                            let request = URLRequest(url: urldata)
//                            self.vistaPagoWeb.loadRequest(request)
//                        }
//                        self.loading.dismiss(animated: true, completion: nil)
//
//                        //despues que lanza...inicio pull para veirifcar pago
//                        RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.common)
//                    } catch {
//                        return
//                    }
                case .failure( _):
                    self.loading.dismiss(animated: true, completion: nil)
                    //return error
                }
            }
        }
    }
    
    @IBAction func backWindow(_ sender: Any) {
        if !flagPago{
            let refreshAlert = createAlertMessageOrange(title: "¿Deseas abandonar el sitio?.", message: "Es posible que los cambios que implementaste no se puedan guardar.", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Si", style: .default, handler: { (action: UIAlertAction!) in
                self.dismiss(animated: true, completion: {
                    self.timer?.invalidate()
                })
            }))
            refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            
            self.present(refreshAlert, animated: true)
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    
//========================verificar pago =====================
    @objc func verifypayment(){
        let api = "\(ip)payment/Searchreference/\(referenciaPago)/\(tipoPago)"
        /*let parametros = [
         "Nombre":"a",
         //"AP":"\(p1)",
         //"AM":"\(m1)",
         //"Fecha_Nacimiento":"\(birthday)"
         ]*/
        
        let headerss: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : seguidad
        ]
        
        DispatchQueue.global(qos: .userInitiated).async {
            // Download file or perform expensive task
            AF.request(api,method:.get,encoding:JSONEncoding.default, headers: headerss).responseJSON() { response in
                let estatus = response.response?.statusCode
                if estatus != 200{
                    //self.bottonOk.isHidden = false
                    
//                    do {
//                        let value = try response.result.get()
//                        let json = JSON(value)
//                        let mensaje = json["Message"].description
//                        if mensaje != "null"{
//                            //self.showAlert(mensaje:mensaje)
//                        }
//                    }catch {
                    //return
//                    }
                }else{
                    self.flagPago = true
                    //self.bottonOk.isHidden = false
                    DispatchQueue.main.async {
                        self.timer!.invalidate()
                        //self.bottonOk.isHidden = false
                        self.showAlertInfo(mensaje: "Cambio de método de pago exitoso")

                        // Update the UI
                        /*self.vistaPersona.isHidden = true
                         self.vistaAuto.isHidden = true
                         self.vistaValidacion.isHidden = true
                         self.vistaPago.isHidden = true
                         self.vistaHecho.isHidden = false*/
                        //self.saveDataLoadContract(tag:0)
                    }
                }
            }
        }
    }
    
    func showAlert(mensaje: String){
        let refreshAlert = createAlertMessageOrange(title: "Atención.", message: mensaje, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
            //self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(refreshAlert, animated: true)
    }
    
    func showAlertInfo(mensaje: String){
        let refreshAlert = createAlertMessageOrange(title: "", message: mensaje, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (action: UIAlertAction!) in
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(refreshAlert, animated: true)
    }
    func showAlertInfoTitle(title:String, mensaje: String){
        let refreshAlert = createAlertMessageOrange(title: title, message: mensaje, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (action: UIAlertAction!) in
            
            //self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(refreshAlert, animated: true)
    }
    func showLoading(){
        loading.view.tintColor = UIColor.black
        //CGRect(x: 1, y: 5, width: self.view.frame.size.width - 20, height: 120))
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:10, y:5, width:50, height:50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        loading.view.addSubview(loadingIndicator)
        present(loading, animated: true, completion: nil)
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

// MARK: - DistancePaymentResponse
struct DistancePaymentResponse: Decodable {
    let payPalResponse: String?
    let url: String?
    let reference, response: String?
    let paymentReference: PaymentReference?

    enum CodingKeys: String, CodingKey {
        case payPalResponse = "PayPalResponse"
        case url = "Url"
        case reference = "Reference"
        case response = "Response"
        case paymentReference = "PaymentReference"
    }
}

// MARK: - PaymentReference
struct PaymentReference: Decodable {
    let isApprovedPayment: Bool?
    let reference: String?
    let policyID, methodPay: Int?
    let nombreProcesador: String?
    //let objectPay: ObjectPay?

    enum CodingKeys: String, CodingKey {
        case isApprovedPayment = "IsApprovedPayment"
        case reference = "Reference"
        case policyID = "PolicyId"
        case methodPay = "MethodPay"
        case nombreProcesador = "NombreProcesador"
        //case objectPay
    }
}

// MARK: - ObjectPay
struct ObjectPay: Decodable {
    let amount: Int?
    let ccNum: String?
    let id: Int?
    let response, aut: String?
    let datePayment: String?
    let referencia, type, error, ccName: String?

    enum CodingKeys: String, CodingKey {
        case amount
        case ccNum
        case id
        case response
        case aut
        case datePayment
        case referencia
        case type
        case error
        case ccName
    }
}
