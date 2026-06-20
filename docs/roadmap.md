P14 Roadmap

Project

P14 iOS Building Manager

Current Stage

Early MVP development.

The project started as a Python prototype on iPad using Pyto and has now moved toward a real SwiftUI iOS/iPadOS app.

The current goal is to build a practical, runnable, local-first app for small residential building management.

⸻

Roadmap Overview

The roadmap is divided into five stages:

1. Foundation
2. MVP
3. Practical Daily Use
4. Sellable Version
5. Future Expansion

⸻

Stage 1 — Foundation

Goal

Create the basic project structure and prove that the app can run.

Status

Partially done.

Required Items

* GitHub repository
* README
* Project brief
* Roadmap
* Changelog
* Feature list
* Data model documentation
* UI flow documentation
* SwiftUI prototype
* Local JSON persistence
* Basic Persian UI
* Right-to-left layout

Success Criteria

This stage is complete when:

* Repository exists.
* Documentation exists.
* A basic SwiftUI app runs in Swift Playgrounds.
* The project has a clear structure for future development.

⸻

Stage 2 — MVP

Goal

Build the minimum usable version of P14.

Core MVP Features

Building Settings

The user can edit:

* Building name
* Address
* Number of units
* Default monthly charge
* Manager name
* Manager phone
* Notes

Opening Fund Balance

The user can enter:

* Accounting year
* Opening fund balance
* Opening balance date
* Notes

The opening balance can be positive, zero, or negative.

Units

The user can:

* See all units
* Open each unit
* Edit unit information
* Save changes

Each unit includes:

* Unit number
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

Payments

The user can:

* Register monthly charge payments
* Select unit
* Select month
* Enter date
* Enter amount
* Add notes

Expenses

The user can:

* Register normal building expenses
* Select month
* Enter category
* Enter description
* Enter amount
* Add notes

Debtors

The app can show:

* Debtor units
* Paid amount
* Remaining debt

Reports

The app can generate:

* Monthly report
* Copyable resident message

Success Criteria

The MVP is complete when the user can manage one building from inside the app without editing code manually.

⸻

Stage 3 — Practical Daily Use

Goal

Make the app actually useful for real building management.

Required Features

Recurring Utility Bills

The app should support recurring bills such as:

* Electricity
* Water
* Gas
* Phone
* Internet
* Elevator service
* Municipality / waste fees
* Other recurring bills

The user can save bill profiles with:

* Bill type
* Title
* Provider name
* Meter number
* Subscription number
* Bill ID
* Payment ID
* Notes

The user can register monthly bill payments from saved profiles.

Better Reports

Reports should separate:

* Normal expenses
* Utility bills
* Total expenses
* Opening balance
* Current fund balance
* Debtors

Better Data Safety

The app should:

* Save data locally
* Recover from old JSON if possible
* Avoid data loss
* Avoid deleting units automatically

Better UI

The app should be easier than Excel or handwritten notes.

Success Criteria

This stage is complete when the app is useful for the building manager in real monthly work.

⸻

Stage 4 — Sellable Version

Goal

Prepare P14 as a product that can be shown or sold to other building managers.

Required Improvements

* Better visual design
* Cleaner navigation
* Better onboarding
* Backup and restore
* Export reports
* Better error handling
* Better Persian formatting
* Simple data reset
* Sample/demo mode
* User guide
* App icon
* Product screenshots

Possible Commercial Positioning

P14 can be positioned as:

* A simple building management app for small residential buildings
* A Persian alternative to manual Excel tracking
* A local-first financial and resident tracking tool
* A lightweight tool for building managers

Success Criteria

This stage is complete when a non-technical user can install and use the app with minimal explanation.

⸻

Stage 5 — Future Expansion

Possible Future Features

* PDF export
* iCloud backup
* Multiple buildings
* Receipt attachments
* Payment reminders
* Charts and financial trends
* Persian calendar picker
* Resident-facing version
* Web dashboard
* Admin panel
* Cloud sync
* Subscription version
* App Store release

Important Note

These features are not part of the current MVP.

They should only be considered after the core app becomes stable and useful.

⸻

Current Priority

The current priority is:

1. Keep the app runnable.
2. Add building settings.
3. Add editable units.
4. Add opening fund balance.
5. Add recurring utility bills.
6. Improve reports.
7. Save everything safely in local JSON.

⸻

Product Principle

P14 should remain simple.

The goal is not to build a large enterprise system.

The goal is to build something more useful than:

* Excel
* handwritten notes
* scattered WhatsApp messages
* memory-based building management