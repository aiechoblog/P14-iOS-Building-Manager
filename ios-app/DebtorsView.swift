import SwiftUI

struct DebtorsView: View {
    @ObservedObject var store: P14Store

    var body: some View {
        NavigationView {
            List {
                Section {
                    MonthPickerView(store: store)
                }

                debtorContent()
            }
            .navigationTitle("بدهکاران")
        }
    }

    @ViewBuilder
    func debtorContent() -> some View {
        let rows = store.debtorRows(month: store.selectedMonth)

        if rows.isEmpty {
            Text("همه واحدها برای این ماه تسویه هستند.")
                .foregroundColor(.green)
        } else {
            ForEach(rows) { row in
                DebtorRowView(row: row)
            }
        }
    }
}

struct DebtorRowView: View {
    var row: DebtorRow

    var body: some View {
        VStack(alignment: .trailing, spacing: 6) {
            Text("واحد \(persianNumber(row.unit.unitNumber)) - \(residentName())")
                .font(.headline)
            Text("پرداختشده: \(formatMoney(row.paid))")
            Text("بدهی: \(formatMoney(row.debt))")
                .foregroundColor(.red)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }

    func residentName() -> String {
        if row.unit.residentName.isEmpty == false {
            return row.unit.residentName
        }

        if row.unit.isRented && row.unit.tenantName.isEmpty == false {
            return row.unit.tenantName
        }

        return row.unit.ownerName
    }
}
