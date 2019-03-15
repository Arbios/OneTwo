//
//  ViewController.swift
//  OneTwoThree
//
//  Created by ARBI BASHAEV on 14/03/2019.
//  Copyright © 2019 ARBI BASHAEV. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyRun()
//        postRun()
    }
    
    func bodyRun() {
        
        let token = "80614a86-4b9f-4df7-9e91-7500e2a239ed"
        let url = URL(string: "http://system123.ru/api/ik/silent_calculate/124479")!
        
        // prepare json data
        let json: [String: Any] = ["State": 1]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue( "\(token)", forHTTPHeaderField: "XAUTHSUBJECT")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            print(data)
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }.resume()
        
    }
    
    
    
    func postRun() {
        // Посылаем POST запрос на сервер и забираем JSON
        guard let url = URL(string: "http://system123.ru/api/get_project_ik") else { return }
        let parameters = ["dir_id" : 124472]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            guard error == nil else { return }
            
            do {
                let outputJson = try JSONDecoder().decode(Output.self, from: data)
                print(outputJson.directory.id)
                print(outputJson.directory.name)
                print(outputJson.directory.type)
                print(outputJson.directory.id)
            } catch let error {
                print(error)
            }
            }.resume()
    }
}
