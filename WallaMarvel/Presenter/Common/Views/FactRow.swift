import SwiftUI

struct FactRow: View {
    let title: String
    let value: String
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title.uppercased())
                .font(.caption2.weight(.semibold))
                .foregroundColor(.secondary)
                .tracking(0.5)
            Text(value)
                .font(.body.weight(.medium))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(UIColor.systemFill).opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
    }
}

#if DEBUG
import SwiftUI

struct FactRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Content - Light
            NavigationView {
                FactRow(title: "foo.title", value: "foo.value")
            }
            .preferredColorScheme(.light)
            .previewDisplayName("Content - Light")
            
            // Content - Dark
            NavigationView {
                FactRow(title: "foo.title", value: "foo.value")
            }
            .preferredColorScheme(.dark)
            .previewDisplayName("Content - Dark")
        }
    }
}
#endif
