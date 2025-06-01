import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var showingImagePicker = false
    @State private var showingActionSheet = false
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Spacer()
                        VStack {
                            if let profileImageURL = authViewModel.currentUser?.profileImageURL,
                               let url = URL(string: profileImageURL) {
                                WebImage(url: url)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.gray)
                            }
                            
                            Button("Change Photo") {
                                showingActionSheet = true
                            }
                            .font(.caption)
                            .foregroundColor(.blue)
                        }
                        Spacer()
                    }
                }
                
                Section(header: Text("User Information")) {
                    if let user = authViewModel.currentUser {
                        HStack {
                            Text("Name")
                            Spacer()
                            Text(user.fullName)
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            Text("Email")
                            Spacer()
                            Text(user.email)
                                .foregroundColor(.gray)
                        }
                        
                        if let phone = user.phoneNumber {
                            HStack {
                                Text("Phone")
                                Spacer()
                                Text(phone)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        HStack {
                            Text("Rating")
                            Spacer()
                            HStack {
                                Text(String(format: "%.1f", user.rating))
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text("(\(user.numberOfRatings))")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                
                Section {
                    Button(action: { authViewModel.signOut() }) {
                        HStack {
                            Spacer()
                            Text("Sign Out")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(
                    title: Text("Change Profile Photo"),
                    buttons: [
                        .default(Text("Choose from Library")) {
                            showingImagePicker = true
                        },
                        .cancel()
                    ]
                )
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(images: .constant([])) // We'll handle the image selection separately
            }
            .alert("Error", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(authViewModel.errorMessage ?? "An error occurred")
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthViewModel())
    }
} 