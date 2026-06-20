P14 Data Model

This document defines the core data models used in P14.

P14 uses local JSON persistence with Swift Codable.

The goal is to keep the data model simple, readable, and safe for Swift Playgrounds.

⸻

Main Data Container

P14Data

P14Data is the main saved object.

It should contain:

* buildingInfo
* units
* payments
* expenses
* billProfiles
* billPayments

Suggested structure:

struct P14Data: Codable {
    var buildingInfo: BuildingInfo
    var units: [UnitInfo]
    var payments: [Payment]
    var expenses: [Expense]
    var billProfiles: [BillProfile]
    var billPayments: [BillPayment]
}

⸻

1. BuildingInfo

Purpose

Stores building-level settings and financial opening balance.

Fields

struct BuildingInfo: Codable {
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
}

Field Notes

buildingName

Example:

پلاک ۱۴

numberOfUnits

Used to determine how many units should be shown.

Default:

9

defaultMonthlyCharge

Used when creating new units.

openingFundBalance

Can be:

* Positive
* Zero
* Negative

Example:

10000000
-2500000
0

⸻

2. UnitInfo

Purpose

Stores each building unit and resident-related information.

Fields

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
}

Business Rules

If isRented is false:

* Tenant fields can be hidden or disabled.
* Resident name can default to owner name.
* Resident phone can default to owner phone.

If isRented is true:

* Tenant fields should be visible.
* Resident name can default to tenant name.
* Resident phone can default to tenant phone.

⸻

3. Payment

Purpose

Stores monthly charge payments from units.

Fields

struct Payment: Identifiable, Codable, Hashable {
    var id: UUID
    var unitNumber: Int
    var monthLabel: String
    var paymentDate: String
    var amount: Int
    var notes: String
}

Example

Unit: 3
Month: خرداد ۱۴۰۵
Date: ۱۴۰۵/۰۳/۱۰
Amount: 1200000
Notes: پرداخت کامل

⸻

4. Expense

Purpose

Stores normal one-time building expenses.

Examples:

* Repairs
* Cleaning
* Maintenance
* Equipment purchase
* General costs

Fields

struct Expense: Identifiable, Codable, Hashable {
    var id: UUID
    var monthLabel: String
    var dateText: String
    var category: String
    var description: String
    var amount: Int
    var notes: String
}

⸻

5. BillProfile

Purpose

Stores recurring bill information so repeated data does not need to be entered every month.

Examples:

* Electricity
* Water
* Gas
* Internet
* Elevator service

Fields

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
}

Example

Bill Type: برق
Title: برق مشاعات
Provider: شرکت برق
Meter Number: 123456
Subscription Number: 987654

⸻

6. BillPayment

Purpose

Stores actual monthly payments for recurring bills.

Fields

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
}

Example

Profile: برق مشاعات
Month: خرداد ۱۴۰۵
Period: دوره خرداد ۱۴۰۵
Amount: 2500000
Payment Date: ۱۴۰۵/۰۳/۲۰
Tracking Number: 123456789

⸻

7. DebtorRow

Purpose

Used for display only. It does not need to be saved in JSON.

Fields

struct DebtorRow: Identifiable {
    var id: UUID
    var unit: UnitInfo
    var paid: Int
    var debt: Int
}

⸻

Financial Calculations

Expected Monthly Charge

Expected Charge =
Sum of monthlyCharge for all active units

Received Payments

Received Payments =
Sum of payments for selected month

Normal Expenses

Normal Expenses =
Sum of expenses for selected month

Utility Bills

Utility Bills =
Sum of billPayments for selected month

Total Expenses

Total Expenses =
Normal Expenses + Utility Bills

Current Fund Balance

Current Fund Balance =
Opening Fund Balance
+ All Received Payments
- All Normal Expenses
- All Utility Bill Payments

⸻

Migration Rules

Missing BuildingInfo

If old JSON does not include buildingInfo, create default building settings.

Old UnitInfo

If old unit data exists, preserve what is possible.

Mapping:

* old ownerName → new ownerName
* old tenantName → new tenantName
* old phoneNumber → ownerPhone / residentPhone
* old monthlyCharge → monthlyCharge
* old notes → notes

Default logic:

* residentName = tenantName if tenantName is not empty, otherwise ownerName
* isRented = true if tenantName is not empty and tenantName != ownerName

Missing Bill Data

If old JSON does not include:

* billProfiles
* billPayments

Default to empty arrays.

⸻

Data Safety Rules

* Never delete units automatically.
* Never delete payments automatically.
* Never delete expenses automatically.
* If unit count decreases, hide extra units if needed, but do not destroy data.
* If JSON cannot be decoded, use a safe fallback and explain reset options.