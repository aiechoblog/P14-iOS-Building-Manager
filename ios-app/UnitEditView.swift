import SwiftUI

struct UnitEditView: View {
    @ObservedObject var store: P14Store
    var unit: UnitInfo

    @Environment(\.presentationMode) private var presentationMode

    @State private var unitNumberText: String = ""
    @State private var floor: String = ""
    @State private var area: String = ""
    @State private var ownerName: String = ""
    @State private var ownerPhone: String = ""
    @State private var isRented: Bool = false
    @State private var tenantName: String = ""
    @State private var tenantPhone: String = ""
    @State private var tenantEntryDate: String = ""
    @State private var residentName: String = ""
    @State private var residentPhone: String = ""
    @State private var monthlyChargeText: String = ""
    @State private var notes: String = ""
    @State private var errorMessage: String = ""

    var body: some View {
        Form {
            Section(header: Text("اطلاعات واحد")) {
                TextField("شماره واحد", text: $unitNumberText)
                    .keyboardType(.numberPad)
                TextField("طبقه", text: $floor)
                TextField("متراژ", text: $area)
                TextField("شارژ ماهانه", text: $monthlyChargeText)
                    .keyboardType(.numberPad)
            }

            Section(header: Text("مالک")) {
                TextField("نام مالک", text: $ownerName)
                TextField("تلفن مالک", text: $ownerPhone)
                    .keyboardType(.phonePad)
            }

            Section(header: Text("وضعیت سکونت")) {
                Toggle("واحد اجاره داده شده است؟", isOn: $isRented)

                if isRented {
                    TextField("نام مستاجر", text: $tenantName)
                    TextField("تلفن مستاجر", text: $tenantPhone)
                        .keyboardType(.phonePad)
                    TextField("تاریخ ورود مستاجر", text: $tenantEntryDate)
                } else {
                    Text("در حالت مالک ساکن، اطلاعات مستاجر ذخیره نمی شود.")
                        .foregroundColor(.secondary)
                }
            }

            Section(header: Text("ساکن فعلی")) {
                TextField("نام ساکن", text: $residentName)
                TextField("تلفن ساکن", text: $residentPhone)
                    .keyboardType(.phonePad)

                Button("قرار دادن ساکن بر اساس وضعیت") {
                    fillResidentFromStatus()
                }
            }

            Section(header: Text("یادداشت")) {
                TextField("یادداشت", text: $notes)
            }

            if errorMessage.isEmpty == false {
                Section {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }

            Section {
                Button("ذخیره") {
                    saveUnit()
                }

                Button("انصراف") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("ویرایش واحد")
        .onAppear {
            loadUnit()
        }
    }

    func loadUnit() {
        unitNumberText = String(unit.unitNumber).toPersianDigits()
        floor = unit.floor
        area = unit.area
        ownerName = unit.ownerName
        ownerPhone = unit.ownerPhone
        isRented = unit.isRented
        tenantName = unit.tenantName
        tenantPhone = unit.tenantPhone
        tenantEntryDate = unit.tenantEntryDate
        residentName = unit.residentName
        residentPhone = unit.residentPhone
        monthlyChargeText = String(unit.monthlyCharge).toPersianDigits()
        notes = unit.notes
    }

    func fillResidentFromStatus() {
        if isRented {
            residentName = tenantName
            residentPhone = tenantPhone
        } else {
            residentName = ownerName
            residentPhone = ownerPhone
        }
    }

    func saveUnit() {
        let unitNumber = parseAmount(unitNumberText)
        let monthlyCharge = parseAmount(monthlyChargeText)

        if isNumericText(unitNumberText) == false {
            errorMessage = "شماره واحد باید عدد باشد."
            return
        }

        if isNumericText(monthlyChargeText) == false {
            errorMessage = "شارژ ماهانه باید عدد باشد."
            return
        }

        if unitNumber < 1 {
            errorMessage = "شماره واحد باید بزرگتر از صفر باشد."
            return
        }

        if monthlyCharge < 0 {
            errorMessage = "شارژ ماهانه باید عدد معتبر باشد."
            return
        }

        if isRented {
            if tenantName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                errorMessage = "نام مستاجر را وارد کنید."
                return
            }

            if tenantPhone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                errorMessage = "تلفن مستاجر را وارد کنید."
                return
            }
        }

        var finalResidentName = residentName
        var finalResidentPhone = residentPhone

        if finalResidentName.isEmpty {
            finalResidentName = isRented ? tenantName : ownerName
        }

        if finalResidentPhone.isEmpty {
            finalResidentPhone = isRented ? tenantPhone : ownerPhone
        }

        let updatedUnit = UnitInfo(
            id: unit.id,
            unitNumber: unitNumber,
            floor: floor,
            area: area,
            ownerName: ownerName,
            ownerPhone: ownerPhone,
            isRented: isRented,
            tenantName: tenantName,
            tenantPhone: tenantPhone,
            tenantEntryDate: tenantEntryDate,
            residentName: finalResidentName,
            residentPhone: finalResidentPhone,
            monthlyCharge: monthlyCharge,
            notes: notes
        )

        store.updateUnit(updatedUnit)
        presentationMode.wrappedValue.dismiss()
    }
}
