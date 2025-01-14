import SwiftUI

struct AddProductView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AdminPanelViewModel
    
    @State private var name = ""
    @State private var price = ""
    @State private var description = ""
    @State private var category = ProductCategory.furniture
    @State private var isPopular = false
    @State private var isNew = false
    
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var isUploading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private let cloudinaryUploader = CloudinaryUploader()
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Image Selection
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Product Image")
                                .font(.headline)
                                .foregroundColor(ColorTheme.text)
                            
                            Button {
                                showImagePicker = true
                            } label: {
                                if let image = selectedImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 200)
                                        .cornerRadius(12)
                                } else {
                                    ZStack {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(height: 200)
                                            .cornerRadius(12)
                                        
                                        VStack(spacing: 8) {
                                            Image(systemName: "photo")
                                                .font(.system(size: 30))
                                            Text("Tap to select image")
                                        }
                                        .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        // Product Details Section
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Product Details")
                                .font(.headline)
                                .foregroundColor(ColorTheme.text)
                            
                            CustomInputField(
                                imageName: "tag",
                                placeholderText: "Product Name",
                                text: $name
                            )
                            
                            CustomInputField(
                                imageName: "dollarsign.circle",
                                placeholderText: "Price",
                                text: $price
                            )
                            .keyboardType(.decimalPad)
                            
                            CustomInputField(
                                imageName: "text.alignleft",
                                placeholderText: "Description",
                                text: $description
                            )
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        // Modern Category Selection
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Category")
                                .font(.headline)
                                .foregroundColor(ColorTheme.text)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(ProductCategory.allCases, id: \.self) { cat in
                                        CategorySelectionButton(
                                            category: cat,
                                            isSelected: category == cat
                                        ) {
                                            withAnimation {
                                                category = cat
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 5)
                                .padding(.vertical, 10)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        // Flags Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Product Flags")
                                .font(.headline)
                                .foregroundColor(ColorTheme.text)
                            
                            Toggle("Popular Product", isOn: $isPopular)
                                .tint(ColorTheme.navigation)
                            
                            Divider()
                            
                            Toggle("New Arrival", isOn: $isNew)
                                .tint(ColorTheme.navigation)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        // Save Button
                        Button {
                            saveProduct()
                        } label: {
                            if isUploading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Save Product")
                                    .fontWeight(.medium)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                        .background(ColorTheme.navigation.gradient)
                        .cornerRadius(25)
                        .disabled(isUploading)
                        .opacity(isUploading ? 0.7 : 1)
                    }
                    .padding()
                }
            }
            .navigationTitle("Add Product")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.navigation)
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .alert("Message", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }
    
    private func saveProduct() {
        guard let image = selectedImage else {
            alertMessage = "Please select an image"
            showAlert = true
            return
        }
        
        guard let priceDouble = Double(price) else {
            alertMessage = "Please enter a valid price"
            showAlert = true
            return
        }
        
        isUploading = true
        
        // Upload image first
        cloudinaryUploader.uploadImage(image) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let imageUrl):
                    let product = Product(
                        name: name,
                        price: priceDouble,
                        description: description,
                        image: imageUrl,
                        category: category,
                        isPopular: isPopular,
                        isNew: isNew
                    )
                    
                    viewModel.addProduct(product)
                    dismiss()
                    
                case .failure(let error):
                    isUploading = false
                    alertMessage = "Failed to upload image: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
}

// Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.dismiss()
        }
    }
}

// New Category Selection Button
struct CategorySelectionButton: View {
    let category: ProductCategory
    let isSelected: Bool
    let action: () -> Void
    
    private var iconName: String {
        switch category {
        case .furniture:
            return "sofa.fill"
        case .homeAppliances:
            return "tv.fill"
        case .homeDecor:
            return "lamp.table.fill"
        case .outdoor:
            return "leaf.fill"
        case .storage:
            return "archivebox.fill"
        case .smartHome:
            return "homekit"
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Icon
                Image(systemName: iconName)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : ColorTheme.navigation)
                    .frame(width: 60, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(isSelected ? ColorTheme.navigation : Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                
                // Category Name
                Text(category.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? ColorTheme.navigation : ColorTheme.secondaryText)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(width: 70)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 5)
    }
} 