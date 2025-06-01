import SwiftUI

struct MainTabView: View {
    @StateObject private var jobsViewModel = JobsViewModel()
    
    var body: some View {
        TabView {
            JobsFeedView()
                .environmentObject(jobsViewModel)
                .tabItem {
                    Label("Jobs", systemImage: "list.bullet")
                }
            
            CreateJobView()
                .environmentObject(jobsViewModel)
                .tabItem {
                    Label("Post Job", systemImage: "plus.circle")
                }
            
            MyJobsView()
                .environmentObject(jobsViewModel)
                .tabItem {
                    Label("My Jobs", systemImage: "person.crop.circle")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "gear")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(AuthViewModel())
    }
} 