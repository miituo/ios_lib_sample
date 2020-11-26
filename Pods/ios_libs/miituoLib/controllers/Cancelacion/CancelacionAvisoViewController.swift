//
//  CancelacionAvisoViewController.swift
//  miituoLib
//
//  Created by MACBOOK on 14/11/20.
//

import UIKit
import Alamofire

class CancelacionAvisoViewController: UIViewController {

    var rowsel = 0
    let alertaloading = UIAlertController(title: "Registro de cancelación", message: "Actualizando póliza...", preferredStyle: .alert)
    
    //@IBOutlet var mensajeOdometro: UIWebView!
    //@IBOutlet weak var mensajeOdometro: WKWebView!
    @IBOutlet weak var mensajeOdometro: UIWebView!
    
    @IBOutlet var vistaTabla: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rowsel = Int(valueToPass)!

        vistaTabla.layer.borderWidth = 2.0
        vistaTabla.layer.cornerRadius = 15.0
        let gris = UIColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        vistaTabla.layer.borderColor = gris.cgColor

        let dias = dias_reporte
        let cargo = amount

        let data = "<!DOCTYPE html> " +
            "                <html> \n" +
            "                    <head> \n" +
            "                        <title>TODO supply a title</title> \n" +
            "                        <meta charset=\\UTF-8\\> \n" +
            "                        <meta name=\\viewport\\ content=\\width=device-width, initial-scale=1.0\\> \n" +
            "                        <style type=\"text/css\">\n" +
            "           @font-face {" +
            "    font-family: 'DIN Next Rounded LT Pro';\n " +
            "    src: local('DIN Next Rounded LT Pro'),url('din-next-rounded-lt-pro-regular-591ddce3ae197.otf')\n" +
            "   format('opentype');\n" +
            "   }\n" +
            "  body { font-family: DIN Next Rounded LT Pro; }\n" +
            "       </style>\n" +
            "                    </head> \n" +
            "                    <body> \n" +
            "                        <div> \n" +
            "                            <p align='center' style='font-size:20px;'>" +
            "                            <span style='font-size:16px;'>Han transcurrido <strong>\(dias) días " +
            "                            </strong>desde tu <br> último reporte de odómetro,<br>tu <strong>cargo es de \(cargo)</strong></span>. \n" +
            "                            </p> \n" +
            "                        </div> \n" +
            "                    </body> \n" +
        "                </html>"
        
        mensajeOdometro.loadHTMLString(data, baseURL: nil)
        
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pagarAction(_ sender: Any) {
        //consumir servicio de siempre con odometro en 0
        //enviar foto x de cancelacion
        //en ese momento regresa a polizas y actualizar, ya no debera verse
        let imagen = UIImage(named: "vista_auto_2")
        sendimagenesdataarraya(imagenn: imagen!, idpic: "6")
        
    }
    @IBAction func regresarAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

//************************ compress image**************************************//
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

//************************ compress image*****************************************//
    func compressImage(image:UIImage) -> Data {
        // Reducing file size to a 10th
        
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        //var maxHeight : CGFloat = 450.0
        //var maxWidth : CGFloat = 600.0
        let maxHeight : CGFloat = image.size.height/4//300
        let maxWidth : CGFloat = image.size.width/4//400.0
        
        var imgRatio : CGFloat = actualWidth/actualHeight
        let maxRatio : CGFloat = maxWidth/maxHeight
        //var compressionQuality : CGFloat = 0.8
        
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else{
                actualHeight = maxHeight;
                actualWidth = maxWidth;
                //compressionQuality = 1;
            }
        }
        
        //var rect = CGRect(0.0, 0.0, actualWidth, actualHeight);
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: actualWidth, height: actualHeight));
        UIGraphicsBeginImageContext(rect.size);
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext();
        //let imageData = UIImagePNGRepresentation(img!);
        let imageData = img!.jpegData(compressionQuality: 0.9);
        UIGraphicsEndImageContext();
        
        return imageData!;
    }
    
//************************ send image to WS*********************************//
    func sendimagenesdataarraya(imagenn:UIImage, idpic:String) {
        
        openloading(mensaje: "")
        
        //compress image
        let comrimidad = compressImage(image: imagenn)
        let tok = arreglo[self.rowsel]["token"]!
        
        //prueba alamorife
        //let boundary = generateBoundaryString()
        
        let parameters = ["Type": idpic,"PolicyId":arregloPolizas[rowsel]["idpoliza"] ,"PolicyFolio":arregloPolizas[rowsel]["nopoliza"]]
        //let head = ["Authorization": tok,"Content-Type":"multipart/form-data; boundary=\(boundary)"]
        let head : HTTPHeaders = ["Authorization": tok,"Content-Type":"application/json"]
        
        //Alamofire to upload image
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(comrimidad, withName: "image",fileName: "file\(idpic).jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            },to:"\(ip)ImageSendProcess/Array/",headers:head).responseJSON
        { (response) in
            
            if response.error != nil {
                self.launch_alert()
            }else{
                switch response.result {
                    
                case .success( _):
                    self.ajustaReportOdometer()
                    break
                case .failure( _):
                    self.launch_alert()
                    break
                }
            }
        }
            

    }

//***************************Function to send token to ws*********************************
    func ajustaReportOdometer(){
        
        //open alert to sincronizar
        //openloading(mensaje: "Espere mientras llevámos a cabo el reporte...")
        
        //servicio para actualiza status en UpStateCasification------------------------------------
        getTarifaYDias()
    }

//***************************update status poliza*****************************
    func getTarifaYDias(){
        
        /*alertaloadingfotos.view.tintColor = UIColor.black
        //CGRect(x: 1, y: 5, width: self.view.frame.size.width - 20, height: 120))
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:10, y:5, width:50, height:50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating()
        
        alertaloadingfotos.view.addSubview(loadingIndicator)
        //alertaloading.show(self, sender: nil)
        self.present(alertaloadingfotos, animated: true, completion: nil)*/
        
        callFunciongetTarifa()
    }
    
//***************************update status poliza*****************************
    func callFunciongetTarifa(){
        _ = odometro
        
        let api = "\(ip)ReportOdometer/PreviewSaveReport/"
        let tok = arreglo[self.rowsel]["token"]!
        
        // show dialog loading
        //let progressHUD = ProgressHUD(text: "Recuperando información")
        //vistaloading.isHidden = false
        //vistaloading.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        //vistaloading.addSubview(progressHUD)
        
        //let datainter = ["PolicyId":arregloPolizas[self.rowsel]["idpoliza"],"PolicyFolio":arregloPolizas[self.rowsel]["nopoliza"],"Odometer":"0","ClientId":arregloPolizas[self.rowsel]["idcliente"],"CancelacionVoluntaria":true] as [String : Any]
        let parametros = ["Type": "6","ImageItem":["PolicyId":arregloPolizas[self.rowsel]["idpoliza"]!, "PolicyFolio":arregloPolizas[self.rowsel]["nopoliza"]!, "Odometer":"0","ClientId":arregloPolizas[self.rowsel]["idcliente"]! ,"CancelacionVoluntaria":true]] as [String : Any]
        // call api to get vehicle type data
        
        let headerss: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : tok
        ]
        
        AF.request(api,method:.post,parameters:parametros,encoding:JSONEncoding.default, headers: headerss).responseJSON { response in
            
            if response.error != nil {
                 self.launch_alert()
            } else {
                switch response.result {
                    
                case .success(let value):
                    do{
                        //let json = JSON(value)
                        let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
                        guard let json = decoded as? [String:Any] else{
                            return
                        }
                       
                        guard let rateList = json["ResulList"] as? [[String : Any]] else{
                            return
                        }
                        //idCotizacion = json["Id"].description

                        var cancela = ""
                        var confirm = ""

                        for item in rateList{
                            
                            if let data = (item["ConfirmReport"] as? String) {
                                confirm = data//item.1["ConfirmReport"].description
                            }
                            if let data = (item["Cancel"] as? String) {
                                cancela = data//item.1["Cancel"].description
                            }
                        }
                        
                        //valido banderas
                        if cancela != "false" && confirm != "false"{
                            self.launch_alert()
                        }else{
                        
                        DispatchQueue.main.async {
                            
                                self.alertaloading.dismiss(animated: true, completion: {
                                    let refreshAlert = UIAlertController(title: "Listo", message: "Tu póliza ha sido cancelada.", preferredStyle: UIAlertController.Style.alert)
                                    
                                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                        self.launcpolizas()
                                        
                                        //self.dismiss(animated: true, completion: nil)
                                    }))
                                    
                                    self.present(refreshAlert, animated: true)
                                })
                            }
                        }
                    }catch {
                        self.launch_alert()
                    }
                    break
                case .failure( _):
                    self.launch_alert()
                    break
                }
            }
        }
    }
    
    
    
//************************ launch odometer WS*******************************//
    func launch_alert() {
        DispatchQueue.main.async {
            self.alertaloading.dismiss(animated: true, completion: {
                
                let refreshAlert = UIAlertController(title: "Cancelación", message: "Tuvimos un problema.", preferredStyle: UIAlertController.Style.alert)
                
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
        let bundle = Bundle(for: PolizasViewController.self)
        let storyboard = UIStoryboard(name: "Polizas", bundle: bundle)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "navpolizas") as! UINavigationController
        
        myAlert.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(myAlert, animated: true, completion: nil)
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
