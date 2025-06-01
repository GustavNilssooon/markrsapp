import SwiftUI
import SDWebImageSwiftUI

struct MyJobsView: View {
    @EnvironmentObject private var jobsViewModel: JobsViewModel
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Jobs", selection: $selectedTab) {
                    Text("Posted").tag(0)
                    Text("Accepted").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()
                
                if selectedTab == 0 {
                    PostedJobsList()
                } else {
                    AcceptedJobsList()
                }
            }
            .navigationTitle("My Jobs")
            .onAppear {
                if let userId = authViewModel.currentUser?.id {
                    jobsViewModel.fetchMyJobs(userId: userId)
                }
            }
        }
    }
}

struct PostedJobsList: View {
    @EnvironmentObject private var jobsViewModel: JobsViewModel
    
    var body: some View {
        List(jobsViewModel.myPostedJobs) { job in
            PostedJobCard(job: job)
        }
        .listStyle(.plain)
    }
}

struct AcceptedJobsList: View {
    @EnvironmentObject private var jobsViewModel: JobsViewModel
    
    var body: some View {
        List(jobsViewModel.myAcceptedJobs) { job in
            AcceptedJobCard(job: job)
        }
        .listStyle(.plain)
    }
}

struct PostedJobCard: View {
    let job: Job
    @EnvironmentObject private var jobsViewModel: JobsViewModel
    @State private var showingConfirmation = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !job.imageURLs.isEmpty {
                WebImage(url: URL(string: job.imageURLs[0]))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(job.title)
                    .font(.headline)
                
                Text(job.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Text("Status: \(job.status.rawValue.capitalized)")
                        .foregroundColor(statusColor)
                    Spacer()
                    Text("$\(String(format: "%.2f", job.price))")
                        .fontWeight(.semibold)
                }
                
                if job.status == .completed {
                    Button(action: { showingConfirmation = true }) {
                        Text("Confirm Completion")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding(.horizontal)
        .padding(.vertical, 5)
        .alert("Confirm Job Completion", isPresented: $showingConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Confirm") {
                if let jobId = job.id {
                    jobsViewModel.confirmJobCompletion(jobId: jobId)
                }
            }
        } message: {
            Text("Are you sure you want to confirm this job as completed?")
        }
    }
    
    private var statusColor: Color {
        switch job.status {
        case .open:
            return .blue
        case .assigned:
            return .orange
        case .completed:
            return .yellow
        case .confirmed:
            return .green
        case .cancelled:
            return .red
        }
    }
}

struct AcceptedJobCard: View {
    let job: Job
    @EnvironmentObject private var jobsViewModel: JobsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !job.imageURLs.isEmpty {
                WebImage(url: URL(string: job.imageURLs[0]))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(job.title)
                    .font(.headline)
                
                Text(job.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Text("Status: \(job.status.rawValue.capitalized)")
                        .foregroundColor(statusColor)
                    Spacer()
                    Text("$\(String(format: "%.2f", job.price))")
                        .fontWeight(.semibold)
                }
                
                if job.status == .assigned {
                    Button(action: {
                        if let jobId = job.id {
                            jobsViewModel.completeJob(jobId: jobId)
                        }
                    }) {
                        Text("Mark as Completed")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
    
    private var statusColor: Color {
        switch job.status {
        case .open:
            return .blue
        case .assigned:
            return .orange
        case .completed:
            return .yellow
        case .confirmed:
            return .green
        case .cancelled:
            return .red
        }
    }
}

struct MyJobsView_Previews: PreviewProvider {
    static var previews: some View {
        MyJobsView()
            .environmentObject(JobsViewModel())
            .environmentObject(AuthViewModel())
    }
} 