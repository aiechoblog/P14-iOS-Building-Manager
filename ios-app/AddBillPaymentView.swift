import SwiftUI

struct AddBillPaymentView: View {
    @ObservedObject var store: P14Store

    @Environment(\.presentationMode) private var presentationMode

    @State private var selectedProfileId: UUID = UUID()
    @State private var monthLabel: String = "خرداد ۱۴۰۵"
    @State private var billPeriod: String = ""
    @State private var issueDateText: String = ""
    @State private var dueDateText: String = ""
    @State private var paymentDateText: String = ""
    @State private var amountText: String = ""
    @State private var paymentTrackingNumber: String = ""
    @State private var notes: String = ""
    @State private var errorMessage: String = ""
    @State private var savedMessage: String = ""

    var body: some View {
        Form {
            if store.activeBillProfiles().isEmpty {
                Section {
                    Text("ابتدا یک پروفایل قبض فعال بسازید.")
                        .foregroundColor(.secondary)
                }
            } else {
                Section(header: Text("اطلاعات پرداخت قبض")) {
                    profilePicker()
                    monthPicker()
                    TextField("دوره قبض", text: $billPeriod)
                    TextField("تاریخ صدور", text: $issueDateText)
                    TextField("مهلت پرداخت", text: $dueDateText)
                    TextField("تاریخ پرداخت", text: $paymentDateText)
                    TextField("مبلغ", text: $amountText)
                        .keyboardType(.numberPad)
                    TextField("شماره پیگیری پرداخت", text: $paymentTrackingNumber)
                    TextField("توضیحات", text: $notes)
                }

                Button("ثبت پرداخت قبض") {
                    saveBillPayment()
                }
            }

            if errorMessage.isEmpty == false {
                Section {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }

            if savedMessage.isEmpty == false {
                Section {
                    Text(savedMessage)
                        .foregroundColor(.green)
                }
            }
        }
        .navigationTitle("ثبت پرداخت قبض")
        .onAppear {
            prepareInitialValues()
        }
    }

    func profilePicker() -> some View {
        Picker("قبض", selection: $selectedProfileId) {
            ForEach(store.activeBillProfiles()) { profile in
                Text(profile.title).tag(profile.id)
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
        if let first = store.activeBillProfiles().first {
            selectedProfileId = first.id
        }
    }

    func saveBillPayment() {
        if isNumericText(amountText) == false {
            errorMessage = "مبلغ قبض باید عدد باشد."
            savedMessage = ""
            return
        }

        let amount = parseAmount(amountText)
        if amount < 0 {
            errorMessage = "مبلغ قبض نمی تواند منفی باشد."
            savedMessage = ""
            return
        }

        let payment = BillPayment(
            billProfileId: selectedProfileId,
            monthLabel: monthLabel,
            billPeriod: billPeriod,
            issueDateText: issueDateText,
            dueDateText: dueDateText,
            paymentDateText: paymentDateText,
            amount: amount,
            paymentTrackingNumber: paymentTrackingNumber,
            notes: notes
        )

        store.addBillPayment(payment)
        amountText = ""
        paymentTrackingNumber = ""
        notes = ""
        errorMessage = ""
        savedMessage = "پرداخت قبض ثبت شد."
    }
}
