import SwiftUI

struct ImprovedUnitsView: View {
    @ObservedObject var store: P14Store
    @State private var searchText: String = ""

    var filteredUnits: [UnitInfo] {
        if searchText.isEmpty {
            return store.activeUnits()
        }
        return store.activeUnits().filter { unit in
            store.displayResidentName(unit).localizedCaseInsensitiveContains(searchText) ||
            String(unit.unitNumber).contains(searchText)
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $searchText, placeholder: "جستجو واحد یا ساکن...")
                    .padding()

                if filteredUnits.isEmpty {
                    EmptyStateView(
                        icon: "building.2",
                        title: "واحدی یافت نشد",
                        message: searchText.isEmpty ? "هنوز واحدی اضافه نشده است" : "با این جستجو واحدی یافت نشد",
                        actionTitle: nil,
                        action: nil
                    )
                    .frame(maxHeight: .infinity)
                } else {
                    List {
                        Section(header: Text("تعداد واحدها: \(persianNumber(filteredUnits.count))").font(.headline)) {
                            ForEach(filteredUnits) { unit in
                                NavigationLink(destination: UnitEditView(store: store, unit: unit)) {
                                    ImprovedUnitRowView(unit: unit, store: store)
                                }
                                .listRowBackground(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.secondarySystemBackground))
                                        .padding(.vertical, 4)
                                )
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("واحدهای ساختمان")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ImprovedUnitRowView: View {
    let unit: UnitInfo
    let store: P14Store

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            // Header
            HStack(spacing: 8) {
                StatusBadge(
                    text: unit.isRented ? "مستاجر" : "مالک ساکن",
                    color: unit.isRented ? .orange : .green
                )

                Spacer()

                Text("واحد \(persianNumber(unit.unitNumber))")
                    .font(.headline)
                    .fontWeight(.bold)
            }

            Divider()

            // Resident Info
            HStack(spacing: 12) {
                Image(systemName: "person.fill")
                    .foregroundColor(.blue)
                    .font(.subheadline)

                VStack(alignment: .trailing, spacing: 2) {
                    Text("ساکن")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(store.displayResidentName(unit))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                Spacer()
            }

            // Owner Info
            HStack(spacing: 12) {
                Image(systemName: "person.badge.key.fill")
                    .foregroundColor(.purple)
                    .font(.subheadline)

                VStack(alignment: .trailing, spacing: 2) {
                    Text("مالک")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(unit.ownerName)
                        .font(.subheadline)
                }
                Spacer()
            }

            // Monthly Charge
            HStack(spacing: 12) {
                Image(systemName: "money.circle.fill")
                    .foregroundColor(.green)
                    .font(.subheadline)

                VStack(alignment: .trailing, spacing: 2) {
                    Text("شارژ ماهانه")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(formatMoney(unit.monthlyCharge))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                Spacer()
            }

            if !unit.notes.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "note.text")
                        .foregroundColor(.gray)
                        .font(.caption)
                    Text(unit.notes)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.top, 4)
            }
        }
        .padding()
    }
}

struct SearchBar: View {
    @Binding var text: String
    let placeholder: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.never)

            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

struct StatusBadge: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color)
            .cornerRadius(6)
    }
}

#Preview {
    ImprovedUnitsView(store: P14Store())
}
