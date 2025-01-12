import SwiftUI

struct AddProductView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AdminPanelViewModel
    
    @State private var name = ""
    @State private var price = ""
    @State private var description = ""
    @State private var image = ""
    @State private var category = ProductCategory.furniture
    @State private var isPopular = false
    @State private var isNew = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Product Details Section
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Product Details")
                                .font(.headline)
                                .foregroundColor(ColorTheme.text)
                            
                            CustomInputField(imageName: "tag", placeholderText: "Product Name", text: $name)
                            
                            CustomInputField(imageName: "dollarsign.circle", placeholderText: "Price", text: $price)
                                .keyboardType(.decimalPad)
                            
                            CustomInputField(imageName: "text.alignleft", placeholderText: "Description", text: $description)
                            
                            CustomInputField(imageName: "photo", placeholderText: "Image Name", text: $image)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        // Category Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Category")
                                .font(.headline)
                                .foregroundColor(ColorTheme.text)
                            
                            Picker("Category", selection: $category) {
                                ForEach(ProductCategory.allCases, id: \.self) { category in
                                    Text(category.rawValue).tag(category)
                                }
                            }
                            .pickerStyle(.segmented)
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
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProduct()
                    }
                    .foregroundColor(ColorTheme.navigation)
                    .fontWeight(.medium)
                }
            }
        }
    }
    
    private func saveProduct() {
        guard let priceDouble = Double(price) else { return }
        
        let product = Product(
            name: name,
            price: priceDouble,
            description: description,
            image: image,
            category: category,
            isPopular: isPopular,
            isNew: isNew
        )
        
        viewModel.addProduct(product)
        dismiss()
    }
} 