import SwiftUI

struct SectionHeader: View {
    let title: String
    var body: some View {
        HStack {
            Text(title)
                .font(.headline.weight(.semibold))
            Spacer()
        }
        .padding(.bottom, 2)
    }
}

#if DEBUG
import SwiftUI

struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Content - Light
            NavigationView {
                SectionHeader(title: "foo.title")
            }
            .previewDisplayName("Content - Light")
            
            // Content - Dark
            NavigationView {
                SectionHeader(title: "foo.title")
            }
            .preferredColorScheme(.dark)
            .previewDisplayName("Content - Dark")
        }
    }
}
#endif
