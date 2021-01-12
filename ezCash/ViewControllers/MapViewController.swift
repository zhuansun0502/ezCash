import UIKit
import MapKit
import CoreLocation
import Firebase
import SCLAlertView

class MapViewController: UIViewController {
        
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var centerViewButton: UIButton!
    @IBOutlet weak var userProfileButton: UIButton!
    @IBOutlet weak var newPostButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupListButton()
        setupCenterViewButton()
        setupNewPostButton()
        setupUserProfileButton()
        checkLocationServices()
        //FireBaseHelper().signOut()
    }
    
    func setupListButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let listButtonIcon = UIImage(systemName: "list.bullet", withConfiguration: config)
        
        listButton.setImage(listButtonIcon, for: .normal)
        listButton.frame.size = CGSize(width: 60.0, height: 60.0)
        listButton.backgroundColor = .white
        listButton.tintColor = .black
        listButton.layer.cornerRadius = 30
        listButton.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func setupCenterViewButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let centerViewButtonIcon = UIImage(systemName: "paperplane.fill", withConfiguration: config)
        
        centerViewButton.setImage(centerViewButtonIcon, for: .normal)
        centerViewButton.frame.size = CGSize(width: 60.0, height: 60.0)
        centerViewButton.backgroundColor = .white
        centerViewButton.tintColor = .systemBlue
        centerViewButton.layer.cornerRadius = 30
        centerViewButton.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func setupUserProfileButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let userProfileButtonIcon = UIImage(systemName: "person.crop.circle", withConfiguration: config)
        
        userProfileButton.setImage(userProfileButtonIcon, for: .normal)
        userProfileButton.frame.size = CGSize(width: 60.0, height: 60.0)
        userProfileButton.backgroundColor = .white
        userProfileButton.tintColor = .black
        userProfileButton.layer.cornerRadius = 30
        userProfileButton.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func setupNewPostButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let newPostButtonIcon = UIImage(systemName: "plus", withConfiguration: config)
        
        newPostButton.translatesAutoresizingMaskIntoConstraints = false
        newPostButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newPostButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
        newPostButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        newPostButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        newPostButton.layer.shadowColor = UIColor.black.cgColor
        newPostButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        newPostButton.layer.shadowRadius = 5
        newPostButton.layer.shadowOpacity = 0.5

        newPostButton.setImage(newPostButtonIcon, for: .normal)
        newPostButton.backgroundColor = .some(UIColor(red: 0, green: 0.7686, blue: 0.051, alpha: 1.0))
        newPostButton.tintColor = .white
        newPostButton.layer.cornerRadius = 35
    }
    
    @IBAction func listButtonTouched(_ sender: Any) {
        listButton.layer.add(animatedButton(), forKey: nil)
    }
    
    
    @IBAction func centerViewButtonTouched(_ sender: Any) {
        centerViewButton.layer.add(animatedButton(), forKey: nil)
        centerViewOnUserLocation()
    }
    
    
    @IBAction func userProfileButtonTouched(_ sender: Any) {
        userProfileButton.layer.add(animatedButton(), forKey: nil)
        
        FireBaseHelper().isLoggedIn() {
            (isLoggedIn) in
            
            if isLoggedIn {
                self.performSegue(withIdentifier: "userProfileView", sender: self)
            }
            else {
                self.performSegue(withIdentifier: "userLoginView", sender: self)
            }
        }
    }
    
    @IBAction func newPostButtonTouched(_ sender: Any) {
        newPostButton.layer.add(animatedButton(), forKey: nil)
        
        FireBaseHelper().isLoggedIn() {
            (isLoggedIn) in
            
            if !isLoggedIn {
                let appearance = SCLAlertView.SCLAppearance(kWindowWidth: 300)
                let alertView = SCLAlertView(appearance: appearance)
                alertView.showError("Cannot create post", subTitle: "You need to login first")
            }
            else {
                self.performSegue(withIdentifier: "newPostView", sender: self)
            }
        }
    }
    
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func animatedButton() -> CASpringAnimation {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.4
        pulse.fromValue = 0.85
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = .zero
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        return pulse
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        }
        else {
            // Error handle popup
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Popup alert
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case.restricted:
            // Popup alert
            break
        case .authorizedAlways:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        @unknown default:
            break
        }
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            mapView.tintColor = .systemBlue
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    /*func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }*/
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
