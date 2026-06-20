import SwiftUI

struct UnitsView: View {
    @ObservedObject var store: P14Store

    var body: some View {
        NavigationView {
            List {
                Section {
                    Text("برای ویرایش، روی واحد بزنید.")
                        .foregroundColor(.secondary)
                }

                ForEach(store.activeUnits()) { unit in
                    NavigationLink(destination: UnitEditView(store: store, unit: unit)) {
                        UnitRowView(unit: unit)
                    }
                }
            }
            .navigationTitle("واحدها")
        }
    }
}

struct UnitRowView: View {
    var unit: UnitInfo

    var body: some View {
        VStack(alignment: .trailing, spacing: 6) {
            Text("واحد \(persianNumber(unit.unitNumber))")
                .font(.headline)
            Text("ساکن: \(residentText())")
            Text("مالک: \(unit.ownerName)")
            Text("تلفن ساکن: \(unit.residentPhone.toPersianDigits())")
            Text("شارژ ماهانه: \(formatMoney(unit.monthlyCharge))")

            if unit.isRented {
                Text("وضعیت: مستاجر")
                    .foregroundColor(.orange)
            } else {
                Text("وضعیت: مالک ساکن")
                    .foregroundColor(.green)
            }

            if unit.notes.isEmpty == false {
                Text("یادداشت: \(unit.notes)")
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.vertical, 6)
    }

    func residentText() -> String {
        if unit.residentName.isEmpty == false {
            return unit.residentName
        }

        if unit.isRented && unit.tenantName.isEmpty == false {
            return unit.tenantName
        }

        return unit.ownerName
    }
}
