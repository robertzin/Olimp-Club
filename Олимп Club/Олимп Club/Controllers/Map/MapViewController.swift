//
//  MapViewController.swift
//  SportLocator
//
//  Created by Robert Zinyatullin on 07.03.2023.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var filterTextField: UITextField!
    @IBOutlet weak var filterButtonsStackView: UIStackView!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBAction func currentLocationButtonAction(_ sender: Any) {
//        let location = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
//        mapView.centerToLocation(location, regionRadius: 3000)
        self.checkLocationAuthorization()
    }
    
    @IBOutlet weak var currentLocationButtonYConstraint: NSLayoutConstraint!
    
    // MARK: - Private properties
    private let locationManager = CLLocationManager()
    private var regionInMeters: Double = 200
    private let filters = ["Футбол", "Баскетбол", "Волейбол", "Хоккей"]
    
    private var infoView = InfoView(frame: CGRect(x: 0, y: 0, width: 345, height: 210))
    private var directionsArray: [MKDirections] = []
    
//    private let currentLocation = CLLocationCoordinate2D(latitude: 55.791581, longitude: 49.131494)
    private var currentFilter: Sports? = nil
    
    private var currentLocationBottomPositionYAxis: Double = 0
    private var currentLocationTopPositionYAxis: Double = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationService()
        setupInitialMapCoordinates()
        setupUI()
        
//        let pin = MKPointAnnotation()
//        pin.coordinate = currentLocation
//        mapView.addAnnotation(pin)
        
        mapView.delegate = self
        filterTextField.delegate = self
    }
    
    private func setupInitialMapCoordinates() {
        mapView.addAnnotations(MapLocation.kazanFootballMapAnnotations)
        mapView.addAnnotations(MapLocation.kazanBasketballMapAnnotations)
        mapView.addAnnotations(MapLocation.kazanVolleyballMapAnnotations)
        mapView.addAnnotations(MapLocation.kazanHockeyMapAnnotations)
        
        mapView.register(MapLocationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    // MARK: - Private funcs
    private func setupUI() {
        filterTextField.addLeft(image: UIImage(systemName: "magnifyingglass")!)
        
        filterTextField.corneredRadius(radius: 10)
        filterTextField.layer.masksToBounds = false
        filterTextField.layer.shadowRadius = 4.0
        filterTextField.layer.shadowColor = UIColor.gray.cgColor
        filterTextField.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        filterTextField.layer.shadowOpacity = 1
        
        for i in filters.indices {
            let button = UIButton()
            
            button.tag = i + 42
            button.layer.cornerRadius = 10
            button.setTitle(filters[i], for: .normal)
            button.setTitleColor(Constants.Colors.icon, for: .normal)
            
            button.titleLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 14)
            button.backgroundColor = .white
            button.addTarget(self, action: #selector(filterButtonPressed(sender:)), for: .touchUpInside)
            button.titleLabel?.numberOfLines = 1
            
            if #available(iOS 15.0, *) {
                var configuration = UIButton.Configuration.filled()
                configuration.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 10)
                configuration.baseBackgroundColor = .white
                button.configuration = configuration
            } else {
                button.titleEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
            }
            
            filterButtonsStackView.addArrangedSubview(button)
        }
        
        view.addSubview(infoView)
        infoView.isHidden = true
        
        infoView.corneredRadius(radius: 10)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.widthAnchor.constraint(equalToConstant: 345).isActive = true
        infoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoView.heightAnchor.constraint(equalToConstant: 210).isActive = true
        infoView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45).isActive = true
    }
    
    private func presentDetailsView(with annotation: MKAnnotation) {
        
        guard let currentLocation = locationManager.location?.coordinate else { return }
        
        let storyboard = UIStoryboard(name: "Details", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsViewController else { return }
        
        let navVC = UINavigationController(rootViewController: vc)
        navVC.setNavigationBarHidden(true, animated: false)
        
        let distanceToCurrentLocation = MKMapPoint(annotation.coordinate)
            .distance(to: MKMapPoint(currentLocation))
        
        vc.annotation = annotation as? MapLocation
        vc.distance = distanceToCurrentLocation

        self.present(navVC, animated: true)
    }
    
    @objc private func filterButtonPressed(sender: UIButton) {
        if let filter = sender.title(for: .normal) {
            
            switch filter {
            case "Футбол":
                if let button = filterButtonsStackView.viewWithTag(42) as? UIButton {
                    button.isSelected = !button.isSelected
                    self.selectButton(button: button, sportType: .football)
                }
            case "Баскетбол":
                if let button = filterButtonsStackView.viewWithTag(43) as? UIButton {
                    button.isSelected = !button.isSelected
                    self.selectButton(button: button, sportType: .basketball)
                }
            case "Волейбол":
                if let button = filterButtonsStackView.viewWithTag(44) as? UIButton {
                    button.isSelected = !button.isSelected
                    self.selectButton(button: button, sportType: .volleyball)
                }
            case "Хоккей":
                if let button = filterButtonsStackView.viewWithTag(45) as? UIButton {
                    button.isSelected = !button.isSelected
                    self.selectButton(button: button, sportType: .hockey)
                }
            default:
                break
            }
        }
    }
    
    private func selectButton(button: UIButton, sportType: Sports) {
        if button.isSelected {
            if #available(iOS 15.0, *) {
                var configuration = UIButton.Configuration.filled()
                configuration.baseBackgroundColor = Constants.Colors.button
                button.configuration = configuration
            } else {
                button.backgroundColor = Constants.Colors.button
            }
            button.setTitleColor(.white, for: .normal)
            self.filterAnnotations(by: sportType)
            self.unselectAnotherButtonDespite(button)
        } else {
            if #available(iOS 15.0, *) {
                var configuration = UIButton.Configuration.filled()
                configuration.baseBackgroundColor = .white
                button.configuration = configuration
            } else {
                button.backgroundColor = .white
            }
            button.setTitleColor(Constants.Colors.icon, for: .normal)
            removeAnnotationsFilter()
        }
    }
    
    private func unselectAnotherButtonDespite(_ selectedButton: UIButton) {
        for button in filterButtonsStackView.arrangedSubviews as! [UIButton] {
            if button.tag != selectedButton.tag {
                
                button.isSelected = false
                
                if #available(iOS 15.0, *) {
                    var configuration = UIButton.Configuration.tinted()
                    configuration.title = button.currentTitle
                    configuration.baseBackgroundColor = .white
                    configuration.baseForegroundColor = Constants.Colors.icon
                    
                    button.configuration = configuration
                } else {
                    button.backgroundColor = .white
                }
                button.setTitleColor(Constants.Colors.icon, for: .normal)
            }
        }
    }
    
    private func filterAnnotations(by type: Sports) {
        self.currentFilter = type
        
        self.hideAllDirections()
        self.infoView.isHidden = true
        
        for annotation in mapView.annotations {
            if let anno = annotation as? MapLocation {
                mapView.deselectAnnotation(anno, animated: true)
                
                if anno.sportType != type {
                    if let annotationView = mapView.view(for: anno) {
                        annotationView.isHidden = true
                    }
                } else {
                    if let annotationView = mapView.view(for: anno) {
                        annotationView.isHidden = false
                    }
                }
            }
        }
    }
    
    private func filterAnnotations(by string: String) {
        self.hideAllDirections()
        self.infoView.isHidden = true
        
        for annotation in mapView.annotations {
            if let anno = annotation as? MapLocation {
                mapView.deselectAnnotation(anno, animated: true)
                
                if let _ = anno.title!.range(of: string, options: .caseInsensitive) {
                    if let annotationView = mapView.view(for: anno) {
                        if self.currentFilter == anno.sportType {
                            annotationView.isHidden = false
                        }
                    }
                } else {
                    if let annotationView = mapView.view(for: anno) {
                        annotationView.isHidden = true
                    }
                }
            }
        }
    }
    
    private func removeAnnotationsFilter() {
        self.currentFilter = nil
        
        self.hideAllDirections()
        self.infoView.isHidden = true
        
        for annotation in mapView.annotations {
            if annotation is MapLocation {
                mapView.deselectAnnotation(annotation, animated: true)
                if let annotationView = mapView.view(for: annotation) {
                    annotationView.isHidden = false
                }
            }
        }
        
        self.hideAllDirections()
        self.infoView.isHidden = true
    }
    
    private func removeAllFilters() {
        if self.currentFilter == nil {
            for annotation in mapView.annotations {
                if let anno = annotation as? MapLocation {
                    if let annotationView = mapView.view(for: anno) {
                        annotationView.isHidden = false
                    }
                }
            }
            return
        }
        
        for annotation in mapView.annotations {
            if let anno = annotation as? MapLocation {
                if let annotationView = mapView.view(for: anno) {
                    
                    if self.currentFilter == anno.sportType {
                        annotationView.isHidden = false
                    }
                }
            }
        }
    }
    
    private func applyFiltersOnRegionChange() {
        if self.currentFilter == nil {
            return
        }
        
        for annotation in mapView.annotations {
            if let anno = annotation as? MapLocation {
                if let annotationView = mapView.view(for: anno) {
                    
                    if anno.sportType == currentFilter {
                        annotationView.isHidden = false
                    } else {
                        annotationView.isHidden = true
                    }
                }
            }
        }
    }
    
    private func hideAllDirections() {
        mapView.removeOverlays(mapView.overlays)
        let _ = directionsArray.map { $0.cancel }
        directionsArray = []
    }
    
    private func resetMapView(withNew directions: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel }
        directionsArray = []
    }
    
    private func getDirections(to coordinate: CLLocationCoordinate2D) {
        
        guard let currentLocation = locationManager.location?.coordinate else { return }
        
        let request = createDirectionsRequest(from: currentLocation, to: coordinate)
        let directions = MKDirections(request: request)
        resetMapView(withNew: directions)
        
        directions.calculate { [unowned self] (response, error) in
            guard let response = response else { return }
            guard let route = response.routes.first else { return }
            
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect,
                                           edgePadding: UIEdgeInsets(top: 200, left: 50, bottom: 350, right: 50),
                                           animated: true)
        }
    }
    
    private func createDirectionsRequest(from coordinate: CLLocationCoordinate2D,
                                         to destinationCoordinate: CLLocationCoordinate2D) -> MKDirections.Request {
        
        let destinationCoordinate = destinationCoordinate
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        return request
    }
    
    private func checkLocationService() {
        DispatchQueue.global().async {
            guard CLLocationManager.locationServicesEnabled() else {
                // Show alert letting the user know they have to turn this on.
                self.showAlert(title: "Ошибка",
                               message: "Включите использование геопозиции")
                
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
                return
            }
        }
        
        setupLocationManager()
        checkLocationAuthorization()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            showMyLocationAndPlayground()
        case .denied, .restricted:
            //             Show alert instructing them how to turn on permissions
            showAlert(title: "Ошибка",
                      message: "Нет прав на использовние Ваших координат. Разрешите использовать Ваши координаты в настройках устройства")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    
    private func showMyLocationAndPlayground() {
        if let location = locationManager.location?.coordinate {
            // Zoom to userLocation
            let rect = MKMapRect(origin:
                                    MKMapPoint(CLLocationCoordinate2D(latitude: location.latitude,
                                                                      longitude: location.longitude)),
                                 size: MKMapSize(width: 150, height: 150))

            let padding = UIEdgeInsets(top: 55, left: 20.0, bottom: 20.0, right: 20.0)
            mapView.setVisibleMapRect(rect, edgePadding: padding, animated: true)
        }
    }
}

// MARK: - Extension: CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.centerToLocation(location, regionRadius: 1000)
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

// MARK: - Extension: MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MapLocation else {
            
            let reuseIdentifier = "userPin"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? UserLocationView
            
            if annotationView == nil {
                annotationView = UserLocationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                annotationView?.canShowCallout = false
                annotationView?.image = UIImage(named: "userLocation")
            } else {
                annotationView?.annotation = annotation
            }
            annotationView?.detailCalloutAccessoryView = nil
            return annotationView
            
        }
        
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MapLocationView
        
        if annotationView == nil {
            annotationView = MapLocationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = false
            annotationView?.image = UIImage(named: "mapLocationLogo")
        } else {
            annotationView?.annotation = annotation
        }
        
        let calloutView = infoView
        annotationView?.detailCalloutAccessoryView = calloutView
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let currentLocation = locationManager.location?.coordinate else { return }
        
        if view.annotation is MapLocation {
            view.image = UIImage(named: "pinSelectedLogo")
            
            guard let annotation = view.annotation as? MapLocation else { return }
            let distanceToCurrentLocation = MKMapPoint(annotation.coordinate)
                .distance(to: MKMapPoint(currentLocation))
            
            self.infoView.configure(annotation: annotation,
                                    distance: distanceToCurrentLocation,
                                    completion: {
                self.infoView.buttonDelegate = self
                self.infoView.isHidden = false
                self.currentLocationButtonYConstraint.constant -= (self.infoView.frame.height + 12)
                
            })
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.annotation is MapLocation {
            view.image = UIImage(named: "mapLocationLogo")
            infoView.isHidden = true
            self.hideAllDirections()
            self.currentLocationButtonYConstraint.constant += (self.infoView.frame.height + 12)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = UIColor(named: "AccentColor")
        renderer.lineDashPattern = [NSNumber(value: 8), NSNumber(value:8)]
        renderer.lineWidth = 4
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.applyFiltersOnRegionChange()
    }
}

extension MapViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if updatedText.count > 1 {
                self.filterAnnotations(by: updatedText)
            } else {
                self.removeAllFilters()
            }
        }
        return true
    }
}

extension MapViewController: InfoViewButtonsDelegate {
    func makeRouteButtonClicked(annotation: MKAnnotation) {
        self.getDirections(to: annotation.coordinate)
    }
    
    func detailsButtonClicked(annotation: MKAnnotation) {
        self.presentDetailsView(with: annotation)
    }
}
