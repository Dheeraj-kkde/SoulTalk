import SwiftUI
import UIKit

struct ExpertAvatarView: View {
    let expert: Expert
    let size: CGFloat

    var body: some View {
        Group {
            if let imageName = expert.imageName, UIImage(named: imageName) != nil {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    Circle()
                        .fill(Color.accentColor.opacity(0.15))
                    Text(expert.initials)
                        .font(size >= 60 ? .title2 : .headline)
                        .bold()
                        .foregroundStyle(.tint)
                }
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(
            Circle()
                .strokeBorder(Color.white.opacity(0.2))
        )
        .accessibilityLabel(Text("Avatar for \(expert.name)"))
    }
}

#Preview {
    ExpertAvatarView(expert: SampleData.experts[1], size: 64)
        .padding()
        .previewLayout(.sizeThatFits)
}
