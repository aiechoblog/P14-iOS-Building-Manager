import SwiftUI
import Foundation

@MainActor
final class P14Store: ObservableObject {
    @Published var building: BuildingInfo = BuildingInfo()
    @Published var units: [UnitInfo] = []
    @Published var payments: [Payment] = []
    @Published var expenses: [Expense] = []
    @Published var billProfiles: [BillProfile] = []
    @Published var billPayments: [BillPayment] = []
    @Published var selectedMonth: String = "خرداد ۱۴۰۵"

    let months: [String] = [
        "فروردین ۱۴۰۵",
        "اردیبهشت ۱۴۰۵",
        "خرداد ۱۴۰۵",
        "تیر ۱۴۰۵",
        "مرداد ۱۴۰۵",
        "شهریور ۱۴۰۵",
        "مهر ۱۴۰۵",
        "آبان ۱۴۰۵",
        "آذر ۱۴۰۵",
        "دی ۱۴۰۵",
        "بهمن ۱۴۰۵",
        "اسفند ۱۴۰۵"
    ]

    let billTypes: [String] = ["برق", "آب", "گاز", "تلفن", "اینترنت", "آسانسور", "عوارض", "سایر"]

    private var dataFileURL: URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0].appendingPathComponent("p14_data.json")
    }

    init() {
        load()
    }

    func load() {
        let url = dataFileURL

        if FileManager.default.fileExists(atPath: url.path) == false {
            loadSampleData()
            save()
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(P14Data.self, from: data)
            building = decoded.buildingInfo
            units = decoded.units.sorted { first, second in
                first.unitNumber < second.unitNumber
            }
            payments = decoded.payments
            expenses = decoded.expenses
            billProfiles = decoded.billProfiles
            billPayments = decoded.billPayments

            if building.numberOfUnits < 1 {
                building.numberOfUnits = 1
            }

            ensureUnitsExist()
            save()
        } catch {
            loadSampleData()
            save()
        }
    }

    func save() {
        do {
            let dataToSave = P14Data(
                buildingInfo: building,
                units: units,
                payments: payments,
                expenses: expenses,
                billProfiles: billProfiles,
                billPayments: billPayments
            )
            let encoded = try JSONEncoder().encode(dataToSave)
            try encoded.write(to: dataFileURL, options: .atomic)
        } catch {
            print("P14 save error")
        }
    }

    func loadSampleData() {
        building = BuildingInfo(
            buildingName: "پلاک ۱۴",
            address: "",
            numberOfUnits: 9,
            defaultMonthlyCharge: 1200000,
            managerName: "",
            managerPhone: "",
            notes: "",
            accountingYearLabel: "۱۴۰۵",
            openingFundBalance: 0,
            openingBalanceDate: "۱۴۰۵/۰۱/۰۱",
            openingBalanceNotes: ""
        )

        units = [
            UnitInfo(unitNumber: 1, floor: "1", area: "90", ownerName: "احمدی", ownerPhone: "09120000001", isRented: false, tenantName: "", tenantPhone: "", tenantEntryDate: "", residentName: "احمدی", residentPhone: "09120000001", monthlyCharge: 1200000, notes: ""),
            UnitInfo(unitNumber: 2, floor: "1", area: "90", ownerName: "محمدی", ownerPhone: "09120000002", isRented: false, tenantName: "", tenantPhone: "", tenantEntryDate: "", residentName: "محمدی", residentPhone: "09120000002", monthlyCharge: 1200000, notes: ""),
            UnitInfo(unitNumber: 3, floor: "2", area: "95", ownerName: "رضایی", ownerPhone: "09120000003", isRented: false, tenantName: "", tenantPhone: "", tenantEntryDate: "", residentName: "رضایی", residentPhone: "09120000003", monthlyCharge: 1200000, notes: "پرداخت ناقص در نمونه"),
            UnitInfo(unitNumber: 4, floor: "2", area: "95", ownerName: "کاظمی", ownerPhone: "09120000004", isRented: false, tenantName: "", tenantPhone: "", tenantEntryDate: "", residentName: "کاظمی", residentPhone: "09120000004", monthlyCharge: 1200000, notes: ""),
            UnitInfo(unitNumber: 5, floor: "3", area: "100", ownerName: "حسینی", ownerPhone: "09120000005", isRented: false, tenantName: "", tenantPhone: "", tenantEntryDate: "", residentName: "حسینی", residentPhone: "09120000005", monthlyCharge: 1200000, notes: ""),
            UnitInfo(unitNumber: 6, floor: "3", area: "100", ownerName: "کریمی", ownerPhone: "09120000006", isRented: false, tenantName: "", tenantPhone: "", tenantEntryDate: "", residentName: "کریمی", residentPhone: "09120000006", monthlyCharge: 1200000, notes: "بدهکار در نمونه"),
            UnitInfo(unitNumber: 7, floor: "4", area: "105", ownerName: "موسوی", ownerPhone: "09120000007", isRented: false, tenantName: "", tenantPhone: "", tenantEntryDate: "", residentName: "موسوی", residentPhone: "09120000007", monthlyCharge: 1200000, notes: ""),
            UnitInfo(unitNumber: 8, floor: "4", area: "105", ownerName: "جعفری", ownerPhone: "09120000008", isRented: false, tenantName: "", tenantPhone: "", tenantEntryDate: "", residentName: "جعفری", residentPhone: "09120000008", monthlyCharge: 1200000, notes: "بدهکار در نمونه"),
            UnitInfo(unitNumber: 9, floor: "5", area: "110", ownerName: "مرادی", ownerPhone: "09120000009", isRented: false, tenantName: "", tenantPhone: "", tenantEntryDate: "", residentName: "مرادی", residentPhone: "09120000009", monthlyCharge: 1200000, notes: "بدهکار در نمونه")
        ]

        payments = [
            Payment(unitNumber: 1, monthLabel: "خرداد ۱۴۰۵", paymentDate: "۱۴۰۵/۰۳/۰۵", amount: 1200000, notes: "پرداخت کامل"),
            Payment(unitNumber: 2, monthLabel: "خرداد ۱۴۰۵", paymentDate: "۱۴۰۵/۰۳/۰۶", amount: 1200000, notes: "پرداخت کامل"),
            Payment(unitNumber: 3, monthLabel: "خرداد ۱۴۰۵", paymentDate: "۱۴۰۵/۰۳/۰۷", amount: 600000, notes: "پرداخت نصف شارژ"),
            Payment(unitNumber: 4, monthLabel: "خرداد ۱۴۰۵", paymentDate: "۱۴۰۵/۰۳/۰۸", amount: 1200000, notes: "پرداخت کامل"),
            Payment(unitNumber: 5, monthLabel: "خرداد ۱۴۰۵", paymentDate: "۱۴۰۵/۰۳/۰۹", amount: 1200000, notes: "پرداخت کامل"),
            Payment(unitNumber: 7, monthLabel: "خرداد ۱۴۰۵", paymentDate: "۱۴۰۵/۰۳/۱۰", amount: 1200000, notes: "پرداخت کامل")
        ]

        expenses = [
            Expense(monthLabel: "خرداد ۱۴۰۵", dateText: "۱۴۰۵/۰۳/۰۳", category: "نظافت", description: "حقوق نظافتچی", amount: 1500000, notes: "")
        ]

        billProfiles = [
            BillProfile(billType: "برق", title: "برق مشاعات", providerName: "شرکت برق", defaultCategory: "قبض"),
            BillProfile(billType: "آب", title: "آب ساختمان", providerName: "شرکت آب", defaultCategory: "قبض"),
            BillProfile(billType: "آسانسور", title: "سرویس آسانسور", providerName: "سرویسکار آسانسور", defaultCategory: "قبض")
        ]

        billPayments = []
    }

    func ensureUnitsExist() {
        if building.numberOfUnits < 1 {
            building.numberOfUnits = 1
        }

        var changed = false

        for number in 1...building.numberOfUnits {
            let exists = units.contains { unit in
                unit.unitNumber == number
            }

            if exists == false {
                let newUnit = UnitInfo(
                    unitNumber: number,
                    floor: "",
                    area: "",
                    ownerName: "مالک واحد \(persianNumber(number))",
                    ownerPhone: "",
                    isRented: false,
                    tenantName: "",
                    tenantPhone: "",
                    tenantEntryDate: "",
                    residentName: "مالک واحد \(persianNumber(number))",
                    residentPhone: "",
                    monthlyCharge: building.defaultMonthlyCharge,
                    notes: ""
                )
                units.append(newUnit)
                changed = true
            }
        }

        units = units.sorted { first, second in
            first.unitNumber < second.unitNumber
        }

        if changed {
            save()
        }
    }

    func activeUnits() -> [UnitInfo] {
        return units.filter { unit in
            unit.unitNumber <= building.numberOfUnits
        }
    }

    func saveBuilding(_ newBuilding: BuildingInfo) {
        var fixed = newBuilding
        if fixed.numberOfUnits < 1 {
            fixed.numberOfUnits = 1
        }
        building = fixed
        ensureUnitsExist()
        save()
    }

    func updateUnit(_ unit: UnitInfo) {
        guard unit.unitNumber > 0 else {
            return
        }

        var fixedUnit = unit
        if fixedUnit.isRented == false {
            fixedUnit.tenantName = ""
            fixedUnit.tenantPhone = ""
            fixedUnit.tenantEntryDate = ""

            if fixedUnit.residentName.isEmpty {
                fixedUnit.residentName = fixedUnit.ownerName
            }

            if fixedUnit.residentPhone.isEmpty {
                fixedUnit.residentPhone = fixedUnit.ownerPhone
            }
        }

        if let index = units.firstIndex(where: { existing in existing.id == fixedUnit.id }) {
            units[index] = fixedUnit
        } else if let index = units.firstIndex(where: { existing in existing.unitNumber == fixedUnit.unitNumber }) {
            units[index] = fixedUnit
        } else {
            units.append(fixedUnit)
        }

        units = units.sorted { first, second in
            first.unitNumber < second.unitNumber
        }
        save()
    }

    func paymentsForMonth(_ month: String) -> [Payment] {
        return payments.filter { payment in
            payment.monthLabel == month
        }
    }

    func expensesForMonth(_ month: String) -> [Expense] {
        return expenses.filter { expense in
            expense.monthLabel == month
        }
    }

    func billPaymentsForMonth(_ month: String) -> [BillPayment] {
        return billPayments.filter { billPayment in
            billPayment.monthLabel == month
        }
    }

    func paidAmount(unitNumber: Int, month: String) -> Int {
        let matchingPayments = payments.filter { payment in
            payment.unitNumber == unitNumber && payment.monthLabel == month
        }
        return matchingPayments.reduce(0) { total, payment in
            total + payment.amount
        }
    }

    func expectedCharge(month: String) -> Int {
        return activeUnits().reduce(0) { total, unit in
            total + unit.monthlyCharge
        }
    }

    func receivedPayments(month: String) -> Int {
        let monthPayments = paymentsForMonth(month)
        return monthPayments.reduce(0) { total, payment in
            total + payment.amount
        }
    }

    func totalNormalExpenses(month: String) -> Int {
        let monthExpenses = expensesForMonth(month)
        return monthExpenses.reduce(0) { total, expense in
            total + expense.amount
        }
    }

    func totalBillPayments(month: String) -> Int {
        let monthBills = billPaymentsForMonth(month)
        return monthBills.reduce(0) { total, billPayment in
            total + billPayment.amount
        }
    }

    func totalExpenses(month: String) -> Int {
        return totalNormalExpenses(month: month) + totalBillPayments(month: month)
    }

    func totalReceivedPaymentsAll() -> Int {
        return payments.reduce(0) { total, payment in
            total + payment.amount
        }
    }

    func totalNormalExpensesAll() -> Int {
        return expenses.reduce(0) { total, expense in
            total + expense.amount
        }
    }

    func totalBillPaymentsAll() -> Int {
        return billPayments.reduce(0) { total, billPayment in
            total + billPayment.amount
        }
    }

    func fundBalance() -> Int {
        let income = totalReceivedPaymentsAll()
        let normalCosts = totalNormalExpensesAll()
        let billCosts = totalBillPaymentsAll()
        return building.openingFundBalance + income - normalCosts - billCosts
    }

    func debtorRows(month: String) -> [DebtorRow] {
        var rows: [DebtorRow] = []

        for unit in activeUnits() {
            let paid = paidAmount(unitNumber: unit.unitNumber, month: month)
            let debt = max(unit.monthlyCharge - paid, 0)

            if debt > 0 {
                rows.append(DebtorRow(unit: unit, paid: paid, debt: debt))
            }
        }

        return rows.sorted { first, second in
            first.unit.unitNumber < second.unit.unitNumber
        }
    }

    func addPayment(unitNumber: Int, monthLabel: String, paymentDate: String, amount: Int, notes: String) {
        let payment = Payment(unitNumber: unitNumber, monthLabel: monthLabel, paymentDate: paymentDate, amount: amount, notes: notes)
        payments.append(payment)
        save()
    }

    func addExpense(monthLabel: String, dateText: String, category: String, description: String, amount: Int, notes: String) {
        let expense = Expense(monthLabel: monthLabel, dateText: dateText, category: category, description: description, amount: amount, notes: notes)
        expenses.append(expense)
        save()
    }

    func billProfileTitle(_ id: UUID) -> String {
        if let profile = billProfiles.first(where: { profile in profile.id == id }) {
            return profile.title
        }
        return "قبض"
    }

    func activeBillProfiles() -> [BillProfile] {
        return billProfiles.filter { profile in
            profile.isActive
        }
    }

    func saveBillProfile(_ profile: BillProfile) {
        if let index = billProfiles.firstIndex(where: { item in item.id == profile.id }) {
            billProfiles[index] = profile
        } else {
            billProfiles.append(profile)
        }
        save()
    }

    func addBillPayment(_ billPayment: BillPayment) {
        billPayments.append(billPayment)
        save()
    }

    func displayResidentName(_ unit: UnitInfo) -> String {
        if unit.residentName.isEmpty == false {
            return unit.residentName
        }
        if unit.isRented && unit.tenantName.isEmpty == false {
            return unit.tenantName
        }
        return unit.ownerName
    }

    func residentsMessage(month: String) -> String {
        let received = receivedPayments(month: month)
        let normalCosts = totalNormalExpenses(month: month)
        let billCosts = totalBillPayments(month: month)
        let totalCosts = normalCosts + billCosts
        let rows = debtorRows(month: month)

        var lines: [String] = []
        lines.append("سلام و احترام")
        lines.append("گزارش کوتاه شارژ \(building.buildingName) برای \(month):")
        lines.append("")
        lines.append("دریافتی شارژ: \(formatMoney(received))")
        lines.append("جمع هزینه ها: \(formatMoney(totalCosts))")
        lines.append("موجودی فعلی صندوق: \(formatMoney(fundBalance()))")
        lines.append("")

        if rows.isEmpty {
            lines.append("همه واحدها برای این ماه تسویه هستند.")
        } else {
            lines.append("واحدهای دارای بدهی:")
            for row in rows {
                let unitText = "واحد \(persianNumber(row.unit.unitNumber))"
                let debtText = formatMoney(row.debt)
                let name = displayResidentName(row.unit)
                lines.append("\(unitText) - \(name): \(debtText)")
            }
        }

        if building.managerName.isEmpty == false || building.managerPhone.isEmpty == false {
            lines.append("")
            lines.append("مدیر ساختمان: \(building.managerName) \(building.managerPhone.toPersianDigits())")
        }

        lines.append("")
        lines.append("با تشکر از همراهی شما")
        return lines.joined(separator: "\n")
    }

    func monthlyReport(month: String) -> String {
        let expected = expectedCharge(month: month)
        let received = receivedPayments(month: month)
        let normalCosts = totalNormalExpenses(month: month)
        let billCosts = totalBillPayments(month: month)
        let allCosts = normalCosts + billCosts
        let rows = debtorRows(month: month)
        let monthBills = billPaymentsForMonth(month)

        var lines: [String] = []
        lines.append("گزارش ماهانه \(building.buildingName)")
        lines.append("ماه: \(month)")
        lines.append("--------------------")
        lines.append("")
        lines.append("خلاصه مالی")
        lines.append("تعداد واحدها: \(persianNumber(building.numberOfUnits))")
        lines.append("سال مالی: \(building.accountingYearLabel)")
        lines.append("موجودی اول دوره: \(formatMoney(building.openingFundBalance))")
        lines.append("تاریخ موجودی اول دوره: \(building.openingBalanceDate)")
        if building.openingBalanceNotes.isEmpty == false {
            lines.append("توضیحات موجودی اول دوره: \(building.openingBalanceNotes)")
        }
        lines.append("شارژ مورد انتظار: \(formatMoney(expected))")
        lines.append("دریافتی شارژ: \(formatMoney(received))")
        lines.append("هزینه های عادی: \(formatMoney(normalCosts))")
        lines.append("قبض ها: \(formatMoney(billCosts))")
        lines.append("جمع کل هزینه ها: \(formatMoney(allCosts))")
        lines.append("موجودی فعلی صندوق: \(formatMoney(fundBalance()))")
        lines.append("")
        lines.append("قبض های ماه:")

        if monthBills.isEmpty {
            lines.append("قبضی برای این ماه ثبت نشده است.")
        } else {
            for bill in monthBills {
                let title = billProfileTitle(bill.billProfileId)
                lines.append("\(title): \(formatMoney(bill.amount))")
            }
        }

        lines.append("")
        lines.append("بدهکاران")
        if rows.isEmpty {
            lines.append("همه واحدها تسویه هستند.")
        } else {
            for row in rows {
                let unitText = "واحد \(persianNumber(row.unit.unitNumber))"
                let debtText = formatMoney(row.debt)
                let name = displayResidentName(row.unit)
                lines.append("\(unitText) - \(name): \(debtText)")
            }
        }

        if building.managerName.isEmpty == false || building.managerPhone.isEmpty == false {
            lines.append("")
            lines.append("مدیر ساختمان")
            lines.append("نام: \(building.managerName)")
            lines.append("تلفن: \(building.managerPhone.toPersianDigits())")
        }

        lines.append("")
        lines.append("پیام کوتاه برای ساکنان")
        lines.append(residentsMessage(month: month))
        return lines.joined(separator: "\n")
    }
}