import SwiftUI

struct Card<Content: View>: View {
    var spacing: CGFloat = 8
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            content
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground).opacity(0.9))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}
#if DEBUG
import SwiftUI

struct Card_Previews: PreviewProvider {
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
