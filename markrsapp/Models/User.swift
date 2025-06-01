import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var email: String
    var fullName: String
    var phoneNumber: String?
    var profileImageURL: String?
    var rating: Double
    var numberOfRatings: Int
    var createdJobs: [String]
    var acceptedJobs: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case fullName
        case phoneNumber
        case profileImageURL
        case rating
        case numberOfRatings
        case createdJobs
        case acceptedJobs
    }
} 