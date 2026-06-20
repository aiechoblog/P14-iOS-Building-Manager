P14 Feature List

This document tracks all planned, active, completed, and future features of P14.

Status Labels

Use these labels:

* Planned
* In Progress
* Done
* Needs Fix
* Future
* Rejected

⸻

Core Features

1. Building Settings

Status: Planned

The app should allow the user to edit basic building information.

Fields:

* Building name
* Address
* Number of units
* Default monthly charge
* Manager name
* Manager phone
* Notes

Additional financial fields:

* Accounting year
* Opening fund balance
* Opening balance date
* Opening balance notes

Purpose:

This feature makes the app usable for different buildings instead of being hardcoded for one 9-unit sample building.

⸻

2. Opening Fund Balance

Status: Planned

The app should support beginning-of-year or beginning-of-period fund balance.

The opening balance can be:

* Positive
* Zero
* Negative

Formula:

Current Fund Balance =
Opening Fund Balance
+ Received Payments
- Normal Expenses
- Utility Bill Payments

Purpose:

Real building management often starts with an existing fund balance or deficit. Without this feature, reports are financially incomplete.

⸻

3. Dynamic Unit Count

Status: Planned

The app should not assume exactly 9 units.

The number of units should come from building settings.

Behavior:

* If number of units increases, missing units should be created automatically.
* If number of units decreases, existing data should not be deleted automatically.
* The app should protect old unit, payment, and expense data.

Purpose:

This makes P14 usable for different small buildings.

⸻

4. Editable Units

Status: Planned

The app should allow editing unit information.

Fields:

* Unit number
* Floor
* Area / meterage
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

Behavior:

If Is rented is off:

* Tenant fields can be hidden or disabled.
* Resident can default to owner.

If Is rented is on:

* Tenant fields should appear.
* Resident can default to tenant.

Purpose:

The app should become a real resident/unit database, not only a financial calculator.

⸻

5. Monthly Charge Payments

Status: In Progress

The app should allow registering monthly charge payments.

Fields:

* Unit
* Month
* Payment date
* Amount
* Notes

Purpose:

This is one of the main financial functions of the app.

⸻

6. Normal Expenses

Status: In Progress

The app should allow registering one-time building expenses.

Examples:

* Repairs
* Cleaning
* Maintenance
* Equipment purchase
* General costs

Fields:

* Month
* Date
* Category
* Description
* Amount
* Notes

Purpose:

This allows tracking building expenses outside recurring bills.

⸻

7. Recurring Utility Bills

Status: Planned

The app should support saved bill profiles and monthly bill payments.

Examples:

* Electricity
* Water
* Gas
* Phone
* Internet
* Elevator service
* Municipality / waste fees
* Other recurring bills

Bill profile fields:

* Bill type
* Title
* Provider name
* Meter number
* Subscription number
* Bill ID
* Payment ID
* Default category
* Notes
* Is active

Monthly bill payment fields:

* Related bill profile
* Month
* Bill period
* Issue date
* Due date
* Payment date
* Amount
* Payment tracking number
* Notes

Purpose:

Repeated bill information should not be entered manually every month.

⸻

8. Debtors

Status: In Progress

The app should show units that have not paid their monthly charge.

For each debtor:

* Unit number
* Resident name
* Expected charge
* Paid amount
* Remaining debt

Purpose:

This is one of the main daily-use features for building managers.

⸻

9. Dashboard

Status: In Progress

Dashboard should show a summary for the selected month.

Items:

* Building name
* Selected month
* Expected monthly charge
* Received payments
* Normal expenses
* Utility bills
* Total expenses
* Opening fund balance
* Current fund balance
* Debtor count

Purpose:

The dashboard should answer the question:

What is the financial status of the building this month?

⸻

10. Monthly Report

Status: In Progress

The app should generate a monthly Persian report.

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

Purpose:

The report should be useful for building residents and manager records.

⸻

11. Copyable Residents Message

Status: In Progress

The app should generate a short message suitable for WhatsApp or Telegram.

Message should include:

* Month
* Received payments
* Expenses
* Debtors if any
* Polite closing

Purpose:

Building managers often need to send short monthly updates to residents.

⸻

Technical Features

12. Local JSON Persistence

Status: In Progress

The app should save data locally using Codable + JSON.

Stored data includes:

* Building info
* Units
* Payments
* Expenses
* Bill profiles
* Bill payments

Purpose:

The app should work without server, login, or internet.

⸻

13. Migration Support

Status: Planned

The app should not crash when old JSON data exists.

Migration should handle:

* Missing buildingInfo
* Old UnitInfo fields
* Missing billProfiles
* Missing billPayments

Purpose:

The app should remain usable as the data model evolves.

⸻

14. Persian UI

Status: In Progress

The app should use Persian labels and right-to-left layout.

Purpose:

The app is designed first for Persian-speaking building managers.

⸻

15. Swift Playgrounds Compatibility

Status: In Progress

The app should compile and run in Swift Playgrounds on iPad.

Rules:

* Keep files small.
* Avoid very complex expressions.
* Use only one @main.
* Use clean UTF-8 code.
* Avoid hidden/unprintable characters.
* No external libraries.

Purpose:

The user wants to build and run the app on iPad.

⸻

Future Features

16. PDF Export

Status: Future

Generate monthly report as PDF.

⸻

17. Backup and Restore

Status: Future

Allow exporting/importing data backup.

⸻

18. iCloud Sync

Status: Future

Sync data across iPhone and iPad.

⸻

19. Multiple Buildings

Status: Future

Support managing more than one building.

⸻

20. Receipt Attachments

Status: Future

Attach images of receipts to expenses and bill payments.

⸻

21. Charts

Status: Future

Show financial trends by month.

⸻

22. Persian Calendar Picker

Status: Future

Use a proper Persian/Jalali calendar picker instead of plain text date fields.

⸻

23. Resident-Facing Version

Status: Future

A separate resident view or app where residents can see their balance and announcements.

⸻

24. Commercial Version

Status: Future

Prepare P14 for selling to other small building managers.

Possible requirements:

* Better UI
* Demo mode
* User guide
* Backup
* App icon
* Screenshots
* Pricing model