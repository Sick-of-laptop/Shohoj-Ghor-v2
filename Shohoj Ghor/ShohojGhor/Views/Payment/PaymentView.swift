import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct PaymentView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var showSuccessAlert = false
    @State private var isProcessing = false
    @State private var error: String?
    
    private let db = Firestore.firestore()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Order Summary
                    VStack(spacing: 16) {
                        Text("Order Summary")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            Text("Total Amount")
                            Spacer()
                            Text("$\(cartViewModel.totalAmount, specifier: "%.2f")")
                                .fontWeight(.bold)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5)
                    
                    // Payment Method
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Payment Method")
                            .font(.headline)
                        
                        HStack {
                            Image(systemName: "banknote")
                                .foregroundColor(ColorTheme.navigation)
                            Text("Cash on Delivery")
                                .fontWeight(.medium)
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(ColorTheme.navigation)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5)
                    
                    // Confirm Button
                    Button {
                        processOrder()
                    } label: {
                        HStack {
                            if isProcessing {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Confirm Order")
                                    .fontWeight(.medium)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                        .background(ColorTheme.navigation.gradient)
                        .cornerRadius(25)
                        .shadow(color: ColorTheme.navigation.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .disabled(isProcessing)
                    .padding(.top, 20)
                }
                .padding()
            }
            .background(ColorTheme.background)
            .navigationTitle("Payment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.navigation)
                }
            }
            .alert("Order Successful!", isPresented: $showSuccessAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your order has been placed successfully!")
            }
            .alert("Error", isPresented: .init(
                get: { error != nil },
                set: { if !$0 { error = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                if let error = error {
                    Text(error)
                }
            }
        }
    }
    
    private func processOrder() {
        guard !cartViewModel.cartItems.isEmpty else {
            error = "Your cart is empty"
            return
        }
        
        isProcessing = true
        
        cartViewModel.createOrder { result in
            DispatchQueue.main.async {
                isProcessing = false
                
                switch result {
                case .success:
                    showSuccessAlert = true
                case .failure(let error):
                    self.error = error.localizedDescription
                }
            }
        }
    }
} 
