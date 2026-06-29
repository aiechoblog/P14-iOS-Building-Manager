import SwiftUI

struct QuickActionCard: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(color)
            .cornerRadius(12)
        }
    }
}

struct StatusIndicator: View {
    let title: String
    let value: String
    let status: StatusType
    let icon: String
    
    enum StatusType {
        case positive  // Green
        case negative  // Red
        case neutral   // Gray
        case warning   // Orange
        
        var color: Color {
            switch self {
            case .positive:
                return Color.green
            case .negative:
                return Color.red
            case .neutral:
                return Color.gray
            case .warning:
                return Color.orange
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 6) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(status.color)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            Text(value)
                .font(.headline)
                .foregroundColor(status.color)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct EnhancedDashboardView: View {
    @ObservedObject var store: P14Store
    @State private var showingAddPayment = false
    @State private var showingAddExpense = false
    @State private var showingBills = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(alignment: .trailing, spacing: 16) {
                        // Month Selector
                        HStack(spacing: 12) {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                            
                            Picker("ماه", selection: $store.selectedMonth) {
                                ForEach(store.months, id: \.self) { month in
                                    Text(month).tag(month)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                        // Key Metrics Section
                        VStack(alignment: .trailing, spacing: 12) {
                            Text("خلاصه مالی")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            // Fund Balance - Primary Metric
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("موجودی فعلی صندوق")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text(formatMoney(store.fundBalance()))
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(store.fundBalance() >= 0 ? .green : .red)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                            
                            // Metrics Grid
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 12) {
                                StatusIndicator(
                                    title: "دریافتی ها",
                                    value: formatMoney(store.receivedPayments(month: store.selectedMonth)),
                                    status: .positive,
                                    icon: "arrow.down.circle.fill"
                                )
                                
                                StatusIndicator(
                                    title: "جمع هزینه ها",
                                    value: formatMoney(store.totalExpenses(month: store.selectedMonth)),
                                    status: .negative,
                                    icon: "arrow.up.circle.fill"
                                )
                                
                                StatusIndicator(
                                    title: "شارژ مورد انتظار",
                                    value: formatMoney(store.expectedCharge(month: store.selectedMonth)),
                                    status: .neutral,
                                    icon: "target"
                                )
                                
                                StatusIndicator(
                                    title: "بدهکاران",
                                    value: persianNumber(store.debtorRows(month: store.selectedMonth).count),
                                    status: store.debtorRows(month: store.selectedMonth).isEmpty ? .positive : .warning,
                                    icon: "person.fill.badge.minus"
                                )
                            }
                        }
                        .padding(.horizontal)
                        
                        // Debtors Section
                        VStack(alignment: .trailing, spacing: 12) {
                            if !store.debtorRows(month: store.selectedMonth).isEmpty {
                                Text("بدهکاران ماه")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                
                                ForEach(store.debtorRows(month: store.selectedMonth).prefix(3)) { row in
                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text("واحد \(persianNumber(row.unit.unitNumber)) - \(displayResidentName(row.unit))")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                        
                                        HStack(spacing: 8) {
                                            Text(formatMoney(row.debt))
                                                .font(.headline)
                                                .foregroundColor(.red)
                                            
                                            Text("بدهی:")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(8)
                                }
                                
                                if store.debtorRows(month: store.selectedMonth).count > 3 {
                                    Text("و \(persianNumber(store.debtorRows(month: store.selectedMonth).count - 3)) واحد دیگر...")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Recent Payments Section
                        VStack(alignment: .trailing, spacing: 12) {
                            Text("آخرین پرداخت ها")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            let recentPayments = store.paymentsForMonth(store.selectedMonth)
                                .sorted { $0.paymentDate > $1.paymentDate }
                                .prefix(5)
                            
                            if recentPayments.isEmpty {
                                Text("پرداختی برای این ماه ثبت نشده است.")
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            } else {
                                ForEach(Array(recentPayments), id: \.id) { payment in
                                    HStack(spacing: 12) {
                                        VStack(alignment: .trailing, spacing: 2) {
                                            Text("واحد \(persianNumber(payment.unitNumber))")
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                            
                                            Text(payment.paymentDate)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Text(formatMoney(payment.amount))
                                            .font(.headline)
                                            .foregroundColor(.green)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Bottom spacing for floating buttons
                        Color.clear
                            .frame(height: 140)
                    }
                    .padding(.vertical)
                }
                
                // Quick Action Buttons - Floating at bottom
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        QuickActionCard(
                            title: "پرداخت",
                            icon: "plus.circle",
                            color: .green,
                            action: { showingAddPayment = true }
                        )
                        
                        QuickActionCard(
                            title: "هزینه",
                            icon: "minus.circle",
                            color: .orange,
                            action: { showingAddExpense = true }
                        )
                        
                        QuickActionCard(
                            title: "قبض",
                            icon: "doc.fill",
                            color: .blue,
                            action: { showingBills = true }
                        )
                    }
                    .padding()
                    .frame(height: 100)
                }
                .frame(maxWidth: .infinity)
                .background(LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemBackground).opacity(0.8),
                        Color(.systemBackground)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                ))
            }
            .navigationTitle(store.building.buildingName)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingAddPayment) {
                AddPaymentView(store: store)
            }
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView(store: store)
            }
            .sheet(isPresented: $showingBills) {
                BillProfilesView(store: store)
            }
        }
    }
    
    private func displayResidentName(_ unit: UnitInfo) -> String {
        if !unit.residentName.isEmpty {
            return unit.residentName
        }
        if unit.isRented && !unit.tenantName.isEmpty {
            return unit.tenantName
        }
        return unit.ownerName
    }
}

#Preview {
    EnhancedDashboardView(store: P14Store())
}
