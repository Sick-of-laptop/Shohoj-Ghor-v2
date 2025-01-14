import SwiftUI

struct SpecificationDetailView: View {
    let product: ProductSpecification
    @Environment(\.dismiss) private var dismiss
    
    private func getProductIcon() -> String {
        switch product.name.lowercased() {
        case let name where name.contains("tv"):
            return "tv.fill"
        case let name where name.contains("refrigerator"):
            return "thermometer.snowflake"
        case let name where name.contains("ac"):
            return "air.conditioner.horizontal.fill"
        case let name where name.contains("washing"):
            return "washer.fill"
        case let name where name.contains("microwave"):
            return "microwave.fill"
        default:
            return "bolt.fill"
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Section with electronics-specific icon
                    VStack(spacing: 8) {
                        Image(systemName: getProductIcon())
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background(ColorTheme.navigation)
                            .clipShape(Circle())
                        
                        Text(product.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("Electronics")
                            .font(.subheadline)
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(15)
                    
                    // Specifications Sections
                    Group {
                        // Dimensions Section (if available)
                        if let dimensions = product.specifications.dimensions {
                            SpecificationSection(title: "Dimensions") {
                                DimensionsView(dimensions: dimensions)
                            }
                        }
                        
                        // Materials Section (if available)
                        if let materials = product.specifications.materials {
                            SpecificationSection(title: "Materials") {
                                BulletPointList(items: materials)
                            }
                        }
                        
                        // Features Section (if available)
                        if let features = product.specifications.features {
                            SpecificationSection(title: "Features") {
                                BulletPointList(items: features)
                            }
                        }
                        
                        // Display Section (if available)
                        if let display = product.specifications.display {
                            SpecificationSection(title: "Display") {
                                DisplayView(display: display)
                            }
                        }
                        
                        // Connectivity Section (if available)
                        if let connectivity = product.specifications.connectivity {
                            SpecificationSection(title: "Connectivity") {
                                BulletPointList(items: connectivity)
                            }
                        }
                        
                        // Power Section (if available)
                        if let power = product.specifications.power {
                            SpecificationSection(title: "Power") {
                                PowerView(power: power)
                            }
                        }
                        
                        // Audio Section (if available)
                        if let audio = product.specifications.audio {
                            SpecificationSection(title: "Audio") {
                                AudioView(audio: audio)
                            }
                        }
                        
                        // Colors Section (if available)
                        if let colors = product.specifications.color_options {
                            SpecificationSection(title: "Available Colors") {
                                ColorOptionsView(colors: colors)
                            }
                        }
                        
                        // Warranty Section
                        SpecificationSection(title: "Warranty") {
                            Text(product.specifications.warranty)
                                .foregroundColor(ColorTheme.text)
                        }
                    }
                }
                .padding()
            }
            .background(ColorTheme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(ColorTheme.navigation)
                            .font(.title3)
                    }
                }
            }
        }
    }
}

// Helper Views
struct SpecificationSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(ColorTheme.navigation)
            
            content
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(15)
    }
}

struct BulletPointList: View {
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 8) {
                    Text("•")
                        .foregroundColor(ColorTheme.navigation)
                    Text(item)
                        .foregroundColor(ColorTheme.text)
                }
            }
        }
    }
}

struct DimensionsView: View {
    let dimensions: Dimensions
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let length = dimensions.length {
                SpecRow(title: "Length", value: length)
            }
            if let width = dimensions.width {
                SpecRow(title: "Width", value: width)
            }
            if let height = dimensions.height {
                SpecRow(title: "Height", value: height)
            }
            if let seatHeight = dimensions.seat_height {
                SpecRow(title: "Seat Height", value: seatHeight)
            }
            if let backrestHeight = dimensions.backrest_height {
                SpecRow(title: "Backrest Height", value: backrestHeight)
            }
        }
    }
}

struct DisplayView: View {
    let display: Display
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SpecRow(title: "Size", value: display.size)
            SpecRow(title: "Resolution", value: display.resolution)
            SpecRow(title: "Panel Type", value: display.panel_type)
            SpecRow(title: "Refresh Rate", value: display.refresh_rate)
        }
    }
}

struct PowerView: View {
    let power: Power
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SpecRow(title: "Voltage", value: power.voltage)
            SpecRow(title: "Power Consumption", value: power.consumption)
        }
    }
}

struct AudioView: View {
    let audio: Audio
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SpecRow(title: "Output", value: audio.output)
            SpecRow(title: "Speaker System", value: audio.speakers)
        }
    }
}

struct ColorOptionsView: View {
    let colors: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(colors, id: \.self) { color in
                    Text(color)
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(ColorTheme.navigation.opacity(0.1))
                        .foregroundColor(ColorTheme.navigation)
                        .cornerRadius(8)
                }
            }
        }
    }
}

struct SpecRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(ColorTheme.secondaryText)
            Spacer()
            Text(value)
                .foregroundColor(ColorTheme.text)
        }
    }
} 