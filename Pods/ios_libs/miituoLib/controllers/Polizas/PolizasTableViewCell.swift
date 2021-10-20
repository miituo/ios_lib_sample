//
//  PolizasTableViewCell.swift
//  miituoLib
//
//  Created by MACBOOK on 10/11/20.
//

import UIKit

class PolizasTableViewCell: UITableViewCell {

    @IBOutlet var normalAction: UIButton!
    @IBOutlet var callSiniestro: UIButton!
    @IBOutlet var showRenova: UIButton!
    @IBOutlet var showRenovaInfo: UIButton!
    
    @IBOutlet var imagecar: UIImageView!
    @IBOutlet var label: UILabel!
    @IBOutlet var imageicon: UIImageView!
    @IBOutlet weak var labelalerta: UILabel!
    
    @IBOutlet var mensajelimite: UILabel!
    
    weak var delegate: SwiftyTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.imagecar.layer.cornerRadius = self.imagecar.frame.size.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func callSiniestroAction(_ sender: Any) {
        delegate?.swiftyTableViewCellDidSiniestro(self)
    }
    
    @IBAction func actionAction(_ sender: Any) {
        delegate?.swiftyTableViewCellDidAction(self)
    }
    
    //Create a custom delegate-style protocol
    @IBAction func actionRenova(_ sender: Any) {
        delegate?.swiftyTableViewCellDidRenova(self)
    }
    
    @IBAction func actionReonvaDos(_ sender: Any) {
        delegate?.swiftyTableViewCellDidRenova(self)
    }
}

protocol SwiftyTableViewCellDelegate : AnyObject {
    func swiftyTableViewCellDidSiniestro(_ sender: PolizasTableViewCell)
    func swiftyTableViewCellDidAction(_ sender: PolizasTableViewCell)
    func swiftyTableViewCellDidRenova(_ sender: PolizasTableViewCell)

}
