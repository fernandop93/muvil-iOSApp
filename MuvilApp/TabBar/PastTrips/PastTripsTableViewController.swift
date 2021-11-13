//
//  PastTripsTableViewController.swift
//  MuvilApp
//
//  Created by Fernando Perez on 11/7/21.
//

import UIKit

protocol PastTripsDelegate: NSObjectProtocol {
    func didSelectAllTrips()
    func didSelectPastTrip(index: Int)
}

private struct Layout {
    enum Sections: Int, CaseIterable {
        case allTrips
        case pastTrips
        
        func headerTitle() -> String? {
            if self == .pastTrips {
                return "Historial de trayectos"
            }else{
                return nil
            }
        }
        
        func cellTitle() -> String? {
            if self == .allTrips {
                return "Ver Trayecto en curso"
            }else{
                return nil
            }
        }
    }
    
    static let reuseCellIdentifier = "Cell"
}

class PastTripsTableViewController: UITableViewController {
    
    weak var delegate: PastTripsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Layout.Sections.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Layout.Sections(rawValue: section) else {
            fatalError()
        }
        
        switch section {
        case .allTrips:
            return 1
        case .pastTrips:
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            return appDelegate?.courseWithDetailResponse?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = Layout.Sections(rawValue: section) else {
            fatalError()
        }
        
        return section.headerTitle()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Layout.Sections(rawValue: indexPath.section) else {
            fatalError()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Layout.reuseCellIdentifier, for: indexPath)

        cell.textLabel?.text = section.cellTitle()
        
        if section == .pastTrips {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let string: String? = appDelegate?.courseWithDetailResponse?[indexPath.row].date ?? " "
            let formattedDate: Date? = dateFormatter.date(from: string ?? " ")
            let userDateFormatter = DateFormatter()
            userDateFormatter.dateFormat = "dd/MM/YY"
            
            cell.textLabel?.text = userDateFormatter.string(from: formattedDate ??  Date())
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Layout.Sections(rawValue: indexPath.section) else {
            fatalError()
        }
        //let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        switch section {
        case .allTrips:
            delegate?.didSelectAllTrips()
            self.navigationController?.dismiss(animated: true, completion: nil)
        case .pastTrips:
            //guard let idCourse = appDelegate?.courseWithDetailResponse?[indexPath.row].idCourse else {
            //    return
            //}
            delegate?.didSelectPastTrip(index: indexPath.row)
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - Actions

private extension PastTripsTableViewController {
    
    @IBAction func doCancelAction(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
