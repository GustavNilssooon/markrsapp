import SwiftUI
import SDWebImageSwiftUI

struct JobsFeedView: View {
    @EnvironmentObject private var jobsViewModel: JobsViewModel
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            List(jobsViewModel.jobs) { job in
                JobCardView(job: job)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .refreshable {
                jobsViewModel.fetchJobs()
            }
            .navigationTitle("Available Jobs")
        }
    }
}

struct JobCardView: View {
    let job: Job
    @EnvironmentObject private var jobsViewModel: JobsViewModel
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var showingJobDetail = false
    
    var body: some View {
        Button(action: { showingJobDetail = true }) {
            VStack(alignment: .leading, spacing: 12) {
                if !job.imageURLs.isEmpty {
                    WebImage(url: URL(string: job.imageURLs[0]))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(job.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(job.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                        Text(job.location)
                        Spacer()
                        Text("$\(String(format: "%.2f", job.price))")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.blue)
                }
                .padding(.horizontal)
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 5)
            .padding(.horizontal)
            .padding(.vertical, 5)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingJobDetail) {
            JobDetailView(job: job)
        }
    }
}

struct JobDetailView: View {
    let job: Job
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var jobsViewModel: JobsViewModel
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if !job.imageURLs.isEmpty {
                    TabView {
                        ForEach(job.imageURLs, id: \.self) { imageUrl in
                            WebImage(url: URL(string: imageUrl))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                    }
                    .frame(height: 300)
                    .tabViewStyle(PageTabViewStyle())
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(job.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(job.description)
                        .font(.body)
                    
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                        Text(job.location)
                    }
                    .foregroundColor(.blue)
                    
                    Text("Price: $\(String(format: "%.2f", job.price))")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    if let currentUser = authViewModel.currentUser,
                       job.posterID != currentUser.id {
                        Button(action: {
                            if let jobId = job.id {
                                jobsViewModel.acceptJob(jobId: jobId, workerId: currentUser.id!)
                                dismiss()
                            }
                        }) {
                            Text("Accept Job")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.top)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct JobsFeedView_Previews: PreviewProvider {
    static var previews: some View {
        JobsFeedView()
            .environmentObject(JobsViewModel())
            .environmentObject(AuthViewModel())
    }
} 