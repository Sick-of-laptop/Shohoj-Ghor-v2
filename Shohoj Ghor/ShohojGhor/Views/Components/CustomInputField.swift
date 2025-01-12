import SwiftUI

struct CustomInputField: View {
    let imageName: String
    let placeholderText: String
    var isSecureField: Bool = false
    @Binding var text: String
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(ColorTheme.secondaryText)
                
                if isSecureField {
                    SecureField(placeholderText, text: $text)
                        .textInputAutocapitalization(.never)
                } else {
                    TextField(placeholderText, text: $text)
                        .textInputAutocapitalization(.never)
                }
            }
            
            Divider()
                .background(ColorTheme.secondaryText)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
} 