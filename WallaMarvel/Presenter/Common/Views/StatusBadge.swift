import SwiftUI

struct StatusBadge: View {
    let status: String
    let hasDescription: Bool
    var color: Color {
        switch status.lowercased() {
        case "alive":   return .green
        case "dead":    return .red
        default:        return .gray
        }
    }
    
    init(status: String, hasDescription: Bool = true) {
        self.status = status
        self.hasDescription = hasDescription
    }
    
    var body: some View {
        Group {
            if hasDescription {
                // Expanded Badge version
                HStack(spacing: 6) {
                    Circle().fill(color).frame(width: 8, height: 8)
                    Text(status.capitalized)
                        .font(.caption.weight(.semibold))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule(style: .continuous)
                        .fill(color.opacity(0.12))
                )
                .overlay(
                    Group {
                        if status.lowercased() == "alive" {
                            CapsuleStrokeCA(color: UIColor(color), lineWidth: 1, duration: 1)
                        } else {
                            Capsule(style: .continuous)
                                .stroke(color.opacity(0.25), lineWidth: 1)
                        }
                    }
                    
                )
            } else {
                // Compact Circular version
                Circle()
                    .fill(color.opacity(0.12))
                    .overlay(
                        Circle().stroke(color.opacity(0.25), lineWidth: 1)
                    )
                    .overlay(
                        Group {
                            if shouldBlink() {
                                PulsingDot(color: UIColor(color),
                                           baseDiameter: 10,
                                           scale: 2,
                                           duration: 1.5)
                            } else {
                                Circle().fill(color).frame(width: 10, height: 10)
                            }
                        }
                    )
                    .frame(width: 20, height: 20)
            }
        }
        .accessibilityLabel(Text("Status \(status.capitalized)"))
    }
    
    private func shouldBlink() -> Bool {
        status.lowercased() == "alive" && !hasDescription
    }
}

struct StatusBadge_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                StatusBadge(status: "alive")
                StatusBadge(status: "dead")
                StatusBadge(status: "foo.text")
                
                StatusBadge(status: "alive", hasDescription: false)
                StatusBadge(status: "dead", hasDescription: false)
                StatusBadge(status: "foo.text", hasDescription: false)
            }
            .previewDisplayName("Content - Light")
            
            VStack {
                StatusBadge(status: "alive")
                StatusBadge(status: "dead")
                StatusBadge(status: "foo.text")
                StatusBadge(status: "alive", hasDescription: false)
                StatusBadge(status: "dead", hasDescription: false)
                StatusBadge(status: "foo.text", hasDescription: false)
            }
            .preferredColorScheme(.dark)
            .previewDisplayName("Content - Dark")
        }
    }
}
