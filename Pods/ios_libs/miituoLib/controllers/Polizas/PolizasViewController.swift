//
//  PolizasViewController.swift
//  miituoLib
//
//  Created by John Alexis Cristobal Jimenez  on 03/11/20.
//

import UIKit
import Alamofire
import CoreData
//import SDWebImage

public class PolizasViewController: UIViewController, SwiftyTableViewCellDelegate,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var containerView: UIView!
    @IBOutlet var pageControl: UIPageControl!
    var messageAlert = ""
    var polizasAtlas = false
    var polizasAna = false
    
    var bannerPageViewController: BannerPrincipalViewController? {
        didSet {
            bannerPageViewController?.tutorialDelegate = self
        }
    }
    
    @IBOutlet var tableview: UITableView!
    @IBOutlet var vistaNoPolizas: UIView!
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var labelnombre: UILabel!
    @IBOutlet var labelNombreNoPolizas: UILabel!
    
    @IBOutlet var noPolizasLabel: UILabel!
    var refreshControl: UIRefreshControl!
    
    @IBOutlet var hola: UILabel!
    @IBOutlet var namelabel: UILabel!
    @IBOutlet var leyendalabel: UILabel!
    
    let alertaloading = UIAlertController(title: "Actualizando información...", message: "", preferredStyle: .alert)

    let alertaloadingfotos = UIAlertController(title: "", message: "Procesando...", preferredStyle: .alert)

    let alertaloadingmesonce = UIAlertController(title: "", message: "Recuperando información, espere por favor...", preferredStyle: .alert)

    let manager = CLLocationManager()
    
    var previous = NSDecimalNumber.one
    var current = NSDecimalNumber.one
    var position: UInt = 1
    var updateTimer: Timer?
    
    public var phoneDataFromView: String?
    public var dev: Bool = true
    
    let menu = Notification.Name("menu")
    let tabla = Notification.Name("tabla")
    let backServiceName = Notification.Name("backServiceName")
    let deleteDataLog = Notification.Name("deleteDataLog")
    let sendCuponReferido = Notification.Name("sendCuponReferido")

    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControl.Event.valueChanged)
        tableview.addSubview(refreshControl)
        
        celular = phoneDataFromView!
        if dev{
            ip = ipdev
            urlCotizaString = urlCotizaStringdev
            pathPhotos = pathPhotosdev
        }else{
            ip = ipProd
            urlCotizaString = urlCotizaStringProd
            pathPhotos = pathPhotosProd
        }
        
        self.getCuponReferido()
        actualizar = "1"
                
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataTable), name: reloadData, object: nil)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if actualizar == "1"{
            actualizar = "0"
            self.getJson(telefon: celular)
        }
    }
    
    @objc func reloadDataTable(){
        if actualizar == "1"{
            actualizar = "0"
            self.getJson(telefon: celular)
        }
    }
    
    func getCuponReferido(){
        let manager = DataManager.shared
        manager.getCuponReferido(celphone: celular) { (data) in
            
            if data[0] == "error" {
                kmsCuponReferido = "100"
                descriptipnCuponReferido = "Aplica un cupón al mes por póliza sólo si reportaste tu odómetro y pagaste el mes anterior."
            }else{
                kmsCuponReferido = data[1]
                descriptipnCuponReferido = data[0]
            }
            NotificationCenter.default.post(name: self.sendCuponReferido, object: nil)
        }
    }
    
//===============================call miituo============================
    func llamarMiituo(){
        let refreshAlert = UIAlertController(title: "Comunicate a", message: "miituo", preferredStyle: UIAlertController.Style.actionSheet)
        refreshAlert.view.tintColor = UIColor.init(red: 34/255, green: 201/255, blue: 252/255, alpha: 1.0)
        
        refreshAlert.addAction(UIAlertAction(title: "Llamar", style: .default, handler: { (action: UIAlertAction!) in
            
            guard let url = URL(string: "telprompt://8009530059") else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: { (action: UIAlertAction!) in
            
            //self.launcpolizas()
        }))
        present(refreshAlert, animated: true, completion: nil)
    }

    func swiftyTableViewCellDidSiniestro(_ sender: PolizasTableViewCell) {
        guard let indexPath = tableview.indexPath(for: sender) else { return }
        
        //validar aseguradora y pintar la leyand correcta
        let reportstate = arregloPolizas[indexPath.row]["reportstate"]! as String
        var aseguradora = ""

        if reportstate == "24"{
            llamarMiituo()
        }else{
            let aseg = arregloPolizas[indexPath.row]["insurance"]?.description
            aseguradora = aseg!
            let telefono = dictionaryTelefonos[aseg!]

            let refreshAlert = UIAlertController(title: "Reportar siniestro a", message: aseguradora, preferredStyle: UIAlertController.Style.actionSheet)
            //refreshAlert.view.tintColor = UIColor.init(red: 255/255, green: 75/255, blue: 210/255, alpha: 1.0)
            
            refreshAlert.addAction(UIAlertAction(title: "Llamar", style: .default, handler: { (action: UIAlertAction!) in
                
                guard let url = URL(string: "telprompt://\(telefono!)") else { return }
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: { (action: UIAlertAction!) in
                
            }))
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
//===============================action general============================
    func swiftyTableViewCellDidAction(_ sender: PolizasTableViewCell) {
        // Get Cell Label
        guard let indexPath = tableview.indexPath(for: sender) else { return }

        //let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableview.cellForRow(at: indexPath)! as! PolizasTableViewCell
        currentCell.contentView.backgroundColor = UIColor.white
        currentCell.backgroundColor = UIColor.white
        
        valueToPass = String(describing:indexPath.row)
        
        //Get the parameters of odometerpie and vehiclepie to show the specific viwcontroller
        let state = (arregloPolizas[indexPath.row]["state"]! as String)
        let reportstate = (arregloPolizas[indexPath.row]["reportstate"]! as String)
        let odometerpie = (arregloPolizas[indexPath.row]["odometerpie"]! as String)
        let vehiclepie = (arregloPolizas[indexPath.row]["vehiclepie"]! as String)
                
        if valornum >= 10.0 {
            let refreshAlert = UIAlertController(title: "¡Vas Manejando!", message: "Reporta más tarde…", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.tableview.reloadData()
                
                //self.launcpolizas()
            }))
            present(refreshAlert, animated: true, completion: nil)
        } else {
            
            //prueba comparti
            //check the options to show the specific viewcontroller
            if vehiclepie == "false" && odometerpie == "false" {
                currentCell.imageicon.backgroundColor = UIColor.red
                let bundle = Bundle(for: PhotosCarViewController.self)
                let storyboard = UIStoryboard(name: "PhotosCar", bundle: bundle)
                let vc = storyboard.instantiateViewController(withIdentifier: "PhotosCarViewController") as! PhotosCarViewController
                //vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                //self.present(vc, animated: true, completion: nil)
                self.navigationController?.pushViewController(vc, animated: true)

            }else if vehiclepie == "true" && odometerpie == "false" {
                currentCell.imageicon.backgroundColor = UIColor.red
                tipoodometro = "first"
                launchOdometerView(type: tipoodometro)
            }else if reportstate == "13" {
                currentCell.imageicon.backgroundColor = UIColor.red
                tipoodometro = "mensual"
                launchOdometerView(type: tipoodometro)
            }else if reportstate == "14" {
                currentCell.imageicon.backgroundColor = UIColor.red
                tipoodometro = "cancela"
                banderaCancelacion = 1
                launchOdometerView(type: tipoodometro)
            }else if state == "En espera de odometro"{
                //cell.imageicon.backgroundColor = UIColor.green
                currentCell.imageicon.backgroundColor = UIColor.red
            }else if reportstate == "15" {
                currentCell.imageicon.backgroundColor = UIColor.red
                tipoodometro = "ajuste"
                launchOdometerView(type: tipoodometro)
            }
            else if reportstate == "23" {
                let refreshAlert = UIAlertController(title: "Atención", message: "Estamos esperando el pago de renovación. Te avisaremos cuando este listo.", preferredStyle: UIAlertController.Style.alert)
                 
                 refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                 
                 }))
                 self.present(refreshAlert, animated: true, completion: nil)
            }else if reportstate == "24"{
                //call miituo
                llamarMiituo()
            }
            else if reportstate == "21" {
                //falla para subir fotos, volver a subir
                solofotos = 1
                badneraprocsando = 0
                fotosarriba = 0
                
                currentCell.imageicon.backgroundColor = UIColor.red//(red: 255/255, green: 106/255, blue: 19/255, alpha: 1.0)
                
                //getFotosFaltantes()
            }
            else {
                currentCell.imageicon.backgroundColor = UIColor.lightGray

                let bundle = Bundle(for: DetalleViewController.self)
                let storyboard = UIStoryboard(name: "Detalle", bundle: bundle)
                let myAlert = storyboard.instantiateViewController(withIdentifier: "DetalleViewController") as! DetalleViewController
                self.present(myAlert, animated: true)
            }
        }
    }
    
    func launchOdometerView(type: String){
        tipoodometro = type
        let bundle = Bundle(for: OdometerViewController.self)
        let storyboard = UIStoryboard(name: "Odometer", bundle: bundle)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "OdometerViewController") as! OdometerViewController
        self.navigationController?.pushViewController(myAlert, animated: true)
    }
    
    func swiftyTableViewCellDidRenova(_ sender: PolizasTableViewCell) {
        //Póliza en renovación \n Ver información
        //guard let indexPath = tableview.indexPath(for: sender) else { return }
        //let idpoliza = Int(arregloPolizas[indexPath.row]["idpoliza"]! as String)

        //callFunciongetTarifa(fila:indexPath.row,value:idpoliza!)
        //call service and show data about renovation
     
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arregloPolizas.count
    }
    
// ******************************** initializes every row of th table ******** //
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //Define el contenido de la celda
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PolizasTableViewCell
        cell.delegate = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    
        //set picture loaded
        let pliza = arregloPolizas[indexPath.row]["idpoliza"]! as String
        let pathfoto = "\(pathPhotos)\(pliza)/FROM_VEHICLE.png"
        
        cell.imagecar.downloaded(from: pathfoto)
        cell.imagecar.layer.masksToBounds = false
        cell.imagecar.layer.cornerRadius = cell.imagecar.frame.height / 2
        cell.imagecar.clipsToBounds = true
        cell.label.text = "Póliza: \(arregloPolizas[indexPath.row]["nopoliza"]! as String)"
    
        //Get value from reporstate and then set color in the icon
        let state = arregloPolizas[indexPath.row]["state"]! as String
        let reportstate = arregloPolizas[indexPath.row]["reportstate"]! as String
        let odometerpie = (arregloPolizas[indexPath.row]["odometerpie"]! as String)
        let vehiclepie = (arregloPolizas[indexPath.row]["vehiclepie"]! as String)
        let mensualidad = Int(arregloPolizas[indexPath.row]["mensualidad"]!)

        cell.imageicon.backgroundColor = UIColor.lightGray
        cell.labelalerta.textColor = UIColor.lightGray

        cell.labelalerta.text = "Ver información \(arreglocarro[indexPath.row]["subtype"]! as String)"
        cell.mensajelimite.isHidden = true
        cell.callSiniestro.setImage(UIImage(named: "llama.png"), for: .normal)
        
        if reportstate == "21"{
            
            //cell.imageicon.backgroundColor = UIColor.green
            cell.imageicon.backgroundColor = UIColor.red
            cell.labelalerta.textColor = UIColor.red
            cell.labelalerta.text = "Vuelve a enviar las fotos de tu\n\(arreglocarro[indexPath.row]["subtype"]! as String)"
            
            let dateString = arregloPolizas[indexPath.row]["limitefecha"]! as String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let dateaux = dateFormatter.date(from: dateString)
            let date = Calendar.current.date(byAdding: .day, value: -1, to: dateaux!)
            
            //get name month
            let dateFormattermes = DateFormatter()
            dateFormattermes.dateFormat = "MMM"
            let nameOfMonthcinco = dateFormattermes.string(from: date!)
            let valmes = getNombreMes(nombre: nameOfMonthcinco)
            dateFormattermes.dateFormat = "dd"
            let valdia = dateFormattermes.string(from: date!)
            let calendar = Calendar.current
            let hour = "23"//calendar.component(.hour, from: date!)
            dateFormattermes.dateFormat = "mm"
            let minutes = "59"//dateFormattermes.string(from: date!)
            //calendar.component(.minute, from: date!)
            _ = calendar.component(.second, from: date!)
            
            cell.mensajelimite.text = "Tienes hasta el:\n\(valdia) de \(valmes) a las \(hour):\(minutes) hrs."
            cell.mensajelimite.textColor = UIColor.red
            cell.mensajelimite.isHidden = true
        }

        if reportstate == "23" {
            //cell.imageicon.backgroundColor = UIColor.init(red: 62/255, green: 253/255, blue: 202/255, alpha: 1.0)
            //cell.labelalerta.textColor = UIColor.init(red: 62/255, green: 253/255, blue: 202/255, alpha: 1.0)
            //UIColor.red
            cell.imageicon.backgroundColor = UIColor.red
            cell.labelalerta.textColor = UIColor.red
            cell.labelalerta.text = "Estamos procesando tu pago...\n\(arreglocarro[indexPath.row]["subtype"]! as String)"

            cell.mensajelimite.text="Estamos esperando a que se realice su pago de renovación, le notificaremos cuando este lista."
            cell.mensajelimite.isHidden = true
        }
        if reportstate == "24" {
            //cell.imageicon.backgroundColor = UIColor.init(red: 62/255, green: 253/255, blue: 202/255, alpha: 1.0)
            //cell.labelalerta.textColor = UIColor.init(red: 62/255, green: 253/255, blue: 202/255, alpha: 1.0)
            //UIColor.red
            cell.imageicon.backgroundColor = UIColor.red
            cell.labelalerta.textColor = UIColor.red
            if mensualidad == 0{
                cell.labelalerta.text = "HUBO UN PROBLEMA CON TU PAGO\nY TU PÓLIZA NO ESTA ACTIVA"
            }else{
                cell.labelalerta.text = "HUBO UN PROBLEMA CON TU PAGO\nY TU PÓLIZA ESTA EN RIESGO\nDE CANCELARSE"
            }
            
            cell.labelalerta.font = cell.labelalerta.font.withSize(12)
            cell.mensajelimite.textColor = UIColor.red
            cell.mensajelimite.text="Comunicate con nosotros para mas información."
            cell.mensajelimite.isHidden = false
            
            cell.callSiniestro.setImage(UIImage(named: "telrojo.png"), for: .normal)
        }
        
        if reportstate == "15" {
            //cell.imageicon.backgroundColor = UIColor.init(red: 62/255, green: 253/255, blue: 202/255, alpha: 1.0)
            //cell.labelalerta.textColor = UIColor.init(red: 62/255, green: 253/255, blue: 202/255, alpha: 1.0)
            //UIColor.red
            cell.imageicon.backgroundColor = UIColor.red
            cell.labelalerta.textColor = UIColor.red
            cell.labelalerta.text = "Solicitud ajuste odómetro\n\(arreglocarro[indexPath.row]["subtype"]! as String)"
            cell.mensajelimite.isHidden = true
        }
        if reportstate == "12" {
            cell.imageicon.backgroundColor = UIColor.lightGray
            cell.labelalerta.textColor = UIColor.lightGray
            
            let dateString = arregloPolizas[indexPath.row]["limitefecha"]! as String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let dateaux = dateFormatter.date(from: dateString)
            let date = Calendar.current.date(byAdding: .day, value: -1, to: dateaux!)
            
            //get name month
            var dateFormattermes = DateFormatter()
            dateFormattermes.dateFormat = "MMM"
            let nameOfMonthcincob = dateFormattermes.string(from: date!)
            let valmesb = getNombreMes(nombre: nameOfMonthcincob)
            dateFormattermes.dateFormat = "dd"
            let valdiab = dateFormattermes.string(from: date!)
            dateFormattermes.dateFormat = "yyyy"
            _ = dateFormattermes.string(from: date!)
            
            //get next date
            let tomorrow = Calendar.current.date(byAdding: .day, value: -4, to: dateaux!)
            //get name month
            dateFormattermes = DateFormatter()
            dateFormattermes.dateFormat = "MMM"
            let nameOfMonthcinco = dateFormattermes.string(from: tomorrow!)
            let valmes = getNombreMes(nombre: nameOfMonthcinco)
            dateFormattermes.dateFormat = "dd"
            let valdia = dateFormattermes.string(from: tomorrow!)
            _ = Calendar.current
            let hour = "23"
            //let hour = calendar.component(.hour, from: tomorrow!)
            dateFormattermes.dateFormat = "mm"
            //let minutes = calendar.component(.minute, from: date!)
            let minutes = "59"
            //let minutes = dateFormattermes.string(from: tomorrow!)
            //let seconds = calendar.component(.second, from: date!)
            
            cell.labelalerta.text = "Próximo reporte:\ndel \(valdia)/\(valmes) al \(valdiab)/\(valmesb)\na las \(hour):\(minutes) hrs."
            cell.mensajelimite.textColor = UIColor.lightGray
            cell.mensajelimite.isHidden = false
            cell.mensajelimite.text = "Ver información"
            cell.callSiniestro.isHidden = false
            let mensualidad = Int(arregloPolizas[indexPath.row]["mensualidad"]!)
            
            if mensualidad == 11 {
                cell.showRenova.isHidden = false
                cell.showRenovaInfo.isHidden = false
                cell.showRenova.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
                cell.showRenova.setTitle("Tu renovación de póliza está próxima", for: .normal)
            }else{
                cell.showRenova.isHidden = true
                cell.showRenovaInfo.isHidden = true
            }
        }
        if state == "En espera de odometro" && reportstate == "12" {
            //cell.imageicon.backgroundColor = UIColor.green
            cell.imageicon.backgroundColor = UIColor.red
            cell.labelalerta.textColor = UIColor.red
            cell.labelalerta.text = "Cancelación en proceso..."
            cell.callSiniestro.isHidden = true
            cell.mensajelimite.textColor = UIColor.red
            cell.mensajelimite.isHidden = true
        }
        if reportstate == "14" {
            //cell.imageicon.backgroundColor = UIColor.init(red: 62/255, green: 253/255, blue: 202/255, alpha: 1.0)
            //cell.labelalerta.textColor = UIColor.init(red: 62/255, green: 253/255, blue: 202/255, alpha: 1.0)
            //UIColor.red
            cell.imageicon.backgroundColor = UIColor.red
            cell.labelalerta.textColor = UIColor.red
            cell.labelalerta.text = "Solicitud cancelación voluntaria\n\(arreglocarro[indexPath.row]["subtype"]! as String)"
            cell.mensajelimite.isHidden = true
        }
        if reportstate == "13" {
            //cell.imageicon.backgroundColor = UIColor.init(red: 62/255, green: 253/255, blue: 202/255, alpha: 1.0)
            //cell.labelalerta.textColor = UIColor.init(red: 62/255, green: 253/255, blue: 202/255, alpha: 1.0)
            cell.imageicon.backgroundColor = UIColor.red
            cell.labelalerta.textColor = UIColor.red
            
            //UIColor.red
            cell.labelalerta.text = "Es hora de reportar tu odómetro\n\(arreglocarro[indexPath.row]["subtype"]! as String)"
            cell.mensajelimite.isHidden = true
            
            let dateString = arregloPolizas[indexPath.row]["limitefecha"]! as String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let dateaux = dateFormatter.date(from: dateString)
            let date = Calendar.current.date(byAdding: .day, value: -1, to: dateaux!)

            //get name month
            let dateFormattermes = DateFormatter()
            dateFormattermes.dateFormat = "MMM"
            let nameOfMonthcinco = dateFormattermes.string(from: date!)
            let valmes = getNombreMes(nombre: nameOfMonthcinco)
            dateFormattermes.dateFormat = "dd"
            let valdia = dateFormattermes.string(from: date!)
            let calendar = Calendar.current
            let hour = "23"//calendar.component(.hour, from: date!)
            dateFormattermes.dateFormat = "mm"
            //let minutes = calendar.component(.minute, from: date!)
            let minutes = "59"//dateFormattermes.string(from: date!)
            _ = calendar.component(.second, from: date!)
            
            cell.mensajelimite.text = "Tienes hasta el:\n\(valdia) de \(valmes) a las \(hour):\(minutes) hrs."
            cell.mensajelimite.textColor = UIColor.red
            cell.mensajelimite.isHidden = false
        }
        
        if vehiclepie == "false" && odometerpie == "false"{
            //cell.imageicon.backgroundColor = UIColor.green
            cell.imageicon.backgroundColor = UIColor.red
            cell.labelalerta.textColor = UIColor.red
            cell.labelalerta.text = "No has enviado fotos de tu\n \(arreglocarro[indexPath.row]["subtype"]! as String)"
            
            let dateString = arregloPolizas[indexPath.row]["limitefecha"]! as String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let date = dateFormatter.date(from: dateString)
            //let dateaux = Calendar.current.date(byAdding: .day, value: -1, to: date!)

            //get name month
            let dateFormattermes = DateFormatter()
            dateFormattermes.dateFormat = "MMM"
            let nameOfMonthcinco = dateFormattermes.string(from: date!)
            let valmes = getNombreMes(nombre: nameOfMonthcinco)
            dateFormattermes.dateFormat = "dd"
            let valdia = dateFormattermes.string(from: date!)
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date!)
            //let minutes = calendar.component(.minute, from: date!)
            dateFormattermes.dateFormat = "mm"
            let minutes = dateFormattermes.string(from: date!)
            //let seconds = calendar.component(.second, from: date!)
            
            cell.mensajelimite.text = "Tienes hasta el:\n\(valdia) de \(valmes) a las \(hour):\(minutes) hrs."
            cell.mensajelimite.textColor = UIColor.red
            cell.callSiniestro.isHidden = false
            cell.mensajelimite.isHidden = false
        }
        if vehiclepie == "true" && odometerpie == "false"{

            //cell.imageicon.backgroundColor = UIColor.green
            cell.imageicon.backgroundColor = UIColor.red
            cell.labelalerta.textColor = UIColor.red
            cell.labelalerta.text = "No has enviado foto de tu odómetro\n \(arreglocarro[indexPath.row]["subtype"]! as String)"
            
            let dateString = arregloPolizas[indexPath.row]["limitefecha"]! as String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let date = dateFormatter.date(from: dateString)
            //let date = Calendar.current.date(byAdding: .day, value: -1, to: dateaux!)

            //get name month
            let dateFormattermes = DateFormatter()
            dateFormattermes.dateFormat = "MMM"
            let nameOfMonthcinco = dateFormattermes.string(from: date!)
            let valmes = getNombreMes(nombre: nameOfMonthcinco)
            dateFormattermes.dateFormat = "dd"
            let valdia = dateFormattermes.string(from: date!)
            let calendar = Calendar.current
            dateFormattermes.dateFormat = "mm"
            let hour = calendar.component(.hour, from: date!)
            let minutes = dateFormattermes.string(from: date!)
            //calendar.component(.minute, from: date!)
            //let seconds = calendar.component(.second, from: date!)
            
            cell.mensajelimite.text = "Tienes hasta el:\n\(valdia) de \(valmes) a las \(hour):\(minutes) hrs."
            cell.mensajelimite.textColor = UIColor.red
            cell.mensajelimite.isHidden = false
        }
        
        if vehiclepie == "false" && odometerpie == "false" && reportstate == "4"{
            //cell.imageicon.backgroundColor = UIColor.green
            cell.imageicon.backgroundColor = UIColor.red
            cell.labelalerta.textColor = UIColor.red
            cell.labelalerta.text = "No has enviado fotos de tu\n \(arreglocarro[indexPath.row]["subtype"]! as String)"
            
            let dateString = arregloPolizas[indexPath.row]["limitefecha"]! as String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let date = dateFormatter.date(from: dateString)
            //let dateaux = Calendar.current.date(byAdding: .day, value: -1, to: date!)
            
            //get name month
            let dateFormattermes = DateFormatter()
            dateFormattermes.dateFormat = "MMM"
            let nameOfMonthcinco = dateFormattermes.string(from: date!)
            let valmes = getNombreMes(nombre: nameOfMonthcinco)
            dateFormattermes.dateFormat = "dd"
            let valdia = dateFormattermes.string(from: date!)
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date!)
            //let minutes = calendar.component(.minute, from: date!)
            dateFormattermes.dateFormat = "mm"
            let minutes = dateFormattermes.string(from: date!)
            //let seconds = calendar.component(.second, from: date!)
            
            cell.mensajelimite.text = "Tienes hasta el:\n\(valdia) de \(valmes) a las \(hour):\(minutes) hrs."
            cell.mensajelimite.textColor = UIColor.red
            
            cell.mensajelimite.isHidden = false
            //cell.isHidden = true
        }

        cell.contentView.backgroundColor = UIColor.white
    
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 1, y: 5, width: self.view.frame.size.width - 20, height: 120))
    
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
    
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)

        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let reportstate = arregloPolizas[indexPath.row]["reportstate"]! as String
        _ = (arregloPolizas[indexPath.row]["odometerpie"]! as String)
        _ = (arregloPolizas[indexPath.row]["vehiclepie"]! as String)
        
        if reportstate == "4"{
            return 0.0
        }
        if reportstate == "24"{
            return 110.0
        }
        let mensualidad = Int(arregloPolizas[indexPath.row]["mensualidad"]!)

        if mensualidad == 11 {
            return 140.0;//Choose your custom row height
        }else{
            return 100.0
        }
    }
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        flagcontrol = "0"
        if let cel = UserDefaults.standard.value(forKey: "celular") {

            DispatchQueue.global(qos: .userInitiated).async {
                celular = cel as! String
                //self.deleteDB()
                //self.getJsonMulti(telefon: celular)
                self.getJson(telefon: celular)
            }
        }
    }
    
//*******************Function to get data with the celphone***********************
    func getJson(telefon:String){
        
        //openloading(mensaje: "Buscando...")
        let manager = DataManager.shared
        manager.getDataClient(telefono: telefon, ip: ip) { (response) in

            DispatchQueue.main.async {
                //self.alertaloadingmesonce.dismiss(animated: true, completion: {
                    self.refreshControl.endRefreshing()
                    self.tableview.isUserInteractionEnabled = true
                    
                    if let data = response as? String{
                        switch data{
                                                   
                        case "ok":
                            tienepolizas = "si"
                            self.labelnombre.text = nombrecliente
                            self.tableview.reloadData()
                            self.noPolizasLabel.isHidden = true
                            self.vistaNoPolizas.isHidden = true
                            NotificationCenter.default.post(name: self.sendCuponReferido, object: nil)
                            break
                        default:
                            let prefs = UserDefaults.standard
                            prefs.removeObject(forKey:"tutoya")
                            prefs.removeObject(forKey:"tutoya")
                            prefs.removeObject(forKey:"celular")
                            self.launchAlert(message: data)
                            break
                        }
                    }else{
                        self.launchAlert(message: "Tuvimos un problema al obtener la información. Intente más tarde")
                    }
                //})
            }
        }
    }
    
    @IBAction func closeMiituo(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func launchAlert(message: String){
        let alert = UIAlertController(title: "Atencion", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
            self.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }
    func openloading(mensaje: String){
        
        alertaloadingmesonce.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:4, y:5, width:50, height:50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating()
        
        alertaloadingmesonce.view.addSubview(loadingIndicator)
        self.present(alertaloadingmesonce, animated: true, completion: nil)
    }
    
//======================== page control ====================================
    func didChangePageControlValue() {
        bannerPageViewController?.scrollToViewController(index: pageControl.currentPage)
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tutorialPageViewController = segue.destination as? BannerPrincipalViewController {
            //tutorialPageViewController.tutorialDelegate = self as! OnboardingViewControllerDelegate
            self.bannerPageViewController = tutorialPageViewController
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
//======================== page control ====================================
}

extension PolizasViewController: BannerPrincipalViewControllerDelegate {
    
    func onboardingViewController(tutorialPageViewController: BannerPrincipalViewController, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func onboardingViewController(tutorialPageViewController: BannerPrincipalViewController, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
        
    }
}
