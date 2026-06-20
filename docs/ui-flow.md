P14 UI Flow

This document describes how the user should move through the P14 app.

The goal is to keep the app practical, simple, and usable for real building management.

⸻

Main Navigation

P14 should use simple tab-based navigation.

Suggested tabs:

1. Dashboard
2. Units
3. Payments
4. Expenses
5. Bills
6. Debtors
7. Report
8. Settings

Persian labels:

داشبورد
واحدها
پرداخت
هزینه
قبض‌ها
بدهکاران
گزارش
تنظیمات

⸻

1. App Launch Flow

User Opens App

App loads saved JSON data.

If no saved data exists:

* Load default building info.
* Create default units based on numberOfUnits.
* Load empty payments.
* Load empty expenses.
* Load empty bill profiles.
* Load empty bill payments.

First Screen

User sees Dashboard.

Dashboard shows:

* Building name
* Selected month
* Expected charge
* Received payments
* Normal expenses
* Utility bills
* Total expenses
* Opening fund balance
* Current fund balance
* Debtor count

⸻

2. Building Settings Flow

Path:

Settings → Building Information

User can edit:

* Building name
* Address
* Number of units
* Default monthly charge
* Manager name
* Manager phone
* Notes
* Accounting year
* Opening fund balance
* Opening balance date
* Opening balance notes

User taps:

Save

App saves data to JSON.

If number of units increases:

* App creates missing units.

If number of units decreases:

* App does not delete old unit data.

⸻

3. Units Flow

Path:

Units → Unit List

User sees list of units.

Each row should show:

* Unit number
* Resident name
* Owner name
* Rented status
* Monthly charge

User taps a unit.

Path:

Units → Unit Detail/Edit

User can edit:

* Floor
* Area
* Owner name
* Owner phone
* Is rented?
* Tenant name
* Tenant phone
* Tenant entry date
* Resident name
* Resident phone
* Monthly charge
* Notes

User taps:

Save

App saves changes and returns to Units list.

⸻

4. Rented Unit Flow

Inside Unit Edit screen:

If user turns Is rented? OFF:

* Hide or disable tenant fields.
* Resident name can default to owner name.
* Resident phone can default to owner phone.

If user turns Is rented? ON:

* Show tenant fields.
* Tenant name becomes editable.
* Tenant phone becomes editable.
* Tenant entry date becomes editable.
* Resident name can default to tenant name.
* Resident phone can default to tenant phone.

⸻

5. Add Payment Flow

Path:

Payments → Add Payment

User selects:

* Unit
* Month

User enters:

* Payment date
* Amount
* Notes

App can suggest amount based on:

Monthly charge - already paid amount

User taps:

Save Payment

App saves payment to JSON.

Dashboard, Debtors, and Reports update automatically.

⸻

6. Add Expense Flow

Path:

Expenses → Add Expense

User enters:

* Month
* Date
* Category
* Description
* Amount
* Notes

User taps:

Save Expense

App saves expense to JSON.

Dashboard and Reports update automatically.

⸻

7. Recurring Bills Flow

Path:

Bills → Bill Profiles

User sees saved bill profiles.

Examples:

* Electricity
* Water
* Gas
* Internet
* Elevator service

User can:

* Add new bill profile
* Edit bill profile
* Disable bill profile
* Register monthly bill payment

⸻

8. Add Bill Profile Flow

Path:

Bills → Add Bill Profile

User enters:

* Bill type
* Title
* Provider name
* Meter number
* Subscription number
* Bill ID
* Payment ID
* Default category
* Notes
* Active status

User taps:

Save Bill Profile

App saves profile to JSON.

⸻

9. Add Monthly Bill Payment Flow

Path:

Bills → Select Bill Profile → Add Payment

User enters:

* Month
* Bill period
* Issue date
* Due date
* Payment date
* Amount
* Payment tracking number
* Notes

User taps:

Save Bill Payment

App saves bill payment to JSON.

Bill payment affects:

* Dashboard expenses
* Fund balance
* Monthly report

⸻

10. Debtors Flow

Path:

Debtors

User selects month.

App shows:

* Unit number
* Resident name
* Expected charge
* Paid amount
* Remaining debt

If all units are paid:

All units are settled for this month.

Persian:

همه واحدها برای این ماه تسویه هستند.

⸻

11. Report Flow

Path:

Report

User selects month.

App shows monthly report.

Report includes:

* Building name
* Selected month
* Opening fund balance
* Expected charge
* Received payments
* Normal expenses
* Utility bills
* Total expenses
* Current fund balance
* Debtor units
* Manager name and phone if available

User can tap:

Copy Residents Message

App copies a short message suitable for WhatsApp or Telegram.

⸻

12. Expected Daily Use

A typical month:

1. Open app.
2. Check Dashboard.
3. Register received charge payments.
4. Register expenses.
5. Register bills.
6. Check Debtors.
7. Copy monthly message.
8. Send message to residents.

⸻

UI Principles

Keep It Simple

The app should be easier than Excel.

Avoid Too Many Steps

Common tasks should be quick:

* Add payment
* Add expense
* Add bill payment
* Check debtors
* Copy report

Persian First

The app should feel natural for Persian-speaking users.

Safe Data

No accidental deletion.

Local First

The app should work without internet.

⸻

Minimum Usable UI

The app becomes usable when:

* Units can be edited.
* Payments can be registered.
* Expenses can be registered.
* Bills can be saved and paid.
* Debtors are clear.
* Reports are copyable.
* Data persists after reopening.