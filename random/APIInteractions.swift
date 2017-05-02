//
//  APIInteractions.swift
//  random
//
//  Created by Chris Chadillon on 2017-05-02.
//  Copyright © 2017 Chris Chadillon. All rights reserved.
//

import Foundation


class APIInteractions {
    class func getRandomNumbers(theURL:URL, onCompletion: @escaping (String)->Void) {
        var request = URLRequest(url: theURL)
        request.httpMethod = "GET"
        let searchTask = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error != nil {
                print("Error fetching products: \(String(describing: error))")
                onCompletion("false")
                return
            }
            do {
                let resultsDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                onCompletion(resultsDictionary!["Result"]! as! String)
            } catch {
                print("Error parsing JSON: \(error)")
                onCompletion("false")
                return
            }
        }
        searchTask.resume()
    }
}
