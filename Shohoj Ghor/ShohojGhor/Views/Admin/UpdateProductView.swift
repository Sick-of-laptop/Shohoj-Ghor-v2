import SwiftUI

struct UpdateProductView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AdminPanelViewModel()
    
    let product: Product
    
    @State private var name: String
    @State private var price: String
    @State private var description: String
    @State private var category: ProductCategory
    @State private var isPopular: Bool
    @State private var isNew: Bool
    
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var isUploading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var showDeleteAlert = false
    
    private let cloudinaryUploader = CloudinaryUploader()
    
    // Initialize state with existing product data
    init(product: Product) {
        self.product = product
        _name = State(initialValue: product.name)
        _price = State(initialValue: String(format: "%.2f", product.price))
        _description = State(initialValue: product.description)
        _category = State(initialValue: product.category)
        _isPopular = State(initialValue: product.isPopular)
        _isNew = State(initialValue: product.isNew)
    }
    
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
                                    // Show existing product image
                                    AsyncImage(url: URL(string: product.image)) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 200)
                                    } placeholder: {
                                        ZStack {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(height: 200)
                                                .cornerRadius(12)
                                            
                                            VStack(spacing: 8) {
                                                Image(systemName: "photo")
                                                    .font(.system(size: 30))
                                                Text("Tap to change image")
                                            }
                                            .foregroundColor(.gray)
                                        }
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
                        
                        // Category Selection
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
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        // Toggles Section
                        VStack(alignment: .leading, spacing: 16) {
                            Toggle("Popular Product", isOn: $isPopular)
                            Toggle("New Arrival", isOn: $isNew)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        // Update Button
                        Button {
                            updateProduct()
                        } label: {
                            if isUploading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Update Product")
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(ColorTheme.navigation)
                                    .cornerRadius(25)
                            }
                        }
                        .disabled(isUploading)
                    }
                    .padding()
                }
            }
            .navigationTitle("Update Product")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.navigation)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showDeleteAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
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
        .alert("Delete Product", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                deleteProduct()
            }
        } message: {
            Text("Are you sure you want to delete this product? This action cannot be undone.")
        }
    }
    
    private func updateProduct() {
        guard let priceDouble = Double(price) else {
            alertMessage = "Please enter a valid price"
            showAlert = true
            return
        }
        
        isUploading = true
        
        func performUpdate(imageUrl: String) {
            let updatedProduct = Product(
                name: name,
                price: priceDouble,
                description: description,
                image: imageUrl,
                category: category,
                isPopular: isPopular,
                isNew: isNew
            )
            
            viewModel.updateProduct(product, with: updatedProduct)
            dismiss()
        }
        
        // If there's a new image, upload it first
        if let image = selectedImage {
            cloudinaryUploader.uploadImage(image) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let imageUrl):
                        performUpdate(imageUrl: imageUrl)
                    case .failure(let error):
                        isUploading = false
                        alertMessage = "Failed to upload image: \(error.localizedDescription)"
                        showAlert = true
                    }
                }
            }
        } else {
            // Use existing image URL if no new image is selected
            performUpdate(imageUrl: product.image)
        }
    }
    
    private func deleteProduct() {
        viewModel.deleteProduct(product)
        dismiss()
    }
} 