import SwiftUI

struct BuildingSettingsView: View {
    @ObservedObject var store: P14Store

    @State private var buildingName: String = ""
    @State private var address: String = ""
    @State private var numberOfUnitsText: String = ""
    @State private var defaultMonthlyChargeText: String = ""
    @State private var managerName: String = ""
    @State private var managerPhone: String = ""
    @State private var accountingYearLabel: String = ""
    @State private var openingFundBalanceText: String = ""
    @State private var openingBalanceDate: String = ""
    @State private var openingBalanceNotes: String = ""
    @State private var notes: String = ""
    @State private var message: String = ""
    @State private var errorMessage: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("اطلاعات ساختمان")) {
                    TextField("نام ساختمان", text: $buildingName)
                    TextField("آدرس", text: $address)
                    TextField("تعداد واحدها", text: $numberOfUnitsText)
                        .keyboardType(.numberPad)
                    TextField("شارژ پیش فرض ماهانه", text: $defaultMonthlyChargeText)
                        .keyboardType(.numberPad)
                    TextField("نام مدیر ساختمان", text: $managerName)
                    TextField("تلفن مدیر ساختمان", text: $managerPhone)
                        .keyboardType(.phonePad)
                    TextField("توضیحات کلی", text: $notes)
                }

                Section(header: Text("تنظیمات مالی")) {
                    TextField("سال مالی", text: $accountingYearLabel)
                    TextField("موجودی اول دوره", text: $openingFundBalanceText)
                    TextField("تاریخ موجودی اول دوره", text: $openingBalanceDate)
                    TextField("توضیحات موجودی اول دوره", text: $openingBalanceNotes)
                    Text("موجودی اول دوره می تواند مثبت، صفر یا منفی باشد.")
                        .foregroundColor(.secondary)
                }

                Section {
                    Button("ذخیره اطلاعات ساختمان") {
                        saveBuilding()
                    }

                    if message.isEmpty == false {
                        Text(message)
                            .foregroundColor(.green)
                    }

                    if errorMessage.isEmpty == false {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }

                Section(header: Text("راهنما")) {
                    Text("اگر تعداد واحدها را بیشتر کنید، واحدهای جدید خودکار ساخته می شوند.")
                    Text("اگر تعداد واحدها را کمتر کنید، اطلاعات قبلی حذف نمی شود.")
                }
            }
            .navigationTitle("اطلاعات ساختمان")
            .onAppear {
                loadBuilding()
            }
        }
    }

    func loadBuilding() {
        let building = store.building
        buildingName = building.buildingName
        address = building.address
        numberOfUnitsText = String(building.numberOfUnits).toPersianDigits()
        defaultMonthlyChargeText = String(building.defaultMonthlyCharge).toPersianDigits()
        managerName = building.managerName
        managerPhone = building.managerPhone
        accountingYearLabel = building.accountingYearLabel
        openingFundBalanceText = String(building.openingFundBalance).toPersianDigits()
        openingBalanceDate = building.openingBalanceDate
        openingBalanceNotes = building.openingBalanceNotes
        notes = building.notes
    }

    func saveBuilding() {
        let unitCount = parseAmount(numberOfUnitsText)
        let defaultCharge = parseAmount(defaultMonthlyChargeText)
        let openingBalance = parseAmount(openingFundBalanceText)

        if isNumericText(numberOfUnitsText) == false {
            errorMessage = "تعداد واحدها باید عدد باشد."
            message = ""
            return
        }

        if isNumericText(defaultMonthlyChargeText) == false {
            errorMessage = "شارژ پیش فرض باید عدد باشد."
            message = ""
            return
        }

        if isNumericText(openingFundBalanceText) == false {
            errorMessage = "موجودی اول دوره باید عدد باشد."
            message = ""
            return
        }

        if unitCount < 1 {
            errorMessage = "تعداد واحدها باید حداقل ۱ باشد."
            message = ""
            return
        }

        if defaultCharge < 0 {
            errorMessage = "شارژ پیش فرض باید عدد مثبت یا صفر باشد."
            message = ""
            return
        }

        let updated = BuildingInfo(
            buildingName: buildingName.isEmpty ? "پلاک ۱۴" : buildingName,
            address: address,
            numberOfUnits: unitCount,
            defaultMonthlyCharge: defaultCharge,
            managerName: managerName,
            managerPhone: managerPhone,
            notes: notes,
            accountingYearLabel: accountingYearLabel.isEmpty ? "۱۴۰۵" : accountingYearLabel,
            openingFundBalance: openingBalance,
            openingBalanceDate: openingBalanceDate.isEmpty ? "۱۴۰۵/۰۱/۰۱" : openingBalanceDate,
            openingBalanceNotes: openingBalanceNotes
        )

        store.saveBuilding(updated)
        errorMessage = ""
        message = "اطلاعات ساختمان ذخیره شد."
        loadBuilding()
    }
}
