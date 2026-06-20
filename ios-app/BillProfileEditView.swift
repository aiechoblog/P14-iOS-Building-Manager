import SwiftUI

struct BillProfileEditView: View {
    @ObservedObject var store: P14Store
    var profile: BillProfile?

    @Environment(\.presentationMode) private var presentationMode

    @State private var billType: String = "برق"
    @State private var title: String = ""
    @State private var providerName: String = ""
    @State private var meterNumber: String = ""
    @State private var subscriptionNumber: String = ""
    @State private var billId: String = ""
    @State private var paymentId: String = ""
    @State private var defaultCategory: String = "قبض"
    @State private var notes: String = ""
    @State private var isActive: Bool = true
    @State private var errorMessage: String = ""

    var body: some View {
        Form {
            Section(header: Text("اطلاعات قبض")) {
                Picker("نوع قبض", selection: $billType) {
                    ForEach(store.billTypes, id: \.self) { type in
                        Text(type).tag(type)
                    }
                }
                TextField("عنوان", text: $title)
                TextField("ارائه دهنده", text: $providerName)
                TextField("شماره کنتور", text: $meterNumber)
                TextField("شماره اشتراک", text: $subscriptionNumber)
                TextField("شناسه قبض", text: $billId)
                TextField("شناسه پرداخت", text: $paymentId)
                TextField("دسته بندی پیش فرض", text: $defaultCategory)
                Toggle("فعال است؟", isOn: $isActive)
                TextField("توضیحات", text: $notes)
            }

            if errorMessage.isEmpty == false {
                Section {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }

            Section {
                Button("ذخیره") {
                    saveProfile()
                }

                Button("انصراف") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle(profile == nil ? "قبض جدید" : "ویرایش قبض")
        .onAppear {
            loadProfile()
        }
    }

    func loadProfile() {
        guard let profile = profile else {
            return
        }

        billType = profile.billType
        title = profile.title
        providerName = profile.providerName
        meterNumber = profile.meterNumber
        subscriptionNumber = profile.subscriptionNumber
        billId = profile.billId
        paymentId = profile.paymentId
        defaultCategory = profile.defaultCategory
        notes = profile.notes
        isActive = profile.isActive
    }

    func saveProfile() {
        if billType.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "نوع قبض الزامی است."
            return
        }

        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "عنوان قبض الزامی است."
            return
        }

        let id = profile?.id ?? UUID()
        let updated = BillProfile(
            id: id,
            billType: billType,
            title: title,
            providerName: providerName,
            meterNumber: meterNumber,
            subscriptionNumber: subscriptionNumber,
            billId: billId,
            paymentId: paymentId,
            defaultCategory: defaultCategory,
            notes: notes,
            isActive: isActive
        )

        store.saveBillProfile(updated)
        presentationMode.wrappedValue.dismiss()
    }
}
