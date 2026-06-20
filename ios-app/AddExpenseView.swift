import SwiftUI

struct AddExpenseView: View {
    @ObservedObject var store: P14Store

    @State private var monthLabel: String = "خرداد ۱۴۰۵"
    @State private var dateText: String = "۱۴۰۵/۰۳/۰۱"
    @State private var category: String = "نظافت"
    @State private var description: String = ""
    @State private var amountText: String = ""
    @State private var notes: String = ""
    @State private var savedMessage: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("اطلاعات هزینه")) {
                    monthPicker()
                    TextField("تاریخ", text: $dateText)
                    TextField("دستهبندی", text: $category)
                    TextField("شرح هزینه", text: $description)
                    TextField("مبلغ", text: $amountText)
                        .keyboardType(.numberPad)
                    TextField("یادداشت", text: $notes)
                }

                Button("ثبت هزینه") {
                    saveExpense()
                }

                if savedMessage.isEmpty == false {
                    Text(savedMessage)
                        .foregroundColor(.green)
                }
            }
            .navigationTitle("ثبت هزینه")
            .onAppear {
                monthLabel = store.selectedMonth
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

    func saveExpense() {
        let amount = parseAmount(amountText)

        store.addExpense(
            monthLabel: monthLabel,
            dateText: dateText,
            category: category,
            description: description,
            amount: amount,
            notes: notes
        )

        description = ""
        amountText = ""
        notes = ""
        savedMessage = "هزینه ثبت شد."
    }
}
