import SwiftUI

struct MapRowLink: View {
    let title: String
    let subtitle: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: "mappin.and.ellipse")
                    .imageScale(.medium)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.footnote).foregroundColor(.secondary)
                    Text(subtitle).font(.body.weight(.medium)).lineLimit(2)
                }
                Spacer()
                Image(systemName: "arrow.up.right.square").imageScale(.medium)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
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

struct MapRowLink_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Content - Light
            NavigationView {
                MapRowLink(title: "foo.title", subtitle: "foo.subtitle") {
                    
                }
            }
            .previewDisplayName("Content - Light")
            
            // Content - Dark
            NavigationView {
                MapRowLink(title: "foo.title", subtitle: "foo.subtitle") {
                    
                }
            }
            .preferredColorScheme(.dark)
            .previewDisplayName("Content - Dark")
        }
    }
}
