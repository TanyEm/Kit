//
//  RestaurantsTableViewController.swift
//  Wolt-Kit
//
//  Created by Tatiana Podlesnykh on 4.1.2021.
//

import UIKit
import CoreLocation

class RestaurantsTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    private let viewModel = RestaurantCellViewModel()
    private var restaurantList = [Restaurant]()
    
    let locationManager = CLLocationManager()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.viewModel.getRestaurantsWithLikes(self.locationManager) { list in
            DispatchQueue.main.async {
                self.restaurantList = list
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Cell configuration
    
    func configureLike(for cell: RestaurantTableViewCell, with item: Restaurant) {
        
        if item.isLiked {
            cell.status.image = #imageLiteral(resourceName: "like")
        } else {
            cell.status.image = #imageLiteral(resourceName: "without_like")
        }
    }
    
    func congigureImg(for cell: RestaurantTableViewCell, with item: Restaurant) {
                
        DispatchQueue.main.async {
            guard
                let url = URL(string: item.img),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) else {
                    return
                }
            cell.img.image = image
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurantList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestaurantTableViewCell

        let rest = self.restaurantList[indexPath.row]
        
        cell.title.text = rest.title
        cell.descript.text = rest.description
        
        configureLike(for: cell, with: rest)
        congigureImg(for: cell, with: rest)
        
        return cell
    }

}
