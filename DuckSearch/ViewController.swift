//
//  ViewController.swift
//  DuckSearch
//
//  Created by Sebastian Strus on 2017-02-21.
//  Copyright © 2017 Sebastian Strus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var resultView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    
    

    @IBAction func search(_ sender: Any) {
        
        let urlString = "https://api.duckduckgo.com/?q=\(searchField.text!)&format=json&pretty=1"
        
        
        
        if let safeUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: safeUrlString) {
            
            // can change to URLRequeest anddoesn't need to cast
            let request = URLRequest(url: url)  //MutableURLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) {
                (maybeData : Data?, response : URLResponse?, error : Error?) in
                
                if let unwrappedData = maybeData {
                    let options = JSONSerialization.ReadingOptions()
                    do {
                        if let parsedData = try JSONSerialization.jsonObject(with: unwrappedData, options: options) as? [String: Any] {
                            if let topics = parsedData["RelatedTopics"] as? [[String:Any]],
                               let first = topics.first,
                               let text = first["Text"] as? String {
                                print(text)
                                DispatchQueue.main.async {
                                    self.resultView?.text = text

                                }
                            } else {
                                print("Failed to find RelatedTopics in json object")
                                NSLog("Failed to find RelatedTopics in json object")
                            }
                        } else {
                            print("Failed to cast from json.")
                            NSLog("Failed to cast from json.")
                        }
                        // Hantera parse:ad data här
                        //print(parsedData)
                        
                    } catch let parseError {
                        print("Error parsing json: \(parseError)");
                        NSLog("Error parsing json: \(parseError)");
                    }
                } else {
                    print("No data.")
                    NSLog("No data.")
                }
            }
            task.resume()
        } else {
            //TODO: make alert
            print("Failed to create url.")
            NSLog("Failed to create url.")
        }
        
    }

}

