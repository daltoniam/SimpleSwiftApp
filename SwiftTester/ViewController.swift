//
//  ViewController.swift
//  SwiftTester
//
//  Created by Dalton Cherry on 11/20/15.
//  Copyright © 2015 Vluxe. All rights reserved.
//

import UIKit
import SwiftHTTP
import JSONJoy

struct Response : JSONJoy {
    var temp: String?
    init(_ decoder: JSONDecoder) {
        temp = decoder["query"]["results"]["channel"]["item"]["condition"]["temp"].string
    }
}

class ViewController: UIViewController {

    var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        label = UILabel(frame: CGRectMake(0, 60, self.view.bounds.size.width, 50))
        label.textAlignment = .Center
        self.view.addSubview(label)
        getWeather()
    }
    
    func getWeather() {
        do {
            let city = "Bakersfield"
            let state = "CA"
            let params = ["q": "select item.condition from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"\(city),\(state)\")", "format": "json", "env": "store://datatables.org/alltableswithkeys"]
            let opt = try HTTP.GET("https://query.yahooapis.com/v1/public/yql", parameters: params)
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    return //also notify app of failure as needed
                }
                print("opt finished: \(response.description)")
                let resp = Response(JSONDecoder(response.data))
                guard let temp = resp.temp else {return}
                dispatch_async(dispatch_get_main_queue(), {
                    self.label.text = "The temp in \(city) is: \(temp)"
                })
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }


}

