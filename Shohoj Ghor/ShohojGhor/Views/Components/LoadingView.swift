import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.3)
                .ignoresSafeArea()
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: ColorTheme.navigation))
                .scaleEffect(2)
        }
    }
} 