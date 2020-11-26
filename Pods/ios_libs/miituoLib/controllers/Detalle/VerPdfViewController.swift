//
//  VerPdfViewController.swift
//  miituoLib
//
//  Created by MACBOOK on 16/11/20.
//

import UIKit
import Alamofire
import PDFKit
//import WebKit

class VerPdfViewController: UIViewController {

    @IBOutlet weak var webview: UIWebView!
    var fileFinal: URL!
    //@IBOutlet var title: UIView!
    //@IBOutlet var pdfView: PDFView!
    @IBOutlet var tituloPdf: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let idpoliza = arregloPolizas[Int(valueToPass)!]["idpoliza"]! as String

        // Do any additional setup after loading the view.
        var api = ""
        switch tipopdf {
        case "poliza":
            api = "\(ip)Policy/getReport/"+idpoliza
            tituloPdf.text = "Póliza"
            break
        case "cuenta":
            api = "\(ip)Policy/getStatement/"+idpoliza
            tituloPdf.text = "Estado de cuenta"
            break
        default:
            api = ""
            break
            
        }

        _ =  DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        let filePathURL = getDocumentsDirectory().appendingPathComponent("poliza_\(idpoliza).pdf")
        
        AF.download(
            api,
            method: .get,
            //parameters: parameters,
            encoding: JSONEncoding.default,
            headers: nil,
            to: { (url, response) -> (destinationURL: URL, options: DownloadRequest.Options) in
                return (filePathURL, [.removePreviousFile, .createIntermediateDirectories])
        }).downloadProgress(closure: { (progress) in
                //progress closure
            }).response(completionHandler: { (DefaultDownloadResponse) in
                do{
                    let urlString = try DefaultDownloadResponse.result.get()
                    self.fileFinal = urlString
                    self.webview.loadRequest(URLRequest(url: urlString!))
                }
                catch {
                    
                }
            })
    }
    
    @IBAction func closw(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sharePDF(_ sender: Any) {
        
        do{
            _ = try Data(contentsOf: fileFinal)
            
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [fileFinal!], applicationActivities: nil)
        
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            
            self.present(activityViewController, animated: true, completion: nil)
        
        }
        catch {
            
        }
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

