import SwiftUI
import PhotosUI

struct CreateJobView: View {
    @EnvironmentObject private var jobsViewModel: JobsViewModel
    @EnvironmentObject private var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var price = ""
    @State private var location = ""
    @State private var isBiddingEnabled = false
    @State private var selectedImages: [UIImage] = []
    @State private var showingImagePicker = false
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Job Details")) {
                    TextField("Title", text: $title)
                    
                    TextEditor(text: $description)
                        .frame(height: 100)
                    
                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                    
                    TextField("Location", text: $location)
                    
                    Toggle("Enable Bidding", isOn: $isBiddingEnabled)
                }
                
                Section(header: Text("Images")) {
                    ScrollView(.horizontal) {
                        HStack {
                            Button(action: { showingImagePicker = true }) {
                                VStack {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 30))
                                    Text("Add Image")
                                        .font(.caption)
                                }
                                .foregroundColor(.blue)
                                .frame(width: 100, height: 100)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                            
                            ForEach(selectedImages, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                
                Section {
                    Button(action: createJob) {
                        Text("Post Job")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("Create Job")
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(images: $selectedImages)
            }
            .alert("Error", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(jobsViewModel.errorMessage ?? "An error occurred")
            }
        }
    }
    
    private var isFormValid: Bool {
        !title.isEmpty &&
        !description.isEmpty &&
        !price.isEmpty &&
        !location.isEmpty &&
        Double(price) != nil
    }
    
    private func createJob() {
        guard let currentUser = authViewModel.currentUser,
              let priceValue = Double(price) else { return }
        
        jobsViewModel.createJob(
            title: title,
            description: description,
            price: priceValue,
            isBiddingEnabled: isBiddingEnabled,
            location: location,
            images: selectedImages,
            posterID: currentUser.id!
        )
        
        if jobsViewModel.errorMessage != nil {
            showingAlert = true
        } else {
            dismiss()
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 5
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                        if let image = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.images.append(image)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct CreateJobView_Previews: PreviewProvider {
    static var previews: some View {
        CreateJobView()
            .environmentObject(JobsViewModel())
            .environmentObject(AuthViewModel())
    }
} 