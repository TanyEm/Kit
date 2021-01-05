import Foundation

struct IDData: Codable {
    var oid: String
    
    enum CodingKeys: String, CodingKey {
        case oid = "$oid"
    }
}

struct DescriptionData: Codable {
    var value: String
}

struct CoordinatesData: Codable {
    var coordinates: [Double]
}

struct NameData: Codable {
    var value: String
}

struct RestaurantResponseData: Codable {
    var description: [DescriptionData]
    var id: IDData
    var listImage: String
    var location:CoordinatesData
    var name:[NameData]
    
    enum CodingKeys: String, CodingKey {
        case description = "short_description"
        case id = "id"
        case listImage = "listimage"
        case location = "location"
        case name = "name"
    }
}

struct RestaurantRequestModel: Codable {
    var results: [RestaurantResponseData]
}
