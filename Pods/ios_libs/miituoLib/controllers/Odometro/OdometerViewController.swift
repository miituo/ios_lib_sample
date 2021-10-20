//
//  OdometerViewController.swift
//  miituoLib
//
//  Created by MACBOOK on 12/11/20.
//

import UIKit
import Alamofire
import CoreData
import Photos

class OdometerViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate  {

    // d@IBOutlet var leftItemButton: UIBarButtonItem!
    @IBOutlet var imageodometer: UIImageView!
    @IBOutlet var openCamera: UIButton!
    @IBOutlet var buttonNoTengoAuto: UIButton!
    
    @IBOutlet weak var loadingView: CircularProgressView!
    @IBOutlet weak var imageFinish: UIImageView!

    var picker2 = UIImagePickerController()
    var odometrofinal = ""
    var datareturned = [String:String]()
    var rowsel = 0;
    
    //var detector: GMVDetector? = nil
    let manager = DataManager.shared
    
    let alertaloading = UIAlertController(title: "Registro de odómetro", message: "Subiendo imagen...", preferredStyle: .alert)
    let alertaloadingfotos = UIAlertController(title: "", message: "Procesando...", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        imageodometer.isUserInteractionEnabled = true
        imageodometer.addGestureRecognizer(tapGestureRecognizer)

        rowsel = Int(valueToPass)!
        _ = arregloPolizas[rowsel]["idpoliza"]! as String

        odometerflag = 0
        buttonNoTengoAuto.isHidden = true
        
        //muestro mensjae para camino canncelacion voluntaria sin foto
        if banderaCancelacion == 1{
            banderaCancelacion = 0
            buttonNoTengoAuto.isHidden = false
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        if flagScan == true{
            flagScan = false

            //set picture loaded
            let pliza = arregloPolizas[rowsel]["nopoliza"]! as String
            let fileManager = FileManager.default
            let filename = getDocumentsDirectory().appendingPathComponent("odometro_\(pliza).png")
            if fileManager.fileExists(atPath: filename.path){
                let image = UIImage(contentsOfFile: filename.path)
                imageodometer.layer.cornerRadius = 10.0
                //imagencarro.transform = imagencarro.transform.rotated(by: CGFloat(Double.pi/2))
                imageodometer.layer.masksToBounds = true
                imageodometer.image = image
                odometerflag = 1

                openCamera.setTitle("Continuar", for: .normal)
                
            } else {
            }
        }
    }
    
    @IBAction func closeW(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
        self.launcpolizas()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            var data : String = ""
            
            if let polizaid = arregloPolizas[rowsel]["idpoliza"]{
                data += "\(polizaid),"
            }
            if let polizafolio = arregloPolizas[rowsel]["nopoliza"]{
                data += "\(polizafolio)"
            }
                        
            picker2.delegate = self
            picker2.sourceType = UIImagePickerController.SourceType.camera
            picker2.allowsEditing = true
            
            self.present(picker2, animated: true)
        } else {
        }
    }
    
    //Get image from camera...
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        //picker2.dismiss(animated: true, completion: nil)
        picker2.dismiss(animated: true, completion: {
            let imagenFotoTemp = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            if let imageToRead = imagenFotoTemp {
                self.imageodometer.image = imageToRead
                // imageFinal//info[UIImagePickerControllerOriginalImage] as? UIImage

                odometerflag = 1
                
                // Saved successfully!
                //UIImagePNGRepresentation(imageodometer.image!)
                if let data = self.imageodometer.image!.jpegData(compressionQuality: 1.0) {
                    let polizatemp = arregloPolizas[self.rowsel]["nopoliza"]!
                    let filename = self.getDocumentsDirectory().appendingPathComponent("odometro_\(polizatemp).png")
                    do{
                        try data.write(to: filename)
                    }catch {
                    }
                
                }
                self.openCamera.setTitle("Continuar", for: .normal)
            }
        })
    }

    func getDocumentsDirectory() -> URL {
        //let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
//************************ launcho camera************************************//
    @IBAction func listoOdometer(_ sender: Any) {
        if odometerflag == 1 {
            let imagennn = imageodometer.image
            var idpic = "5"
            if tipoodometro == "cancela"{
                idpic = "6"
            }else{
                idpic = "5"
            }
            sendimagenesdataarraya(imagenn: imagennn!,idpic: idpic)
            
        }else {
            showmessage(message: "Capturar foto de tu odometro para continuar", controller: self)
        }
    }

//Generate boundary
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }

//************************ send image to WS*********************************//
    func sendimagenesdataarraya(imagenn:UIImage, idpic:String) {
        
        self.loadingView.isHidden = false
        self.imageodometer.alpha = 0.5
        self.openCamera.alpha = 0.5
        self.openCamera.isEnabled = false
        
        //compress image
        let comrimidad = compressImage(image: imagenn)
        let tok = arreglo[self.rowsel]["token"]!

        //prueba alamorife
        //let boundary = generateBoundaryString()
        
        let parameters = [
            "Type": idpic,
            "PolicyId":arregloPolizas[rowsel]["idpoliza"]!,
            "PolicyFolio":arregloPolizas[rowsel]["nopoliza"]!,
            "AppOdometer" : "0",
            "Lat" : latitude.description,
            "Lng" : longitude.description,
            "AppZipCode" : locationZipCodeToCamera
            ]
        as [String : Any]
        
        var data : String = ""
        data += "\(idpic),"
        
        if let polizaid = arregloPolizas[rowsel]["idpoliza"]{
            data += "\(polizaid),"
        }
        if let polizafolio = arregloPolizas[rowsel]["nopoliza"]{
            data += "\(polizafolio)"
        }
        
        let head : HTTPHeaders = ["Authorization": tok,"Content-Type":"application/json"]
        
        self.loadingView.setProgressWithAnimation(duration: 1.0, value: 1.0)
        
        //Alamofire to upload image
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(comrimidad, withName: "image",fileName: "file\(idpic).jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }//ImageSendProcess/AutoRead
        //},to:"\(ip)ImageSendProcess/Array/",headers:head)
        },to:"\(ip)ImageSendProcess/AutoRead",headers:head).responseJSON
        { (response) in
            
            if response.error != nil {
                self.launch_alert()
                
            } else {
                switch response.result {
                    
                case .success(let data):
                    //let entero = data
                    do{
                        
                        _ = try response.result.get()
                        if (data as? [Int]) != nil {
                            enterosFoto = data as? [Int]
                            self.launch_odometer()
                        }else if (data as? Int) != nil{
                            self.launch_odometer()
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

//************************ compress image****************************//
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

//************************ launch amcraimage***************************//
    @IBAction func cameraLaunch(_ sender: Any) {
        
        if odometerflag == 1{
            let imagennn = imageodometer.image
            var idpic = "5"
            if tipoodometro == "cancela"{
                idpic = "6"
            }else{
                idpic = "5"
            }

            sendimagenesdataarraya(imagenn: imagennn!,idpic: idpic)
        }else {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker2.delegate = self
                picker2.sourceType = UIImagePickerController.SourceType.camera
                picker2.allowsEditing = true
                
                self.present(picker2, animated: true)
            } else {
            }
            
        }
    }

//************************ lauch polzas********************************//
    func launcpolizas(){
        actualizar = "1"
        NotificationCenter.default.post(name: reloadData, object: nil)
        self.navigationController?.popToRootViewController(animated: true)
        
        //launch view to confirm odometer
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let myAlert = storyboard.instantiateViewController(withIdentifier: "reveal") as! SWRevealViewController
//
//        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//
//        //launch second view with data - show table and polizas
//        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "polizas") as! PolizasViewController
//        self.present(myAlert, animated: true, completion: nil)
    }
    
//************************ launch odometer WS*******************************//
    func launch_alert() {
        
        let backServiceName = Notification.Name("backServiceName")
        NotificationCenter.default.post(name: backServiceName, object: nil)
        
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
            self.imageodometer.alpha = 1.0
            self.openCamera.isEnabled = true
            self.openCamera.alpha = 1.0
            //self.alertaloading.dismiss(animated: true, completion: {
                
                let refreshAlert = createAlertMessageOrange(title: "Odómetro", message: "Error al enviar odómetro. Intente más tarde.", preferredStyle: UIAlertController.Style.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in

                    self.launcpolizas()

                }))
                
                self.present(refreshAlert, animated: true)
            //})
        }
    }

//MARK: - Add image to Library
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = createAlertMessageOrange(title: "Tuvimos un problema al guardar la imagen. Intenta màs tarde.", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = createAlertMessageOrange(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
//****************** launch odometer WS**********************************//
    func launch_odometer() {
        //Lanzamos siguiente odometro
        DispatchQueue.main.async {
                        
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {

                self.imageFinish.alpha = 1
                self.imageFinish.bounds.size.width += 60.0
                self.imageFinish.bounds.size.height += 60.0
            }) { _ in

                self.imageFinish.alpha = 0
                self.loadingView.isHidden = true
                self.imageodometer.alpha = 1.0
                self.openCamera.alpha = 1.0
                self.openCamera.isEnabled = true
                let myAlert = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmOdometerViewController") as! ConfirmOdometerViewController
                self.navigationController?.pushViewController(myAlert, animated: true)
            }
            //self.alertaloading.dismiss(animated: true, completion: {
                
                //let storyboard = UIStoryboard(name: "Odometer", bundle: nil)
                
            //})
        }
    }

//************************ launch no tengo foto view****************************//
    @IBAction func noTengoAuto(_ sender: Any) {
        getTarifaYDias()
    }

//***************************update status poliza*****************************
    func getTarifaYDias(){
        
        alertaloadingfotos.view.tintColor = UIColor.black
        //CGRect(x: 1, y: 5, width: self.view.frame.size.width - 20, height: 120))
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:10, y:5, width:50, height:50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating()
        
        alertaloadingfotos.view.addSubview(loadingIndicator)
        //alertaloading.show(self, sender: nil)
        self.present(alertaloadingfotos, animated: true, completion: nil)
        
        callFunciongetTarifa()
    }
    
//enviar odometro cancelation-----------------------------------------
    func callFunciongetTarifa(){
        _ = odometro

        let api = "\(ip)ReportOdometer/PreviewSaveReport/"
        let tok = arreglo[self.rowsel]["token"]!
        
        let datainter: [String: Any] = ["PolicyId":arregloPolizas[self.rowsel]["idpoliza"]!,"PolicyFolio":arregloPolizas[self.rowsel]["nopoliza"]!,"Odometer":"0","ClientId":arregloPolizas[self.rowsel]["idcliente"]!]
        let parametros: [String: Any] = ["Type": "6","ImageItem":datainter]
        // call api to get vehicle type data

        let headerss: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : tok
        ]
        
        AF.request(api,method:.post,parameters:parametros,encoding:JSONEncoding.default, headers: headerss).responseJSON() { response in
            
            if response.error != nil{
                DispatchQueue.main.async {
                    self.alertaloadingfotos.dismiss(animated: true) {
                        
                    }
                }
            }else{
                switch response.result {
                    
                case .success(let value):
                    if let json = value as? [String: Any] {
                        
                        guard let rateList = json["ResulList"] as? [[String : Any]] else{
                            return
                        }
                        //idCotizacion = json["Id"].description

                        for item in rateList{
                            
                            //var kms = 0.0
                            //var dias_sin_reporte = 0
                            if let kms = item["amount"] as? Double{
                                amount = kms
                            }
                            else {
                                //kms = 0.0
                                amount = 0.0
                            }
                            if let dias_sin_reporte = item["Dias_sin_reportar"] as? Int{
                                dias_reporte = dias_sin_reporte
                            }
                            else {
                                //dias_sin_reporte = 0
                                dias_reporte = 0
                            }
                        }

                        DispatchQueue.main.async {

                            self.alertaloadingfotos.dismiss(animated: true, completion: {
                                
                                let storyboard = UIStoryboard(name: "Cancelacion", bundle: nil)
                                let odometerview = storyboard.instantiateViewController(withIdentifier: "CancelacionAvisoViewController") as! CancelacionAvisoViewController
                                odometerview.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                odometerview.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

                                //openview
                                self.present(odometerview, animated: true, completion: nil)
                            })
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.alertaloadingfotos.dismiss(animated: true) {
                                self.launch_alert()
                            }
                        }
                    }
                case .failure( _):
                    DispatchQueue.main.async {
                        self.alertaloadingfotos.dismiss(animated: true) {
                            self.launch_alert()
                        }
                    }
                    //return error
                }
            }
        }
    }
    
//************************ launch odometer WS***************************//
    func saveDataBack(foto: Int,parameters:String,link:String) {
        DispatchQueue.main.async {
            self.launcpolizas()
        }
    }
    
//************************ launch odometer WS***************************//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "backpolizas"{
//            if flagSimulacion || flagProyeccion{
//                dismiss(animated: true, completion: nil)
//            }
//        }
//        if segue.identifier == "takepicture"{
//            if #available(iOS 11.0, *) {
//                let vc = segue.destination as! TakeProductPhotoController
//                vc.rowsel = sender as? Int
//                flagScan = true
//            } else {
//                // Fallback on earlier versions
//            }
//        }
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
