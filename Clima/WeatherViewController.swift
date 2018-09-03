//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, cityNameChanged {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "a1581dd0b6a58651c4a82c42091fd99d"
    
    var hereCity = ""
    
    //TODO: Declare instance variables here
    var weatherDataModel = WeatherDataModel()

    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var hereButton: UIButton!
    
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        hereButton.isHidden = true
        getLocation()
        hereCity = weatherDataModel.cityName
    }
    
    func getLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        //必須在 Info.plist 中增加 Privacy - Location Usage Description
        //和 Privacy - Location When In Use Usage Description 這兩個 keys
        locationManager.requestWhenInUseAuthorization()
        
        //Async method, will callback with didUpdateLocations or didFailWithError
        locationManager.startUpdatingLocation()
    }
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData (url: String, parameters:[String:String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success!");
                
                let weatherJSON: JSON = JSON(response.result.value!)
                
                let tempResult = weatherJSON["main"]["temp"].double!
                print(tempResult-273.15)
                print(weatherJSON["weather"][0]["id"].int!)
                self.updateWeatherData(dataJSON: weatherJSON)
            }
            else {
                print("Error \(response.result.error)")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    func updateWeatherData(dataJSON: JSON) {
        
        let tempResult = dataJSON["main"]["temp"].double!
        weatherDataModel.temperature = Int(tempResult-273.15)
        weatherDataModel.cityName = dataJSON["name"].string!
        weatherDataModel.condition = dataJSON["weather"][0]["id"].int!
        
        updateUIWithWeatherData()
        
    }

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData() {
        temperatureLabel.text = String(weatherDataModel.temperature)+"°C"
        cityLabel.text = weatherDataModel.cityName
        //print("***"+weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition))
        weatherIcon.image = UIImage(named: weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition))
        
    }
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            print("longitude:\(location.coordinate.longitude), latitude:\(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params :[String:String] = ["lat": latitude, "lon": longitude, "appid": APP_ID]
            getWeatherData(url:WEATHER_URL, parameters: params)
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    //Write the userEnteredANewCityName Delegate method here:
    func getWeatherByCityName(newCityName: String) {
        if hereCity == weatherDataModel.cityName {
            hereButton.isHidden = true
        }
        else {
            hereButton.isHidden = false
        }
        
        if newCityName != weatherDataModel.cityName {
            let params :[String:String] = ["q": newCityName, "appid": APP_ID]
            getWeatherData(url:WEATHER_URL, parameters: params)
        }
    }

    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            
            destinationVC.delegate = self
        
        }
    }
    
    @IBAction func herePressed(_ sender: UIButton) {
        getLocation()
        hereButton.isHidden = true
    }
    
    
}


