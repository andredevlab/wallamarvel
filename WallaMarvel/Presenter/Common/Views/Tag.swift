import SwiftUI

struct Tag: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10).padding(.vertical, 6)
            .background(
                Capsule().fill(Color(UIColor.systemGray6))
            )
            .overlay(Capsule().stroke(Color.white.opacity(0.15), lineWidth: 1))
    }
}

#if DEBUG
import SwiftUI

struct Tag_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Content - Light
            NavigationView {
                Tag(text: "foo.text")
            }
            .previewDisplayName("Content - Light")
            
            // Content - Dark
            NavigationView {
                Tag(text: "foo.text")
            }
            .preferredColorScheme(.dark)
            .previewDisplayName("Content - Dark")
        }
    }
}
#endif
