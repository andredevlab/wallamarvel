import SwiftUI

struct StatusBadge: View {
    let status: String
    var color: Color {
        switch status.lowercased() {
        case "alive":   return .green
        case "dead":    return .red
        default:        return .gray
        }
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(status.capitalized)
                .font(.caption.weight(.semibold))
        }
        .padding(.horizontal, 10).padding(.vertical, 6)
        .background(
            Capsule(style: .continuous)
                .fill(color.opacity(0.12))
        )
        .overlay(
            Capsule(style: .continuous)
                .stroke(color.opacity(0.25), lineWidth: 1)
        )
        .accessibilityLabel("Status \(status)")
    }
}

struct StatusBadge_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                StatusBadge(status: "alive")
                StatusBadge(status: "dead")
                StatusBadge(status: "foo.text")
            }
            .previewDisplayName("Content - Light")
            
            VStack {
                StatusBadge(status: "alive")
                StatusBadge(status: "dead")
                StatusBadge(status: "foo.text")
            }
            .preferredColorScheme(.dark)
            .previewDisplayName("Content - Dark")
        }
    }
}
