import SwiftUI

struct PaymentView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var showSuccessAlert = false
    @State private var isProcessing = false
    
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
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                    }
                    
                    // Confirm Button
                    Button {
                        confirmOrder()
                    } label: {
                        if isProcessing {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Confirm Payment")
                                .fontWeight(.medium)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .background(ColorTheme.navigation.gradient)
                    .cornerRadius(25)
                    .shadow(color: ColorTheme.navigation.opacity(0.3), radius: 10, x: 0, y: 5)
                    .padding(.top, 20)
                }
                .padding()
            }
            .background(ColorTheme.background)
            .navigationTitle("Payment")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Order Successful!", isPresented: $showSuccessAlert) {
                Button("OK") {
                    // Clear cart and dismiss all views
                    cartViewModel.clearCart()
                    dismiss()
                }
            } message: {
                Text("Your order has been placed successfully!")
            }
        }
    }
    
    private func confirmOrder() {
        isProcessing = true
        
        // Simulate order processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isProcessing = false
            showSuccessAlert = true
        }
    }
} 