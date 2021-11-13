//
//  LoginViewController.swift
//  MuvilApp
//
//  Created by Fernando Pérez on 10/15/21.
//

import UIKit
import SVProgressHUD
import CoreLocation

private enum Static {
    enum Segues: String {
        case showTabBar = "ShowTabBarSID"
    }
}

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    public let client = Client()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        LocationManager.shared.requestLocationAuthorization()
    }
    
    // MARK: - Actions

    @IBAction func doLoginAction(_ sender: Any) {
                
        guard isUsernameValid(username: self.usernameTextField.text ?? " ", password: self.passwordTextField.text ?? " "),
              let username = self.usernameTextField.text,
              let password = self.passwordTextField.text else {
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        SVProgressHUD.show()
        client.login(username,
                     password) { response in
            
            appDelegate?.loginResponse = response

            
            //consumo operador
            guard self.operatorExists(id: appDelegate?.loginResponse?.operator_idOperator),
                  let operatorID = appDelegate?.loginResponse?.operator_idOperator else {
                return
            }
            
            self.client.getOperatorByID(operatorID) { response in
                
                appDelegate?.operatorResponse = response
                
            } failure: { error in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                debugPrint(error)
            }
            
            //consumo school
            guard self.schoolExists(id: appDelegate?.loginResponse?.school_idSchool),
                  let schoolID = appDelegate?.loginResponse?.school_idSchool else {
                return
            }
            
            self.client.getSchoolByID(schoolID) { response in
                
                appDelegate?.schoolResponse = response

            } failure: { error in
                //SVProgressHUD.showError(withStatus: error.localizedDescription)
                SVProgressHUD.showError(withStatus: "No se pudo establecer conexión con la nube")
                debugPrint(error)
            }
            
            //consumir course con operator id
            
            self.client.getCurrentCourseByOperatorId(operatorID) { response in
                
                appDelegate?.courseResponse = response
                
                //consumir locations con course id
                
                guard self.courseExists(id: appDelegate?.courseResponse?.idCourse),
                      let courseID = appDelegate?.courseResponse?.idCourse else {
                    return
                }
                
                self.client.getLocationsByCourseId(courseID) { response in
                    
                    appDelegate?.vehiculeLocationResponse = response
                    SVProgressHUD.dismiss()
                    self.performSegue(withIdentifier: Static.Segues.showTabBar.rawValue,
                                      sender: response)
                    
                } failure: { error in
                    SVProgressHUD.showError(withStatus: "No se pudo establecer conexión con la nube")
                    debugPrint(error)
                }
                
            } failure: { error in
                SVProgressHUD.showError(withStatus: "No se pudo establecer conexión con la nube")
                debugPrint(error)
            }
            
            
            
            //consumir alertas con idParent
            guard self.operatorExists(id: appDelegate?.loginResponse?.operator_idOperator),
                  let idParent = appDelegate?.loginResponse?.idParent else {
                return
            }
            
            self.client.getNotifications(idParent) { response in
                let filteredResponse = response.filter{ $0.parent_idParent == idParent}
                appDelegate?.notificationResponse = filteredResponse
                
            } failure: { error in
                SVProgressHUD.showError(withStatus: "No se pudo establecer conexión con la nube")
                debugPrint(error)
            }
            
            //consumir trayectos
            
            self.client.getCoursesForOperator(operatorID) { response in
                
                appDelegate?.courseWithDetailResponse = response
                
            } failure: { error in
                SVProgressHUD.showError(withStatus: "No se pudo establecer conexión con la nube")
                debugPrint(error)
            }

        } failure: { error in
            if ("Empty response could not be serialized to type: LoginResponse. Use Empty as the expected type for such responses." == error.localizedDescription) {
                SVProgressHUD.showError(withStatus: "Datos incorrectos")
                return
            }
            SVProgressHUD.showError(withStatus: "No se pudo establecer conexión con la nube")
            debugPrint(error)
        }
        
        
    }
}

class LocationManager: NSObject, CLLocationManagerDelegate {

    static let shared = LocationManager()
    private var locationManager: CLLocationManager = CLLocationManager()
    private var requestLocationAuthorizationCallback: ((CLAuthorizationStatus) -> Void)?

    public func requestLocationAuthorization() {
        self.locationManager.delegate = self
        let currentStatus = CLLocationManager.authorizationStatus()

        // Only ask authorization if it was never asked before
        guard currentStatus == .notDetermined else { return }

        // Starting on iOS 13.4.0, to get .authorizedAlways permission, you need to
        // first ask for WhenInUse permission, then ask for Always permission to
        // get to a second system alert
        if #available(iOS 13.4, *) {
            self.requestLocationAuthorizationCallback = { status in
                if status == .authorizedWhenInUse {
                    self.locationManager.requestAlwaysAuthorization()
                }
            }
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            self.locationManager.requestAlwaysAuthorization()
        }
    }

    // MARK: - CLLocationManagerDelegate
    public func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus) {
        self.requestLocationAuthorizationCallback?(status)
    }
}

private extension LoginViewController {
    func isUsernameValid(username: String, password: String) -> Bool {
        if (!isValidEmail(username)) {
            SVProgressHUD.showError(withStatus: "El mail es incorrecto")
            return false
        }
        if (password.count<6) {
            SVProgressHUD.showError(withStatus: "La contraseña es incorrecta")
            return false
        }
        
        return true
    }
    func operatorExists(id: Int?) -> Bool {
        return id != 0
    }
    func schoolExists(id: Int?) -> Bool {
        return id != 0
    }
    func courseExists(id: Int?) -> Bool {
        return id != 0
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
