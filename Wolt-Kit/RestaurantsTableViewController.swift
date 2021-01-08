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
    
    
    var refreshContro = UIRefreshControl()
    let locationManager = CLLocationManager()
    var timer = Timer()

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

//        self.timer = Timer(timeInterval: 10.0, target: self, selector: #selector(refresh), userInfo: nil, repeats: true)
//        RunLoop.main.add(self.timer, forMode: RunLoop.Mode.default)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        // a refresh of the table
        getData()
    }
    
    // MARK: - Get Data
    
    func getData() {
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
            cell.img.layer.cornerRadius = 10
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            var item = restaurantList[indexPath.row]
            let rest = LikeModel(id: item.id, isLked: !item.isLiked)
            
            if item.isLiked {
                viewModel.removeLike(id: rest.id)
            } else {
                viewModel.appendLike(likeRest: rest)
            }
                
            item.isLiked = !item.isLiked
            
            restaurantList[indexPath.row].isLiked = item.isLiked
            
            configureLike(for: cell as! RestaurantTableViewCell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

}
