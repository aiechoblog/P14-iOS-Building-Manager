import SwiftUI

struct AddPaymentView: View {
    @ObservedObject var store: P14Store

    @State private var selectedUnitNumber: Int = 1
    @State private var monthLabel: String = "خرداد ۱۴۰۵"
    @State private var paymentDate: String = "۱۴۰۵/۰۳/۰۱"
    @State private var amountText: String = ""
    @State private var notes: String = ""
    @State private var savedMessage: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("اطلاعات پرداخت")) {
                    unitPicker()
                    monthPicker()
                    TextField("تاریخ پرداخت", text: $paymentDate)
                    TextField("مبلغ", text: $amountText)
                        .keyboardType(.numberPad)
                    Text("مبلغ پیشنهادی: \(formatMoney(suggestedAmount()))")
                        .foregroundColor(.secondary)
                    TextField("یادداشت", text: $notes)
                }

                Button("ثبت پرداخت") {
                    savePayment()
                }

                if savedMessage.isEmpty == false {
                    Text(savedMessage)
                        .foregroundColor(.green)
                }
            }
            .navigationTitle("ثبت پرداخت شارژ")
            .onAppear {
                prepareInitialValues()
            }
        }
    }

    func unitPicker() -> some View {
        Picker("واحد", selection: $selectedUnitNumber) {
            ForEach(store.activeUnits()) { unit in
                let title = "واحد \(persianNumber(unit.unitNumber)) - \(store.displayResidentName(unit))"
                Text(title).tag(unit.unitNumber)
            }
        }
    }

    func monthPicker() -> some View {
        Picker("ماه", selection: $monthLabel) {
            ForEach(store.months, id: \.self) { month in
                Text(month).tag(month)
            }
        }
    }

    func prepareInitialValues() {
        monthLabel = store.selectedMonth

        if let firstUnit = store.activeUnits().first {
            selectedUnitNumber = firstUnit.unitNumber
        }
    }

    func selectedUnit() -> UnitInfo? {
        return store.activeUnits().first { unit in
            unit.unitNumber == selectedUnitNumber
        }
    }

    func suggestedAmount() -> Int {
        guard let unit = selectedUnit() else {
            return 0
        }

        let paid = store.paidAmount(unitNumber: selectedUnitNumber, month: monthLabel)
        return max(unit.monthlyCharge - paid, 0)
    }

    func savePayment() {
        var amount = parseAmount(amountText)

        if amountText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            amount = suggestedAmount()
        }

        store.addPayment(
            unitNumber: selectedUnitNumber,
            monthLabel: monthLabel,
            paymentDate: paymentDate,
            amount: amount,
            notes: notes
        )

        amountText = ""
        notes = ""
        savedMessage = "پرداخت ثبت شد."
    }
}
