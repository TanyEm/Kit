//
//  RestaurantsService.swift
//  Wolt-Kit
//
//  Created by Tatiana Podlesnykh on 4.1.2021.
//

import Foundation

import Foundation
import CoreLocation

class RestaurantsService {
    
    var list = [RestaurantResponseData]()
    var lat: Double?
    var lon: Double?
    
    var userLocation = CLLocationCoordinate2D()
    
    func getRestaurantList(_ manager: CLLocationManager, _ listed: @escaping ([RestaurantResponseData]) -> ()) {
        let request = RestaurantListRequest()
        
        if manager.location?.coordinate == nil {
            lat = 50.1
            lon = 14.6
        } else {
            userLocation = manager.location!.coordinate
            lat = userLocation.latitude
            lon = userLocation.longitude
        }
        
        request.getRestaurantsList(lat: lat!, lon: lon!) { (result) in
            DispatchQueue.main.async {
                if result.count != nil {
                    self.list = result
                    listed(result)
                } else {
                    print("Error: failed to get restaurant list")
                }
            }
        }
        
    }
}
