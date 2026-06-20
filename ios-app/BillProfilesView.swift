import SwiftUI

struct BillProfilesView: View {
    @ObservedObject var store: P14Store

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("ثبت قبض ماهانه")) {
                    NavigationLink(destination: AddBillPaymentView(store: store)) {
                        Text("ثبت پرداخت قبض")
                    }
                }

                Section(header: Text("پروفایل قبض ها")) {
                    NavigationLink(destination: BillProfileEditView(store: store, profile: nil)) {
                        Text("افزودن پروفایل قبض")
                    }

                    ForEach(store.billProfiles) { profile in
                        NavigationLink(destination: BillProfileEditView(store: store, profile: profile)) {
                            BillProfileRowView(profile: profile)
                        }
                    }
                }
            }
            .navigationTitle("قبض ها")
        }
    }
}

struct BillProfileRowView: View {
    var profile: BillProfile

    var body: some View {
        VStack(alignment: .trailing, spacing: 6) {
            Text(profile.title)
                .font(.headline)
            Text("نوع: \(profile.billType)")
            if profile.providerName.isEmpty == false {
                Text("ارائه دهنده: \(profile.providerName)")
            }
            Text(profile.isActive ? "فعال" : "غیرفعال")
                .foregroundColor(profile.isActive ? .green : .secondary)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}
