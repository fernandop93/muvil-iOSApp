//
//  AlertsTableViewController.swift
//  MuvilApp
//
//  Created by Fernando Pérez on 10/15/21.
//

import UIKit

private enum Static {
    enum ReuseIdentifiers: String {
        case cell = "CellID"
    }
}

class AlertsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.notificationResponse?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Historial de alertas"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Static.ReuseIdentifiers.cell.rawValue, for: indexPath)
        //print(indexPath.row);
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let mensaje = appDelegate?.notificationResponse?[indexPath.row].content ?? "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let string: String? = appDelegate?.notificationResponse?[indexPath.row].date ?? " "
        let formattedDate: Date? = dateFormatter.date(from: string ?? " ")
        
        let userDateFormatter = DateFormatter()
        userDateFormatter.dateFormat = "dd/MM/YY HH:mm"
        cell.textLabel?.text = mensaje + " - " + userDateFormatter.string(from: formattedDate ??  Date())

        return cell
    }
}
