import Foundation

struct BuildingInfo: Codable, Hashable {
    var buildingName: String
    var address: String
    var numberOfUnits: Int
    var defaultMonthlyCharge: Int
    var managerName: String
    var managerPhone: String
    var notes: String
    var accountingYearLabel: String
    var openingFundBalance: Int
    var openingBalanceDate: String
    var openingBalanceNotes: String

    init(
        buildingName: String = "پلاک ۱۴",
        address: String = "",
        numberOfUnits: Int = 9,
        defaultMonthlyCharge: Int = 1200000,
        managerName: String = "",
        managerPhone: String = "",
        notes: String = "",
        accountingYearLabel: String = "۱۴۰۵",
        openingFundBalance: Int = 0,
        openingBalanceDate: String = "۱۴۰۵/۰۱/۰۱",
        openingBalanceNotes: String = ""
    ) {
        self.buildingName = buildingName
        self.address = address
        self.numberOfUnits = max(numberOfUnits, 1)
        self.defaultMonthlyCharge = defaultMonthlyCharge
        self.managerName = managerName
        self.managerPhone = managerPhone
        self.notes = notes
        self.accountingYearLabel = accountingYearLabel
        self.openingFundBalance = openingFundBalance
        self.openingBalanceDate = openingBalanceDate
        self.openingBalanceNotes = openingBalanceNotes
    }

    enum CodingKeys: String, CodingKey {
        case buildingName
        case address
        case numberOfUnits
        case defaultMonthlyCharge
        case managerName
        case managerPhone
        case notes
        case accountingYearLabel
        case openingFundBalance
        case openingBalanceDate
        case openingBalanceNotes
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        buildingName = try values.decodeIfPresent(String.self, forKey: .buildingName) ?? "پلاک ۱۴"
        address = try values.decodeIfPresent(String.self, forKey: .address) ?? ""
        numberOfUnits = try values.decodeIfPresent(Int.self, forKey: .numberOfUnits) ?? 9
        if numberOfUnits < 1 {
            numberOfUnits = 1
        }
        defaultMonthlyCharge = try values.decodeIfPresent(Int.self, forKey: .defaultMonthlyCharge) ?? 1200000
        managerName = try values.decodeIfPresent(String.self, forKey: .managerName) ?? ""
        managerPhone = try values.decodeIfPresent(String.self, forKey: .managerPhone) ?? ""
        notes = try values.decodeIfPresent(String.self, forKey: .notes) ?? ""
        accountingYearLabel = try values.decodeIfPresent(String.self, forKey: .accountingYearLabel) ?? "۱۴۰۵"
        openingFundBalance = try values.decodeIfPresent(Int.self, forKey: .openingFundBalance) ?? 0
        openingBalanceDate = try values.decodeIfPresent(String.self, forKey: .openingBalanceDate) ?? "۱۴۰۵/۰۱/۰۱"
        openingBalanceNotes = try values.decodeIfPresent(String.self, forKey: .openingBalanceNotes) ?? ""
    }
}

struct UnitInfo: Identifiable, Codable, Hashable {
    var id: UUID
    var unitNumber: Int
    var floor: String
    var area: String
    var ownerName: String
    var ownerPhone: String
    var isRented: Bool
    var tenantName: String
    var tenantPhone: String
    var tenantEntryDate: String
    var residentName: String
    var residentPhone: String
    var monthlyCharge: Int
    var notes: String

    init(
        id: UUID = UUID(),
        unitNumber: Int,
        floor: String = "",
        area: String = "",
        ownerName: String,
        ownerPhone: String = "",
        isRented: Bool = false,
        tenantName: String = "",
        tenantPhone: String = "",
        tenantEntryDate: String = "",
        residentName: String = "",
        residentPhone: String = "",
        monthlyCharge: Int,
        notes: String
    ) {
        self.id = id
        self.unitNumber = unitNumber
        self.floor = floor
        self.area = area
        self.ownerName = ownerName
        self.ownerPhone = ownerPhone
        self.isRented = isRented
        self.tenantName = tenantName
        self.tenantPhone = tenantPhone
        self.tenantEntryDate = tenantEntryDate
        self.residentName = residentName.isEmpty ? ownerName : residentName
        self.residentPhone = residentPhone.isEmpty ? ownerPhone : residentPhone
        self.monthlyCharge = monthlyCharge
        self.notes = notes
    }

    enum CodingKeys: String, CodingKey {
        case id
        case unitNumber
        case floor
        case area
        case ownerName
        case ownerPhone
        case isRented
        case tenantName
        case tenantPhone
        case tenantEntryDate
        case residentName
        case residentPhone
        case monthlyCharge
        case notes
        case phoneNumber
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let oldPhone = try values.decodeIfPresent(String.self, forKey: .phoneNumber) ?? ""
        let decodedOwnerName = try values.decodeIfPresent(String.self, forKey: .ownerName) ?? ""
        let decodedTenantName = try values.decodeIfPresent(String.self, forKey: .tenantName) ?? ""
        let oldIsRented = decodedTenantName.isEmpty == false && decodedTenantName != decodedOwnerName
        let defaultResidentName = decodedTenantName.isEmpty ? decodedOwnerName : decodedTenantName

        id = try values.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        unitNumber = try values.decodeIfPresent(Int.self, forKey: .unitNumber) ?? 1
        floor = try values.decodeIfPresent(String.self, forKey: .floor) ?? ""
        area = try values.decodeIfPresent(String.self, forKey: .area) ?? ""
        ownerName = decodedOwnerName
        ownerPhone = try values.decodeIfPresent(String.self, forKey: .ownerPhone) ?? oldPhone
        isRented = try values.decodeIfPresent(Bool.self, forKey: .isRented) ?? oldIsRented
        tenantName = decodedTenantName
        tenantPhone = try values.decodeIfPresent(String.self, forKey: .tenantPhone) ?? ""
        tenantEntryDate = try values.decodeIfPresent(String.self, forKey: .tenantEntryDate) ?? ""
        residentName = try values.decodeIfPresent(String.self, forKey: .residentName) ?? defaultResidentName
        residentPhone = try values.decodeIfPresent(String.self, forKey: .residentPhone) ?? oldPhone
        monthlyCharge = try values.decodeIfPresent(Int.self, forKey: .monthlyCharge) ?? 0
        notes = try values.decodeIfPresent(String.self, forKey: .notes) ?? ""
    }

    func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encode(id, forKey: .id)
        try values.encode(unitNumber, forKey: .unitNumber)
        try values.encode(floor, forKey: .floor)
        try values.encode(area, forKey: .area)
        try values.encode(ownerName, forKey: .ownerName)
        try values.encode(ownerPhone, forKey: .ownerPhone)
        try values.encode(isRented, forKey: .isRented)
        try values.encode(tenantName, forKey: .tenantName)
        try values.encode(tenantPhone, forKey: .tenantPhone)
        try values.encode(tenantEntryDate, forKey: .tenantEntryDate)
        try values.encode(residentName, forKey: .residentName)
        try values.encode(residentPhone, forKey: .residentPhone)
        try values.encode(monthlyCharge, forKey: .monthlyCharge)
        try values.encode(notes, forKey: .notes)
    }
}

struct Payment: Identifiable, Codable, Hashable {
    var id: UUID
    var unitNumber: Int
    var monthLabel: String
    var paymentDate: String
    var amount: Int
    var notes: String

    init(id: UUID = UUID(), unitNumber: Int, monthLabel: String, paymentDate: String, amount: Int, notes: String) {
        self.id = id
        self.unitNumber = unitNumber
        self.monthLabel = monthLabel
        self.paymentDate = paymentDate
        self.amount = amount
        self.notes = notes
    }
}

struct Expense: Identifiable, Codable, Hashable {
    var id: UUID
    var monthLabel: String
    var dateText: String
    var category: String
    var description: String
    var amount: Int
    var notes: String

    init(id: UUID = UUID(), monthLabel: String, dateText: String, category: String, description: String, amount: Int, notes: String) {
        self.id = id
        self.monthLabel = monthLabel
        self.dateText = dateText
        self.category = category
        self.description = description
        self.amount = amount
        self.notes = notes
    }
}

struct BillProfile: Identifiable, Codable, Hashable {
    var id: UUID
    var billType: String
    var title: String
    var providerName: String
    var meterNumber: String
    var subscriptionNumber: String
    var billId: String
    var paymentId: String
    var defaultCategory: String
    var notes: String
    var isActive: Bool

    init(
        id: UUID = UUID(),
        billType: String,
        title: String,
        providerName: String = "",
        meterNumber: String = "",
        subscriptionNumber: String = "",
        billId: String = "",
        paymentId: String = "",
        defaultCategory: String = "",
        notes: String = "",
        isActive: Bool = true
    ) {
        self.id = id
        self.billType = billType
        self.title = title
        self.providerName = providerName
        self.meterNumber = meterNumber
        self.subscriptionNumber = subscriptionNumber
        self.billId = billId
        self.paymentId = paymentId
        self.defaultCategory = defaultCategory
        self.notes = notes
        self.isActive = isActive
    }
}

struct BillPayment: Identifiable, Codable, Hashable {
    var id: UUID
    var billProfileId: UUID
    var monthLabel: String
    var billPeriod: String
    var issueDateText: String
    var dueDateText: String
    var paymentDateText: String
    var amount: Int
    var paymentTrackingNumber: String
    var notes: String

    init(
        id: UUID = UUID(),
        billProfileId: UUID,
        monthLabel: String,
        billPeriod: String,
        issueDateText: String,
        dueDateText: String,
        paymentDateText: String,
        amount: Int,
        paymentTrackingNumber: String,
        notes: String
    ) {
        self.id = id
        self.billProfileId = billProfileId
        self.monthLabel = monthLabel
        self.billPeriod = billPeriod
        self.issueDateText = issueDateText
        self.dueDateText = dueDateText
        self.paymentDateText = paymentDateText
        self.amount = amount
        self.paymentTrackingNumber = paymentTrackingNumber
        self.notes = notes
    }
}

struct P14Data: Codable {
    var buildingInfo: BuildingInfo
    var units: [UnitInfo]
    var payments: [Payment]
    var expenses: [Expense]
    var billProfiles: [BillProfile]
    var billPayments: [BillPayment]

    init(
        buildingInfo: BuildingInfo,
        units: [UnitInfo],
        payments: [Payment],
        expenses: [Expense],
        billProfiles: [BillProfile],
        billPayments: [BillPayment]
    ) {
        self.buildingInfo = buildingInfo
        self.units = units
        self.payments = payments
        self.expenses = expenses
        self.billProfiles = billProfiles
        self.billPayments = billPayments
    }

    enum CodingKeys: String, CodingKey {
        case buildingInfo
        case building
        case units
        case payments
        case expenses
        case billProfiles
        case billPayments
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let newBuilding = try values.decodeIfPresent(BuildingInfo.self, forKey: .buildingInfo)
        let oldBuilding = try values.decodeIfPresent(BuildingInfo.self, forKey: .building)
        buildingInfo = newBuilding ?? oldBuilding ?? BuildingInfo()
        units = try values.decodeIfPresent([UnitInfo].self, forKey: .units) ?? []
        payments = try values.decodeIfPresent([Payment].self, forKey: .payments) ?? []
        expenses = try values.decodeIfPresent([Expense].self, forKey: .expenses) ?? []
        billProfiles = try values.decodeIfPresent([BillProfile].self, forKey: .billProfiles) ?? []
        billPayments = try values.decodeIfPresent([BillPayment].self, forKey: .billPayments) ?? []
    }

    func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encode(buildingInfo, forKey: .buildingInfo)
        try values.encode(units, forKey: .units)
        try values.encode(payments, forKey: .payments)
        try values.encode(expenses, forKey: .expenses)
        try values.encode(billProfiles, forKey: .billProfiles)
        try values.encode(billPayments, forKey: .billPayments)
    }
}

struct DebtorRow: Identifiable {
    var id: UUID
    var unit: UnitInfo
    var paid: Int
    var debt: Int

    init(id: UUID = UUID(), unit: UnitInfo, paid: Int, debt: Int) {
        self.id = id
        self.unit = unit
        self.paid = paid
        self.debt = debt
    }
}
