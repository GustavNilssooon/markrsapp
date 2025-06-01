import Foundation
import FirebaseFirestoreSwift

struct Job: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var price: Double
    var isBiddingEnabled: Bool
    var location: String
    var imageURLs: [String]
    var posterID: String
    var workerID: String?
    var status: JobStatus
    var createdAt: Date
    var scheduledDate: Date?
    var completedDate: Date?
    
    enum JobStatus: String, Codable {
        case open
        case assigned
        case completed
        case confirmed
        case cancelled
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case price
        case isBiddingEnabled
        case location
        case imageURLs
        case posterID
        case workerID
        case status
        case createdAt
        case scheduledDate
        case completedDate
    }
} 