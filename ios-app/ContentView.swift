import SwiftUI

struct ContentView: View {
    @StateObject private var store = P14Store()

    var body: some View {
        TabView {
            DashboardView(store: store)
                .tabItem {
                    Label("داشبورد", systemImage: "chart.bar.fill")
                }

            UnitsView(store: store)
                .tabItem {
                    Label("واحدها", systemImage: "building.2.fill")
                }

            AddPaymentView(store: store)
                .tabItem {
                    Label("پرداخت", systemImage: "plus.circle.fill")
                }

            AddExpenseView(store: store)
                .tabItem {
                    Label("هزینه", systemImage: "minus.circle.fill")
                }

            BillProfilesView(store: store)
                .tabItem {
                    Label("قبض ها", systemImage: "doc.plaintext.fill")
                }

            DebtorsView(store: store)
                .tabItem {
                    Label("بدهکاران", systemImage: "person.crop.circle.badge.exclamationmark")
                }

            ReportView(store: store)
                .tabItem {
                    Label("گزارش", systemImage: "doc.text.fill")
                }

            BuildingSettingsView(store: store)
                .tabItem {
                    Label("ساختمان", systemImage: "gearshape.fill")
                }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}