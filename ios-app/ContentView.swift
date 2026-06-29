import SwiftUI

struct ContentView: View {
    @StateObject private var store = P14Store()

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color(red: 0.98, green: 0.96, blue: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            TabView {
                EnhancedDashboardView(store: store)
                    .tabItem {
                        Label("داشبورد", systemImage: "chart.bar.fill")
                    }

                ImprovedUnitsView(store: store)
                    .tabItem {
                        Label("واحدها", systemImage: "building.2.fill")
                    }

                ImprovedAddPaymentView(store: store)
                    .tabItem {
                        Label("پرداخت", systemImage: "plus.circle.fill")
                    }

                ImprovedAddExpenseView(store: store)
                    .tabItem {
                        Label("هزینه", systemImage: "minus.circle.fill")
                    }

                ImprovedBillProfilesView(store: store)
                    .tabItem {
                        Label("قبض ها", systemImage: "doc.plaintext.fill")
                    }

                ImprovedDebtorsView(store: store)
                    .tabItem {
                        Label("بدهکاران", systemImage: "person.crop.circle.badge.exclamationmark")
                    }

                ImprovedReportView(store: store)
                    .tabItem {
                        Label("گزارش", systemImage: "doc.text.fill")
                    }

                ImprovedBuildingSettingsView(store: store)
                    .tabItem {
                        Label("ساختمان", systemImage: "gearshape.fill")
                    }
            }
            .environment(\.layoutDirection, .rightToLeft)
            .tint(.blue)
        }
    }
}

#Preview {
    ContentView()
}
