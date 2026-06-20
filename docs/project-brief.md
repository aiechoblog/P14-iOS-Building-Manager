P14 Project Brief

Project Name

P14 iOS Building Manager

Short Description

P14 is a Persian iOS/iPadOS building management app for small residential buildings.

It is designed to help a building manager track units, residents, monthly charges, payments, expenses, recurring utility bills, opening fund balance, debtors, and monthly reports.

⸻

Background

The project started from a real use case: managing a small residential building.

The first prototype was created in Python and ran on iPad using Pyto.
That prototype proved the basic logic but was not practical enough because terminal-based UI is not suitable for daily building management.

The project then moved toward a real iOS/iPadOS SwiftUI app.

⸻

Main Problem

Many small residential buildings are managed manually through:

* Excel files
* handwritten notes
* WhatsApp messages
* memory
* scattered receipts
* informal payment tracking

This creates problems such as:

* unclear debtor tracking
* missing expense history
* hard monthly reporting
* repeated bill information
* no clear opening fund balance
* no structured unit/resident records

P14 aims to solve these problems in a simple and practical way.

⸻

Target Users

Primary user:

* Building manager of a small residential building

Secondary possible users:

* Apartment board members
* Small property managers
* Residential building accountants
* Owners who manage their own building

⸻

Initial Scope

The first version is designed for:

* Single building
* Single user
* Local storage
* No login
* No server
* No cloud dependency
* iPhone and iPad usage

⸻

Core Features

1. Building Settings

The app should store basic building information:

* Building name
* Address
* Number of units
* Default monthly charge
* Building manager name
* Building manager phone
* Notes

⸻

2. Opening Fund Balance

At the beginning of each accounting year or period, the building may already have money or deficit.

The app must support:

* Accounting year
* Opening fund balance
* Opening balance date
* Notes

Opening fund balance can be:

* Positive
* Zero
* Negative

The fund balance formula is:

Current Fund Balance =
Opening Fund Balance
+ Received Payments
- Normal Expenses
- Utility Bill Payments

⸻

3. Units and Residents

Each unit should have editable information:

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
* Monthly charge amount
* Notes

If the unit is not rented, resident information can default to owner information.

If the unit is rented, tenant information should be visible and editable.

⸻

4. Monthly Charge Payments

The app should allow the manager to register monthly charge payments.

Each payment includes:

* Unit
* Month
* Payment date
* Amount
* Notes

The app should calculate:

* Expected monthly charge
* Received payments
* Debtor units
* Remaining debt per unit

⸻

5. Normal Expenses

The app should allow registering one-time building expenses such as:

* Repairs
* Cleaning
* Equipment purchase
* Maintenance
* Other general expenses

Each expense includes:

* Month
* Date
* Category
* Description
* Amount
* Notes

⸻

6. Recurring Utility Bills

The app should support recurring building bills, such as:

* Electricity
* Water
* Gas
* Phone
* Internet
* Elevator service
* Municipality / waste fees
* Other recurring bills

The app should remember fixed bill information such as:

* Bill type
* Title
* Provider name
* Meter number
* Subscription number
* Bill ID
* Payment ID
* Notes

Each monthly bill payment should include:

* Related bill profile
* Month
* Bill period
* Issue date
* Due date
* Payment date
* Amount
* Payment tracking number
* Notes

Utility bills should be counted as expenses but shown separately in reports.

⸻

7. Dashboard

Dashboard should show:

* Selected month
* Building name
* Expected monthly charge
* Received payments
* Normal expenses
* Utility bills
* Total expenses
* Opening fund balance
* Current fund balance
* Debtor count

⸻

8. Monthly Reports

The app should generate a Persian monthly report including:

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

The app should also generate a short copyable message for residents suitable for WhatsApp or Telegram.

⸻

Technical Direction

Platform

* iOS
* iPadOS

Main Technology

* SwiftUI

Development Environment

* Swift Playgrounds on iPad
* Xcode in future if needed

Storage

* Local JSON storage using Codable

Current Constraints

* No server
* No login
* No external paid services
* No SwiftData for now
* No complex architecture
* Must remain beginner-friendly
* Must compile in Swift Playgrounds

⸻

Product Philosophy

P14 should remain practical and simple.

The goal is not to build a large enterprise system.
The goal is to build a usable app for real small-building management.

The app should feel more useful than Excel or handwritten notes.

⸻

What P14 Is

P14 is:

* A small building management app
* A personal productivity tool for building managers
* A financial tracker for monthly charges and expenses
* A simple resident/unit database
* A reporting tool

⸻

What P14 Is Not

P14 is not currently:

* A multi-building enterprise system
* A cloud SaaS product
* A public accounting platform
* A bank-connected payment system
* A legal property management system
* A full ERP

These may be considered in future versions only if the MVP becomes successful.

⸻

MVP Definition

The MVP is successful when the user can:

* Open the app
* Edit building information
* Set number of units
* Edit each unit
* Register payments
* Register expenses
* Register recurring utility bills
* Enter opening fund balance
* See dashboard summary
* See debtors
* Generate monthly report
* Copy resident message
* Close and reopen the app without losing data

⸻

Future Possibilities

Possible future features:

* PDF export
* Backup and restore
* iCloud sync
* Multiple buildings
* Receipt attachments
* Payment reminders
* Charts
* Persian calendar picker
* Resident-facing version
* Web dashboard
* Commercial version for small buildings

⸻

Current Stage

Current stage:

Early MVP development

The app has already moved from Python prototype to SwiftUI app development.