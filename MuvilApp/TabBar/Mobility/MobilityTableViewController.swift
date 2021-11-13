//
//  MobilityTableViewController.swift
//  MuvilApp
//
//  Created by Fernando Pérez on 10/15/21.
//

import UIKit

class MobilityTableViewController: UITableViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var DNILabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var plateLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var finishLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        nameLabel.text = appDelegate?.operatorResponse?.driverName
        DNILabel.text = appDelegate?.operatorResponse?.driverDNI
        phoneLabel.text = appDelegate?.operatorResponse?.driverNumber
        brandLabel.text = appDelegate?.operatorResponse?.vehicleBrand
        colorLabel.text = appDelegate?.operatorResponse?.vehicleColor
        modelLabel.text = appDelegate?.operatorResponse?.vehicleModel
        plateLabel.text = appDelegate?.operatorResponse?.vehiclePlate
        startLabel.text = appDelegate?.operatorResponse?.serviceStart
        finishLabel.text = appDelegate?.operatorResponse?.serviceEnd
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
