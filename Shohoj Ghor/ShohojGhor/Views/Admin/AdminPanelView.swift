import SwiftUI
import FirebaseDatabase

struct AdminPanelView: View {
    @StateObject private var viewModel = AdminPanelViewModel()
    @State private var showAddProductSheet = false
    @Binding var showAdminLogin: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.background
                    .ignoresSafeArea()
                
                VStack {
                    // Header Stats
                    HStack(spacing: 20) {
                        StatCard(title: "Total Products", value: "\(viewModel.products.count)")
                        StatCard(title: "Popular Items", value: "\(viewModel.products.filter { $0.isPopular }.count)")
                    }
                    .padding()
                    
                    // Products List
                    List {
                        ForEach(viewModel.products) { product in
                            ProductRow(product: product)
                            .listRowBackground(Color.white.opacity(0.9))
                            .listRowSeparator(.hidden)
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Admin Panel")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showAdminLogin = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(ColorTheme.navigation)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddProductSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(ColorTheme.navigation)
                            .font(.title2)
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        .sheet(isPresented: $showAddProductSheet) {
            AddProductView(viewModel: viewModel)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(ColorTheme.secondaryText)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(ColorTheme.text)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct ProductRow: View {
    let product: Product
    @State private var showUpdateSheet = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Product Image or Icon
            Image(systemName: "cube.box.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(ColorTheme.navigation)
                .padding(8)
                .background(ColorTheme.navigation.opacity(0.1))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.headline)
                    .foregroundColor(ColorTheme.text)
                
                Text("$\(String(format: "%.2f", product.price))")
                    .font(.subheadline)
                    .foregroundColor(ColorTheme.secondaryText)
                
                HStack {
                    if product.isPopular {
                        Badge(text: "Popular", color: .orange)
                    }
                    if product.isNew {
                        Badge(text: "New", color: .green)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(ColorTheme.secondaryText)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .onTapGesture {
            showUpdateSheet = true
        }
        .sheet(isPresented: $showUpdateSheet) {
            UpdateProductView(product: product)
        }
    }
}

struct Badge: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.medium)
            .foregroundColor(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.1))
            .cornerRadius(6)
    }
} 