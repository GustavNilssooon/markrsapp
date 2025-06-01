import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var errorMessage: String?
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    init() {
        setupAuthStateListener()
    }
    
    private func setupAuthStateListener() {
        auth.addStateDidChangeListener { [weak self] _, user in
            self?.isAuthenticated = user != nil
            if let userId = user?.uid {
                self?.fetchUserData(userId: userId)
            }
        }
    }
    
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    func signUp(email: String, password: String, fullName: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }
            
            guard let userId = result?.user.uid else { return }
            
            let newUser = User(
                email: email,
                fullName: fullName,
                rating: 0.0,
                numberOfRatings: 0,
                createdJobs: [],
                acceptedJobs: []
            )
            
            do {
                try self?.db.collection("users").document(userId).setData(from: newUser)
            } catch {
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func fetchUserData(userId: String) {
        db.collection("users").document(userId).addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }
            
            if let userData = try? snapshot?.data(as: User.self) {
                DispatchQueue.main.async {
                    self?.currentUser = userData
                }
            }
        }
    }
} 