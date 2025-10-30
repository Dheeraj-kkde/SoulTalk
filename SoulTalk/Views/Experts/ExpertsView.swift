import SwiftUI

struct ExpertsView: View {
    @EnvironmentObject private var store: AppDataStore
    @State private var searchText: String = ""

    private var experts: [Expert] {
        store.searchExperts(matching: searchText)
    }

    var body: some View {
        List {
            ForEach(experts) { expert in
                NavigationLink(value: expert) {
                    ExpertRow(expert: expert)
                }
            }
        }
        .listStyle(.plain)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .navigationDestination(for: Expert.self) { expert in
            ExpertDetailView(expert: expert)
        }
        .navigationTitle("Experts")
    }
}

private struct ExpertRow: View {
    let expert: Expert

    var body: some View {
        HStack(spacing: 12) {
            ExpertAvatarView(expert: expert, size: 44)

            VStack(alignment: .leading, spacing: 4) {
                Text(expert.name)
                    .font(.headline)
                Text(expert.specialties.joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(CurrencyFormatter.inr.string(from: NSNumber(value: expert.ratePerMinute)) ?? "")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
    }
}

#Preview {
    NavigationStack {
        ExpertsView()
            .environmentObject(AppDataStore())
    }
}
