//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit


//Write the protocol declaration here:
protocol cityNameChanged {
    func getWeatherByCityName(newCityName: String)
}

class ChangeCityViewController: UIViewController, UITextFieldDelegate {
    
    //Declare the delegate variable here:
    var delegate: cityNameChanged?
    
    //This is the pre-linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeCityTextField.delegate = self;
    }

    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        //1 Get the city name the user entered in the text field
        let newCityName = changeCityTextField.text
        
        //2 If we have a delegate set, call the method userEnteredANewCityName
        if let cityName = newCityName {
            delegate?.getWeatherByCityName(newCityName: cityName)
        }
        
        //3 dismiss the Change City View Controller to go back to the WeatherViewController
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getWeatherPressed(self)
 
        //endEditing 會解除 keyboard，但由於前一個命令呼叫 getWeatherPressed() 會 dismiss 此 view controller，所以 keyboard 會自動解除
        //self.view.endEditing(true)
        
        return false
    }
    
    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
