//
//  InvoiceTableViewCell.swift
//  miituoLib
//
//  Created by JOHN CRISTOBAL on 15/06/22.
//

import UIKit

class InvoiceTableViewCell: UITableViewCell {

    var delegate: invoiceSendProtocol?

    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var btnSend: loadingButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: String?, amount: Double?, tag:Int?) {
        
          
        if let data = data, let amount = amount {
         self.lblMonth.text = "\(data) - $\(String(amount))"
        }
        
        btnSend.tag = tag ?? 0
        btnSend.addTarget(self, action: #selector(didPressSend(sender:)), for: .touchUpInside)
        
    }
    
    @objc func didPressSend(sender: UIButton){
        
        let buttonTag = sender.tag
        
        self.delegate?.sendAction(tag: buttonTag)
    
    }

}
