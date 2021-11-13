//
//  MapViewController.swift
//  MuvilApp
//
//  Created by Fernando Pérez on 10/15/21.
//

import UIKit
import MapKit


private enum Static {
    enum Values: Double {
        case spanFactor = 0.2
    }
    enum SegueIds: String {
        case showHistorySID = "ShowHistorySID"
    }
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTitleView: MapTitleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup de mapa
        mapView.showsUserLocation = true
        let defaultLocation = CLLocationCoordinate2D.init(latitude: -12.09476657372091, longitude: -77.01566388518756)
        let region = MKCoordinateRegion( center: defaultLocation, latitudinalMeters: CLLocationDistance(exactly: 20000)!, longitudinalMeters: CLLocationDistance(exactly: 20000)!)
        mapView.setRegion(region, animated: true)
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        mostrarTrayectoEnCurso()
    }
    
    func mostrarTrayectoEnCurso(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate

        if (appDelegate?.courseSelected == 0) {
            return
        } else {
            limpiarTodosLosObjetos()
            appDelegate?.courseSelected = 0
        }
        
        
        mapTitleView.titleLabel.text = "Trayecto en curso"
        
        //setup de pines de casa y colegio
        
        let annotationCasa = MKPointAnnotation()
        let centerCoordinateCasa = CLLocationCoordinate2D(latitude: appDelegate?.loginResponse?.latitude ?? 0, longitude: appDelegate?.loginResponse?.longitude ?? 0)
        annotationCasa.coordinate = centerCoordinateCasa
        annotationCasa.title = "Casa"
        mapView.addAnnotation(annotationCasa)
        
        let annotationColegio = MKPointAnnotation()
        let centerCoordinateColegio = CLLocationCoordinate2D(latitude: appDelegate?.schoolResponse?.latitude ?? 0, longitude: appDelegate?.schoolResponse?.longitude ?? 0)
        annotationColegio.coordinate = centerCoordinateColegio
        annotationColegio.title = "Colegio"
        mapView.addAnnotation(annotationColegio)
        
        //setup de ruta
        var lineCoordinates: [CLLocationCoordinate2D] = []
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        var ruta = appDelegate?.vehiculeLocationResponse
        ruta = ruta?.sorted {
            dateFormatter.date(from: $0.timestamp)! < dateFormatter.date(from: $1.timestamp)!
        }
        ruta?.forEach(){ lineCoordinates.append(CLLocationCoordinate2D.init(latitude: $0.latitude, longitude: $0.longitude))}
        let polyline = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
        mapView.addOverlay(polyline)
        
        //ubicacion de la movilidad
        let annotationMovilidad = MKPointAnnotation()
        annotationMovilidad.coordinate = lineCoordinates.last ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
        annotationMovilidad.title = "Movilidad"
        mapView.addAnnotation(annotationMovilidad)
    }
    
    func limpiarTodosLosObjetos(){
        let annotations = mapView.annotations.filter({ !($0 is MKUserLocation) })
        mapView.removeAnnotations(annotations)
        
        mapView.removeOverlays(mapView.overlays)
        
    }
    
    func mostrarTrayectoSeleccionado(index: Int) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate

        if (appDelegate?.courseSelected == index) {
            return
        } else {
            limpiarTodosLosObjetos()
            appDelegate?.courseSelected = index
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let string: String? = appDelegate?.courseWithDetailResponse?[index].date ?? " "
        let formattedDate: Date? = dateFormatter.date(from: string ?? " ")
        let userDateFormatter = DateFormatter()
        userDateFormatter.dateFormat = "dd/MM/YY"
        
        mapTitleView.titleLabel.text = userDateFormatter.string(from: formattedDate ??  Date())
        
        //setup de pines de casa y colegio
        
        let annotationCasa = MKPointAnnotation()
        let centerCoordinateCasa = CLLocationCoordinate2D(latitude: appDelegate?.loginResponse?.latitude ?? 0, longitude: appDelegate?.loginResponse?.longitude ?? 0)
        annotationCasa.coordinate = centerCoordinateCasa
        annotationCasa.title = "Casa"
        mapView.addAnnotation(annotationCasa)
        
        let annotationColegio = MKPointAnnotation()
        let centerCoordinateColegio = CLLocationCoordinate2D(latitude: appDelegate?.schoolResponse?.latitude ?? 0, longitude: appDelegate?.schoolResponse?.longitude ?? 0)
        annotationColegio.coordinate = centerCoordinateColegio
        annotationColegio.title = "Colegio"
        mapView.addAnnotation(annotationColegio)
        
        if (appDelegate?.courseWithDetailResponse?[index].todaysLocations.count == 0){
            return
        }
        
        //setup de ruta
        var lineCoordinates: [CLLocationCoordinate2D] = []
        var ruta = appDelegate?.courseWithDetailResponse?[index].todaysLocations
        ruta = ruta?.sorted {
            dateFormatter.date(from: $0.timestamp)! < dateFormatter.date(from: $1.timestamp)!
        }
        ruta?.forEach(){ lineCoordinates.append(CLLocationCoordinate2D.init(latitude: $0.latitude, longitude: $0.longitude))}
        let polyline = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
        mapView.addOverlay(polyline)
        
        //ubicacion de la movilidad
        let annotationMovilidad = MKPointAnnotation()
        annotationMovilidad.coordinate = lineCoordinates.last ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
        annotationMovilidad.title = "Movilidad"
        mapView.addAnnotation(annotationMovilidad)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Static.SegueIds.showHistorySID.rawValue,
           let navigationController = segue.destination as? UINavigationController,
           let pastTripsViewController = navigationController.viewControllers.first as? PastTripsTableViewController {
            pastTripsViewController.delegate = self
        }
    }
    
    // MARK: - Actions

    // TODO: conecta la accion con el boton q debes agregar a la view
    @IBAction func doCenterOnUserLocationAction(_ sender: Any) {
        let userLocation = mapView.userLocation
        
        let region = MKCoordinateRegion( center: userLocation.coordinate, latitudinalMeters: CLLocationDistance(exactly: 800)!, longitudinalMeters: CLLocationDistance(exactly: 800)!)
        mapView.setRegion(region, animated: true)
    }
}

class CustomAnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            displayPriority = .required
            
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let routePolyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: routePolyline)
                renderer.strokeColor = UIColor.systemBlue
                renderer.lineWidth = 7
                return renderer
            }

            return MKOverlayRenderer()
    }
}

extension MapViewController: PastTripsDelegate {
    func didSelectAllTrips() {

        mostrarTrayectoEnCurso()
    }
    
    func didSelectPastTrip(index: Int) {
 
        mostrarTrayectoSeleccionado(index: index)
    }
}
