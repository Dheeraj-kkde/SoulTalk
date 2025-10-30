import SwiftUI

struct ExpertCard: View {
    let expert: Expert

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ExpertAvatarView(expert: expert, size: 64)

            Text(expert.name)
                .font(.headline)

            Text(expert.specialties.joined(separator: ", "))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)

            HStack(spacing: 6) {
                Image(systemName: "indianrupeesign")
                Text(CurrencyFormatter.inr.string(from: NSNumber(value: expert.ratePerMinute)) ?? "")
                Text("/min")
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(width: 210, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [Color.white.opacity(0.15), Color.accentColor.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("\(expert.name), \(expert.specialties.joined(separator: ", "))"))
    }
}

#Preview {
    ExpertCard(expert: SampleData.experts[0])
        .padding()
        .previewLayout(.sizeThatFits)
}
