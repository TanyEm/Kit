import Foundation
import CoreLocation

public class RestaurantCellViewModel: ObservableObject {
    
    private let restService: RestaurantsService
    private let likeService: LikeManager
    
    var restaurantsToShow = [Restaurant]()
    
    init() {
        self.restService = RestaurantsService()
        self.likeService = LikeStatusManager()
    }
        
    func removeLike(id: String){
        do {
            try likeService.removeLike(id: id)
        } catch {
            print("Unexpected error: \(error.localizedDescription).")
        }
    }
    
    func appendLike(likeRest: LikeModel) {
        likeService.appendLike(likeRest: likeRest)
    }
    
    
    func getRestaurantsWithLikes(_ manager: CLLocationManager, _ result: @escaping ([Restaurant]) -> ()) {
        restService.getRestaurantList(manager) { (restaurantsList) in
                        
            for restaurant in restaurantsList {
                var isLiked = false
                do {
                    let likeStatus = try self.likeService.getLikeStatus(id: restaurant.id.oid)
                    isLiked = likeStatus.isLked
                } catch {
                    //The restaurant without like
                }
                

                let restaurantToShow = Restaurant(
                    id: restaurant.id.oid,
                    title: restaurant.name[0].value,
                    description: (!restaurant.description.isEmpty) ? restaurant.description[0].value : "",
                    isLiked: isLiked,
                    img: (!restaurant.listImage.isEmpty) ? restaurant.listImage : ""
                )
                if self.restaurantsToShow.count < 15 {
                    self.restaurantsToShow.append(restaurantToShow)
                }

            }
            
            result(self.restaurantsToShow)
        }
    }
}
