import Foundation

enum DataError: Error {
    case likeNotFound(id: String)
}

protocol LikeManager {
    func appendLike(likeRest: LikeModel)
    func getLikeStatus(id: String) throws -> LikeModel
    func removeLike(id: String) throws
}

class LikeStatusManager: LikeManager {
    
    var items = [LikeModel]()
    
    init() {
        loadLikes()
        print("Documents folder is \(documentsDirectory())")
        print("Data file path is \(dataFilePath())")
    }
    
    //MARK: Data management
    
    private func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Liks.plist")
    }
    
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func loadLikes() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([LikeModel].self,from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func saveLikeStatus() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print(error.localizedDescription)
        }
    }
        
    //MARK: Likes management
    
    func appendLike(likeRest: LikeModel) {
        
        var alreadyExists = false
        
        // safety check in case the like already exists
        for item in items {
            if item.id == likeRest.id {
                alreadyExists = true
                break
            }
        }
        
        if alreadyExists {
            return
        }
        
        items.append(likeRest)
        saveLikeStatus()
    }
    
    func getLikeStatus(id: String) throws -> LikeModel {
        for item in items {
            if item.id == id {
                return item
            }
        }
        throw DataError.likeNotFound(id: id)
    }
        
    func removeLike(id: String) throws {
        var idxToRemove = -1
        for (idx, el) in items.enumerated() {
            if el.id == id {
                idxToRemove = idx
                items.remove(at: idx)
                break
            }
        }
        
        if idxToRemove < 0 {
            throw DataError.likeNotFound(id: id)
        }
        
        //items.remove(at: idxToRemove)
        saveLikeStatus()
    }

}

