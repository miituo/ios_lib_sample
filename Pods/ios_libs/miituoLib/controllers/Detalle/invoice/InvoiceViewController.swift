//
//  InvoiceViewController.swift
//  miituoLib
//
//  Created by JOHN CRISTOBAL on 15/06/22.
//

import UIKit

protocol invoiceSendProtocol {
    func sendAction(tag:Int?)
}

class InvoiceViewController: UIViewController,invoiceSendProtocol {

    //MARK: Outlets
    @IBOutlet var noInvoiceView: UIView!
    @IBOutlet var tableViewInvoice: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    //MARK: Vars
    var invoiceArray: Invoice? {
        didSet{
            self.tableViewInvoice.reloadData()
        }
    }
   
    //MARK: Actions
    @IBAction func okAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeWindow(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    
    func getInvoices() {
        
    
        self.invoiceArray?.removeAll()
        let idpoliza = arregloPolizas[Int(valueToPass)!]["idpoliza"]!
        showLoader()
        DataManager.getInvoice(policyId: idpoliza) { (success, invoices) in
            self.hideLoader()
            if success {
                
                if let invoices = invoices {
                    
                    if invoices.count > 0 {
                        self.invoiceArray = invoices
                    } else {
                        self.tableViewInvoice.isHidden = true
                        self.noInvoiceView.isHidden = false
                    }
                  
                } else {
                    
                    self.tableViewInvoice.isHidden = true
                    self.noInvoiceView.isHidden = false
                }
                
            } else {
                
            }
        }
    }
    
    
    func sendAction(tag: Int?) {

      

        if let invoices = self.invoiceArray?[tag ?? 0] {
            
            let policyId = invoices.policyID ?? 0
            let month = invoices.monthBill ?? 0
            
            let indexPath = IndexPath(row: tag ?? 0, section: 0)
            let cell = self.tableViewInvoice.cellForRow(at: indexPath) as! InvoiceTableViewCell
            cell.btnSend.buttonOff()
            
            DataManager.sendInvoiceEmail(idPolicy:policyId, numberMonth:month ) { (success) in
                cell.btnSend.buttonOn()
                if success {
                    
                    createAlertMessage(title: "¡Listo!", message: "Tu factura ha sido enviada a tu correo electrónico.", controller: self)
                    
//                    let alertVc = self.alertService.alert(title: "¡Listo!", body: "Tu factura ha sido enviada a tu correo electrónico.", policy: policyNumber, img: "facturaok", color: UIColor.init(named: "azulmiituo")!) {
//
//
//                     }
//
//                    self.present(alertVc,animated: true)
                    
                } else {
                    
                    createAlertMessage(title: "Aviso", message: "Recuerda que, después de realizar tu pago, el proceso de facturación puede tardar hasta 15 días.", controller: self)
//                    let alertVc = self.alertService.alert(title: "Aviso", body: "Recuerda que, después de realizar tu pago, el proceso de facturación puede tardar hasta 15 días.", policy: policyNumber, img: "facturaerror", color: UIColor.init(named: "rosamiituo")!) {
//
//
//                     }
//
//                    self.present(alertVc,animated: true)
                    
                    
                }
              
            }
        }
        
    }
    
    func showLoader(){
        self.loader.isHidden = false
        self.loader.startAnimating()
    }
    
    func hideLoader(){
        self.loader.isHidden = true
        self.loader.stopAnimating()

    }
    
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        self.getInvoices()
        
        
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

extension InvoiceViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.invoiceArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "invoiceCell", for: indexPath) as! InvoiceTableViewCell
        
        if let invoices = self.invoiceArray?[indexPath.row] {
            cell.delegate = self
            cell.setData(data: invoices.paymenttype, amount: invoices.amount, tag: indexPath.row)
        }

       
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
 
    }
    
    
}
