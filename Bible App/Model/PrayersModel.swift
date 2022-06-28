import Foundation

struct PrayersModel : Codable {
    let prayerId : String
    let topic : String
    let prayer : String
    var favorite: Int
    var readStatus:Int
    
    init(from dictionary: [String:Any]){
        prayerId = dictionary[DatabaseConstant.prayerId] as! String
        topic = dictionary[DatabaseConstant.topic] as! String
        prayer = dictionary[DatabaseConstant.prayer] as! String
        favorite = dictionary[DatabaseConstant.favorite] as! Int
         readStatus = dictionary[DatabaseConstant.prayreadStatus] as! Int
    }
}
