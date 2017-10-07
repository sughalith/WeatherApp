//
//  ViewController.swift
//  Whats the weather
//
//  Created by Arkadiusz Stankiewicz on 07.10.2017.
//  Copyright © 2017 Arkadiusz Stankiewicz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBAction func getWeather(_ sender: Any) {
        
        if let url = URL(string: "https://www.weather-forecast.com/locations/" + cityTextField.text!.replacingOccurrences(of: " ", with: "-").replacingOccurrences(of: "ń", with: "n") + "/forecasts/latest"){
        let request = NSMutableURLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            var message = ""
            if error != nil{
                print(error)
            }
            else{
                if let unwrappedData = data{
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                    var stringSeperator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                    if let contentArray = dataString?.components(separatedBy: stringSeperator){
                        if contentArray.count > 1{
                            stringSeperator = "</span>"
                            
                            let newContentArray = contentArray[1].components(separatedBy: stringSeperator)
                            if newContentArray.count > 1{
                                message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "^")
                            }
                        }
                    }
                }
            }
            if message == ""{
                message = "The weather there couldn't be found. Please try again."
            }
            DispatchQueue.main.sync(execute: {
                self.resultLabel.text = message
            })
        }
        task.resume()
        }
        else{
            resultLabel.text = "The weather there couldn't be found. Please try again"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

