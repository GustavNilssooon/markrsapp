import Foundation
import FirebaseFirestore
import FirebaseStorage

class JobsViewModel: ObservableObject {
    @Published var jobs: [Job] = []
    @Published var myPostedJobs: [Job] = []
    @Published var myAcceptedJobs: [Job] = []
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    init() {
        fetchJobs()
    }
    
    func fetchJobs() {
        db.collection("jobs")
            .whereField("status", isEqualTo: JobStatus.open.rawValue)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                self?.jobs = snapshot?.documents.compactMap { try? $0.data(as: Job.self) } ?? []
            }
    }
    
    func fetchMyJobs(userId: String) {
        // Fetch posted jobs
        db.collection("jobs")
            .whereField("posterID", isEqualTo: userId)
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                self?.myPostedJobs = snapshot?.documents.compactMap { try? $0.data(as: Job.self) } ?? []
            }
        
        // Fetch accepted jobs
        db.collection("jobs")
            .whereField("workerID", isEqualTo: userId)
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                self?.myAcceptedJobs = snapshot?.documents.compactMap { try? $0.data(as: Job.self) } ?? []
            }
    }
    
    func createJob(title: String, description: String, price: Double, isBiddingEnabled: Bool, location: String, images: [UIImage], posterID: String) {
        var imageURLs: [String] = []
        let group = DispatchGroup()
        
        // Upload images first
        for (index, image) in images.enumerated() {
            group.enter()
            
            guard let imageData = image.jpegData(compressionQuality: 0.7) else {
                continue
            }
            
            let imagePath = "jobs/\(UUID().uuidString)_\(index).jpg"
            let imageRef = storage.reference().child(imagePath)
            
            imageRef.putData(imageData) { _, error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else {
                    imageRef.downloadURL { url, error in
                        if let url = url {
                            imageURLs.append(url.absoluteString)
                        }
                        group.leave()
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            let job = Job(
                title: title,
                description: description,
                price: price,
                isBiddingEnabled: isBiddingEnabled,
                location: location,
                imageURLs: imageURLs,
                posterID: posterID,
                status: .open,
                createdAt: Date()
            )
            
            do {
                _ = try self.db.collection("jobs").addDocument(from: job)
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func acceptJob(jobId: String, workerId: String) {
        db.collection("jobs").document(jobId).updateData([
            "workerID": workerId,
            "status": JobStatus.assigned.rawValue
        ]) { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    func completeJob(jobId: String) {
        db.collection("jobs").document(jobId).updateData([
            "status": JobStatus.completed.rawValue,
            "completedDate": Date()
        ]) { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    func confirmJobCompletion(jobId: String) {
        db.collection("jobs").document(jobId).updateData([
            "status": JobStatus.confirmed.rawValue
        ]) { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            }
        }
    }
} 