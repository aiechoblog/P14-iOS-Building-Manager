import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct ReportView: View {
    @ObservedObject var store: P14Store
    @State private var copied: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .trailing, spacing: 16) {
                    MonthPickerView(store: store)
                        .frame(maxWidth: .infinity, alignment: .trailing)

                    reportTextView()

                    Button("کپی پیام کوتاه برای ساکنان") {
                        copyResidentsMessage()
                    }
                    .buttonStyle(.borderedProminent)

                    if copied {
                        Text("پیام کپی شد.")
                            .foregroundColor(.green)
                    }
                }
                .padding()
            }
            .navigationTitle("گزارش ماهانه")
        }
    }

    func reportText() -> String {
        return store.monthlyReport(month: store.selectedMonth)
    }

    func reportTextView() -> some View {
        Text(reportText())
            .font(.body.monospaced())
            .textSelection(.enabled)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
    }

    func copyResidentsMessage() {
        #if canImport(UIKit)
        UIPasteboard.general.string = store.residentsMessage(month: store.selectedMonth)
        copied = true
        #endif
    }
}
