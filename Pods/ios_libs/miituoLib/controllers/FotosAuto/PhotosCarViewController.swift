//
//  PhotosCarViewController.swift
//  miituoLib
//
//  Created by MACBOOK on 12/11/20.
//

import UIKit
import Photos
import CoreData
import Alamofire

var picker = UIImagePickerController()

var base64string:String = ""
var intentos = 0
let alertaloadingodo = UIAlertController(title: "Actualizando...", message: "Subiendo información...", preferredStyle: .alert)

class PhotosCarViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid

    @IBOutlet var derechopic: UIImageView!
    @IBOutlet var frontpic: UIImageView!
    @IBOutlet var izquierdopic: UIImageView!
    @IBOutlet var backpic: UIImageView!
    
    @IBOutlet weak var derechoCompImage: UIImageView!
    @IBOutlet weak var derechoCircularProgress: CircularProgressView!

    @IBOutlet weak var frontCompImage: UIImageView!
    @IBOutlet weak var frontCircularProgress: CircularProgressView!

    @IBOutlet weak var izquierdoCompImage: UIImageView!
    @IBOutlet weak var izquierdoCircularProgress: CircularProgressView!

    @IBOutlet weak var backCompImage: UIImageView!
    @IBOutlet weak var backCircularProgress: CircularProgressView!
    
    var idpolizaParaLog = ""
    
    var imagenselected = 0

    var rowsel = 0;
    let manager = DataManager.shared

    let alertaloading = UIAlertController(title: nil, message: "Subiendo fotos...", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ventana = carros => photos first time
        tipoodometro = "first"

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        let tapGestureRecognizerfront = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        let tapGestureRecognizerrigth = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        let tapGestureRecognizerback = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        //add gesture recogni<ar to get pucter when image clic
        derechopic.isUserInteractionEnabled = true
        derechopic.addGestureRecognizer(tapGestureRecognizer)
        
        frontpic.isUserInteractionEnabled = true
        frontpic.addGestureRecognizer(tapGestureRecognizerfront)

        izquierdopic.isUserInteractionEnabled = true
        izquierdopic.addGestureRecognizer(tapGestureRecognizerrigth)

        backpic.isUserInteractionEnabled = true
        backpic.addGestureRecognizer(tapGestureRecognizerback)
        
        rowsel = Int(valueToPass)!
    }

    //Lanzamos mensaje de alerta para fotos....
    override func viewDidAppear(_ animated: Bool) {
        
        if message == 0 {
            message = 1
            //let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myAlert = self.storyboard!.instantiateViewController(withIdentifier: "MensajeFotosViewController") as! MensajeFotosViewController
            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            
            self.present(myAlert, animated: true, completion: nil)
        }
        
        let bundle = Bundle(for: PhotosCarViewController.self)

        let pliza = arregloPolizas[self.rowsel]["nopoliza"]!
        idpolizaParaLog = arregloPolizas[self.rowsel]["idpoliza"]!
        
        let fileManager = FileManager.default

        let filename = self.getDocumentsDirectory().appendingPathComponent("frontal_\(pliza).png")
        
        if fileManager.fileExists(atPath: filename.path) && frontflag == 1 {
            let imag: UIImage = UIImage(contentsOfFile: filename.path)!
            frontpic.image = imag
            //let comrimidad = self.compressImage(image: image!)
            //if volteado == "0"{
            //volteado = "1"
            //cell.imagecar.transform = cell.imagecar.transform.rotated(by: CGFloat(Double.pi/2))
            //}
        } else {
            let imag: UIImage = UIImage(named: "vista_auto_2.png",in: bundle, compatibleWith: nil)!
            frontpic.image = imag
        }
        
        let filenamederecha = self.getDocumentsDirectory().appendingPathComponent("derecho_\(pliza).png")
        
        if fileManager.fileExists(atPath: filenamederecha.path) && rigthflag == 1 {
            let imag: UIImage = UIImage(contentsOfFile: filenamederecha.path)!
            derechopic.image = imag
            //let comrimidad = self.compressImage(image: image!)
            //if volteado == "0"{
            //volteado = "1"
            //cell.imagecar.transform = cell.imagecar.transform.rotated(by: CGFloat(Double.pi/2))
            //}
        } else {
            let imag: UIImage = UIImage(named: "vista_auto_1.png",in: bundle, compatibleWith: nil)!
            derechopic.image = imag
        }
        
        let filenameizqiuerda = self.getDocumentsDirectory().appendingPathComponent("izquierdo_\(pliza).png")
        if fileManager.fileExists(atPath: filenameizqiuerda.path) && leftflag == 1 {
            let imag: UIImage = UIImage(contentsOfFile: filenameizqiuerda.path)!
            izquierdopic.image =  imag
            //let comrimidad = self.compressImage(image: image!)
            //if volteado == "0"{
            //volteado = "1"
            //cell.imagecar.transform = cell.imagecar.transform.rotated(by: CGFloat(Double.pi/2))
            //}
        } else {
            let imag: UIImage = UIImage(named: "vista_auto_3.png",in: bundle, compatibleWith: nil)!
            izquierdopic.image =  imag
        }
        
        let filenametrasera = self.getDocumentsDirectory().appendingPathComponent("trasero_\(pliza).png")
        if fileManager.fileExists(atPath: filenametrasera.path) && backflag == 1 {
            let imag: UIImage = UIImage(contentsOfFile: filenametrasera.path)!
            
            backpic.image = imag
            //let comrimidad = self.compressImage(image: image!)
            //cell.bookimage.isUserInteractionEnabled = true
            //if volteado == "0"{
            //volteado = "1"
            //cell.imagecar.transform = cell.imagecar.transform.rotated(by: CGFloat(Double.pi/2))
            //}
        } else {
            let imag: UIImage = UIImage(named: "vista_auto_4.png",in: bundle, compatibleWith: nil)!
            backpic.image = imag
            //cell.bookimage.isUserInteractionEnabled = true
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        imagenselected = tappedImage.tag
        
        var data : String = ""
        
        if let polizaid = arregloPolizas[rowsel]["idpoliza"]{
            data += "\(polizaid),"
        }
        if let polizafolio = arregloPolizas[rowsel]["nopoliza"]{
            data += "\(polizafolio)"
        }
        
        if imagenselected == 2 && !fotosfaltantes[0]{
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                //manager.saveDataLog(event: "USER_INTERACTION foto auto_iOS \(imagenselected) id: \(arregloPolizas[rowsel]["idpoliza"]!)", url: "PhotosCarViewController.tomarFoto", input: "", output: "", date: Date(), exeption: "",inshuranceData: arregloPolizas[rowsel]["idpoliza"]!)
                
                //let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = UIImagePickerController.SourceType.camera
                picker.allowsEditing = true
                self.present(picker, animated: true)
            } else {
            }
        }
        
        if imagenselected == 1 && !fotosfaltantes[1]{
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                //manager.saveDataLog(event: "USER_INTERACTION foto auto_iOS \(imagenselected) id: \(arregloPolizas[rowsel]["idpoliza"]!)", url: "PhotosCarViewController.tomarFoto", input: "", output: "", date: Date(), exeption: "",inshuranceData: arregloPolizas[rowsel]["idpoliza"]!)
                
                picker.delegate = self
                picker.sourceType = UIImagePickerController.SourceType.camera
                picker.allowsEditing = true
                self.present(picker, animated: true)
            } else {
            }
        }
        
        if imagenselected == 3 && !fotosfaltantes[3]{
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                //manager.saveDataLog(event: "USER_INTERACTION foto auto_iOS \(imagenselected) id: \(arregloPolizas[rowsel]["idpoliza"]!)", url: "PhotosCarViewController.tomarFoto", input: "", output: "", date: Date(), exeption: "",inshuranceData: arregloPolizas[rowsel]["idpoliza"]!)
                
                picker.delegate = self
                picker.sourceType = UIImagePickerController.SourceType.camera
                picker.allowsEditing = true
                self.present(picker, animated: true)
            } else {
            }
        }
        
        if imagenselected == 4 && !fotosfaltantes[2]{
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                //manager.saveDataLog(event: "USER_INTERACTION foto auto_iOS \(imagenselected) id: \(arregloPolizas[rowsel]["idpoliza"]!)", url: "PhotosCarViewController.tomarFoto", input: "", output: "", date: Date(), exeption: "",inshuranceData: arregloPolizas[rowsel]["idpoliza"]!)
                
                picker.delegate = self
                picker.sourceType = UIImagePickerController.SourceType.camera
                picker.allowsEditing = true
                self.present(picker, animated: true)
            } else {
            }
        }
    }
    
//===============================Save picture========
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        picker.dismiss(animated: true, completion: {
            let imagenFotoTemp = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            
            if let imagenFoto = imagenFotoTemp {
                let polizatemp = arregloPolizas[self.rowsel]["nopoliza"]!
                let comrimidad = self.compressImage2(image: imagenFoto)
                
                if self.imagenselected == 1 {
                    self.derechopic.image = comrimidad
                    rigthflag = 1
                    
                    if let data = comrimidad.pngData() {
                        let filename = self.getDocumentsDirectory().appendingPathComponent("derecho_\(polizatemp).png")
                        do{
                            try data.write(to: filename)
                        }catch {
                        }
                    }
                    //let imagennn = info[UIImagePickerControllerOriginalImage] as? UIImage
                } else if self.imagenselected == 2 {
                    self.frontpic.image = comrimidad//info[UIImagePickerControllerOriginalImage] as? UIImage
                    frontflag = 1
                                        
                    if let data = comrimidad.pngData() {
                        let filename = self.getDocumentsDirectory().appendingPathComponent("frontal_\(polizatemp).png")
                        do{
                            try data.write(to: filename)
                        }catch {
                        }
                    }
                    //let imagennn = info[UIImagePickerControllerOriginalImage] as? UIImage
                } else if self.imagenselected == 3 {
                    self.izquierdopic.image = comrimidad//info[UIImagePickerControllerOriginalImage] as? UIImage
                    leftflag = 1
                    if let data = comrimidad.pngData() {
                        let filename = self.getDocumentsDirectory().appendingPathComponent("izquierdo_\(polizatemp).png")
                        do{
                            try data.write(to: filename)
                        }catch {
                        }
                    }
                    //let imagennn = info[UIImagePickerControllerOriginalImage] as? UIImage
                } else if self.imagenselected == 4 {
                    self.backpic.image = comrimidad//info[UIImagePickerControllerOriginalImage] as? UIImage
                    backflag = 1
                    
                    if let data = comrimidad.pngData() {
                        let filename = self.getDocumentsDirectory().appendingPathComponent("trasero_\(polizatemp).png")
                        do{
                            try data.write(to: filename)
                        }catch {
                        }
                    }
                    //let imagennn = info[UIImagePickerControllerOriginalImage] as? UIImage
                }
            }
        })
    }
        
//MARK: - Add image to Library
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Tuvimos un problema al guardar la imagen. Intenta màs tarde.", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func closeW(_ sender: Any) {
        //launch pop photos...
        message = 0
        //dismiss(animated: true, completion: {})
        self.navigationController?.popViewController(animated: true)
    }

//************************ save frontal pcture and send images **************//
    func savePicture(){
        self.derechoCircularProgress.isHidden = false
        self.frontCircularProgress.isHidden = false
        self.izquierdoCircularProgress.isHidden = false
        self.backCircularProgress.isHidden = false

        self.derechopic.alpha = 0.4
        self.frontpic.alpha = 0.4
        self.izquierdopic.alpha = 0.4
        self.backpic.alpha = 0.4
        
        let imageManager = DataImageManager.sharedImage
        let imagennn = self.derechopic.image!
        let idpic = "2"
        imageManager.sendPhotoCar(sendThisImage: !fotosfaltantes[1], rowsel: self.rowsel, imagenn: imagennn, idpic: idpic) { result in

            switch result {
                case "error":
                    self.launch_alert()
                    break
                case "ok":
                    DispatchQueue.main.async {
                        if !fotosfaltantes[1]{
                            self.derechoCircularProgress.setProgressWithAnimation(duration: 0.3, value: 1.0)
                            animateImage(image: self.derechoCompImage)
                        }
                    }
                    
                    let imagennn = self.frontpic.image!
                    let idpic = "1"
                    imageManager.sendPhotoCar(sendThisImage: !fotosfaltantes[0], rowsel: self.rowsel, imagenn: imagennn, idpic: idpic) { result in

                        switch result {
                            case "error":
                                self.launch_alert()
                                break
                            case "ok":
                                DispatchQueue.main.async {
                                    if !fotosfaltantes[0]{
                                        self.frontCircularProgress.setProgressWithAnimation(duration: 0.3, value: 1.0)
                                        animateImage(image: self.frontCompImage)
                                    }
                                }
                                
                                let imagennn = self.izquierdopic.image!
                                let idpic = "4"
                                imageManager.sendPhotoCar(sendThisImage: !fotosfaltantes[3], rowsel: self.rowsel, imagenn: imagennn, idpic: idpic) { result in
                                    
                                    switch result {
                                        case "error":
                                            self.launch_alert()
                                            break
                                        case "ok":
                                            DispatchQueue.main.async {
                                                if !fotosfaltantes[3]{
                                                    self.izquierdoCircularProgress.setProgressWithAnimation(duration: 0.3, value: 1.0)
                                                    animateImage(image: self.izquierdoCompImage)
                                                }
                                            }
                                            
                                            let imagennn = self.backpic.image!
                                            let idpic = "3"
                                            imageManager.sendPhotoCar(sendThisImage: !fotosfaltantes[2], rowsel: self.rowsel, imagenn: imagennn, idpic: idpic) { result in
                                                
                                                switch result {
                                                    case "error":
                                                        self.launch_alert()
                                                        break
                                                    case "ok":
                                                        DispatchQueue.main.async {
                                                            if !fotosfaltantes[2]{
                                                                self.backCircularProgress.setProgressWithAnimation(duration: 0.3, value: 1.0)
                                                                animateImage(image: self.backCompImage)
                                                            }
                                                            
                                                        }
                                                        
                                                        //finish send all images
                                                        if solofotos == 1{
                                                            if fotosfaltantes[4] == false{
                                                                self.launch_odometer()
                                                            }else{
                                                                solofotos = 0
                                                                self.updatestatus()
                                                            }
                                                        }else{
                                                            self.launch_odometer()
                                                        }
                                                        break
                                                    default:
                                                        break
                                                }
                                            }
                                            break
                                        default:
                                            break
                                    }
                                }
                                break
                            default:
                                break
                        }
                    }
                    break
                default:
                    break
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        //let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//************************ DEPRECATED ********************************************//
    func compressImage2(image:UIImage) -> UIImage {
        // Reducing file size to a 10th
        
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
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
        UIGraphicsEndImageContext();
        
        return img!;
    }
    
//************************ compress image and get data***************************//
    func compressImage(image:UIImage) -> Data {
        // Reducing file size to a 10th
        
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        let maxHeight : CGFloat = image.size.height/1//300
        let maxWidth : CGFloat = image.size.width/1//400.0
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
        let imageData = img!.jpegData(compressionQuality: 0.9);
        UIGraphicsEndImageContext();
        
        return imageData!
    }

//************************ click on Listo*****************s*******************//
    @IBAction func sendDataBar(_ sender: Any) {

        if rigthflag == 1 && leftflag == 1 && frontflag == 1 && backflag == 1{
            //send all picturec...loop to get all the images and send them
            savePicture()
        }else{
            showmessage(message: "Capturar todas las fotografìas solicitadas.", controller: self)
        }
    }
    
    //Generate boundary
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }

//************************ launch odometer WS*********************//
    func launch_alert() {
        
        let backServiceName = Notification.Name("backServiceName")
        NotificationCenter.default.post(name: backServiceName, object: nil)
        
        DispatchQueue.main.async {
            self.alertaloading.dismiss(animated: true, completion: {
                
                let refreshAlert = UIAlertController(title: "Atención.", message: "Hubo un problema al subir las fotos. Intentaremos más tarde.", preferredStyle: UIAlertController.Style.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    //start thread...
                    self.dismiss(animated: true, completion: nil)
                    
                    //let odometerview = self.storyboard?.instantiateViewController(withIdentifier: "Odometer") as! OdometerViewController
                    //openview
                    //self.present(odometerview, animated: true, completion: nil)
                    //self.dismiss(animated: true, completion: nil)
                }))
                
                self.present(refreshAlert, animated: true)
            })
        }
    }

//************************ launch odometer WS************************//
    func backpolizas() {
        //Lanzamos siguiente odometro
        arregloPolizas[self.rowsel]["vehiclepie"] = "true"
        actualizar = "1"
        self.navigationController?.popViewController(animated: true)
    }
    
//************************ launch odometer WS****************************//
    func launch_odometer() {
        //Lanzamos siguiente odometro
        DispatchQueue.main.async {
            self.alertaloading.dismiss(animated: true, completion: {
                
                let refreshAlert = UIAlertController(title: "Fotos de Vehículo", message: "Las fotos se han subido correctamente !Gracias!", preferredStyle: UIAlertController.Style.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    
                    self.backCompImage.alpha = 0
                    self.backCircularProgress.isHidden = true
                    self.backpic.alpha = 1.0

                    self.izquierdoCompImage.alpha = 0
                    self.izquierdoCircularProgress.isHidden = true
                    self.izquierdopic.alpha = 1.0
                    
                    self.frontCompImage.alpha = 0
                    self.frontCircularProgress.isHidden = true
                    self.frontpic.alpha = 1.0
                    
                    self.derechoCompImage.alpha = 0
                    self.derechoCircularProgress.isHidden = true
                    self.derechopic.alpha = 1.0
                    
                    let bundle = Bundle(for: OdometerViewController.self)
                    let storyboard = UIStoryboard(name: "Odometer", bundle: bundle)
                    let myAlert = storyboard.instantiateViewController(withIdentifier: "OdometerViewController") as! OdometerViewController
                    self.navigationController?.pushViewController(myAlert, animated: true)

                }))
                
                self.present(refreshAlert, animated: true)
            })
        }
    }

//***************************update status poliza*******************************
    func updatestatus(){
        
        //alertaloading.dismiss(animated: true, completion: nil)
        
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
                            
                            self.alertaloading.dismiss(animated: true, completion: {
                                
                                //si es true o false => pasa sin problermas y cierra
                                if lastvalordev == "true"{
                                    
                                    let refreshAlert = UIAlertController(title: "Gracias", message: "Información actualizada.", preferredStyle: UIAlertController.Style.alert)
                                    
                                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                        
                                        self.backpolizas()
                                    }))
                                    
                                    self.present(refreshAlert, animated: true, completion: nil)
                                }
                                else
                                {
                                    let refreshAlert = UIAlertController(title: "Atención", message: "Error al cargar información, intente más tarde", preferredStyle: UIAlertController.Style.alert)
                                    
                                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                        
                                        self.backpolizas()
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
                        
                        self.alertaloading.dismiss(animated: true, completion: {
                                                       
                            let refreshAlert = UIAlertController(title: "Odómetro", message: "Error al enviar odómetro. Intente más tarde.", preferredStyle: UIAlertController.Style.alert)
                            
                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                
                                self.backpolizas()
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
}



extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
