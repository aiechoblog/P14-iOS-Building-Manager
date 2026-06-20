import SwiftUI

struct MonthPickerView: View {
    @ObservedObject var store: P14Store

    var body: some View {
        Picker("ماه", selection: $store.selectedMonth) {
            ForEach(store.months, id: \.self) { month in
                Text(month).tag(month)
            }
        }
        .pickerStyle(.menu)
    }
}

struct SummaryCardView: View {
    var title: String
    var value: String
    var color: Color

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text(value)
                .font(.headline)
                .foregroundColor(color)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct DashboardView: View {
    @ObservedObject var store: P14Store

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .trailing, spacing: 16) {
                    MonthPickerView(store: store)
                        .frame(maxWidth: .infinity, alignment: .trailing)

                    SummaryCardView(title: "تعداد واحدها", value: persianNumber(store.building.numberOfUnits), color: .gray)
                    SummaryCardView(title: "شارژ مورد انتظار", value: formatMoney(store.expectedCharge(month: store.selectedMonth)), color: .blue)
                    SummaryCardView(title: "موجودی اول دوره", value: formatMoney(store.building.openingFundBalance), color: .blue)
                    SummaryCardView(title: "دریافتی ها", value: formatMoney(store.receivedPayments(month: store.selectedMonth)), color: .green)
                    SummaryCardView(title: "هزینه های عادی", value: formatMoney(store.totalNormalExpenses(month: store.selectedMonth)), color: .orange)
                    SummaryCardView(title: "قبض ها", value: formatMoney(store.totalBillPayments(month: store.selectedMonth)), color: .orange)
                    SummaryCardView(title: "جمع هزینه ها", value: formatMoney(store.totalExpenses(month: store.selectedMonth)), color: .red)
                    SummaryCardView(title: "موجودی فعلی صندوق", value: formatMoney(store.fundBalance()), color: .purple)
                    SummaryCardView(title: "تعداد واحد بدهکار", value: debtorCountText(), color: .red)

                    Text("آخرین پرداخت ها")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .trailing)

                    recentPaymentsView()
                }
                .padding()
            }
            .navigationTitle(store.building.buildingName)
        }
    }

    func debtorCountText() -> String {
        let count = store.debtorRows(month: store.selectedMonth).count
        return persianNumber(count)
    }

    func recentPayments() -> [Payment] {
        let payments = store.paymentsForMonth(store.selectedMonth)
        let suffixPayments = payments.suffix(5)
        return Array(suffixPayments.reversed())
    }

    @ViewBuilder
    func recentPaymentsView() -> some View {
        let items = recentPayments()

        if items.isEmpty {
            Text("پرداختی برای این ماه ثبت نشده است.")
                .foregroundColor(.secondary)
        } else {
            ForEach(items) { payment in
                VStack(alignment: .trailing, spacing: 4) {
                    Text("واحد \(persianNumber(payment.unitNumber))")
                        .font(.headline)
                    Text(payment.paymentDate)
                    Text(formatMoney(payment.amount))
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            }
        }
    }
}
