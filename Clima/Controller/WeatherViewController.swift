//
//  ViewController.swift
//  Clima
//
//  Created by Jewell Huffman on 01/09/2019.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
//MARK: - Properties
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()

    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
         searchTextField.endEditing(true)
         print(searchTextField.text!)
     }
     
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         searchTextField.endEditing(true)
         print(searchTextField.text!)
         return true
     }
     
     func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
         if textField.text != "" {
             return true
         } else {
             textField.placeholder = "Type something"
             return false
         }
     }
     
     func textFieldDidEndEditing(_ textField: UITextField) {
         
         if let city = searchTextField.text {
             weatherManager.fetchWeather(cityName: city)
         }
         searchTextField.text = ""
     }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
           //wrap UI update code in Dispatch Async closure
           DispatchQueue.main.async {
               self.temperatureLabel.text = weather.temperatureString
               self.conditionImageView.image = UIImage(systemName: weather.conditionName)
               self.cityLabel.text = weather.cityName
           }
       }
       
       func didFailWithError(error: Error) {
           print(error)
       }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
