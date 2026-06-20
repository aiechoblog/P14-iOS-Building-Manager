P14 Codex Prompts

This document stores important prompts used with Codex during P14 development.

The goal is to keep the AI workflow organized and reusable.

⸻

Prompt Rules

When asking Codex to change the app:

* Ask for runnable code, not only explanation.
* Ask for file-by-file output.
* Keep Swift Playgrounds compatibility.
* Keep one @main only in MyApp.swift.
* Avoid huge single-file code.
* Avoid hidden characters.
* Ask Codex not to break existing features.
* Ask for migration if data model changes.
* Test after each major change.

⸻

Prompt 1 — Build Runnable SwiftUI App

Build a runnable iOS/iPadOS app for the P14 building management project.
The goal is not only design or architecture.
The goal is a working app that I can run.
Project name:
P14
Platform:
- iPhone and iPad
- SwiftUI
- Swift Playgrounds compatibility on iPad
- Local storage only
- No server
- No login
- Persian UI
- Right-to-left layout
Build Version 1 as a complete runnable app.
Core features:
1. Dashboard
2. Units
3. Add payment
4. Add expense
5. Debtors
6. Monthly report
7. Copyable residents message
Storage:
Use local persistence with Codable + JSON.
Important:
- Do not only explain.
- Generate actual runnable Swift code.
- Provide all required files.
- Provide exact file structure.
- Include sample data.
- The app should launch directly into a usable interface.
- Avoid overengineering.

⸻

Prompt 2 — Refactor for Swift Playgrounds

The single-file SwiftUI app causes Swift Playgrounds errors on iPad.
Refactor the P14 SwiftUI app into multiple clean Swift files for Swift Playgrounds.
Requirements:
- No hidden characters
- Plain UTF-8 Swift code
- Keep Persian UI text
- Keep one @main only in MyApp.swift
- ContentView.swift should only contain the main TabView
- Split models, store, helpers, and views into separate files
Files:
1. MyApp.swift
2. Models.swift
3. Helpers.swift
4. P14Store.swift
5. ContentView.swift
6. DashboardView.swift
7. UnitsView.swift
8. AddPaymentView.swift
9. AddExpenseView.swift
10. DebtorsView.swift
11. ReportView.swift
Important:
- Each file must include needed imports.
- Do not include @main except in MyApp.swift.
- Avoid complex expressions that Swift Playgrounds may fail to type-check.
- Provide full code for each file separately.

⸻

Prompt 3 — Add Building Settings, Editable Units, Opening Balance, and Utility Bills

We have a runnable SwiftUI iPad/iOS app called P14.
Current status:
- The app already runs in Swift Playgrounds on iPad.
- It has Dashboard, Units, Payments, Expenses, Debtors, and Report.
- Code is split into multiple Swift files.
- Local persistence uses Codable + JSON.
- Persian UI and right-to-left layout are already used.
- There must be only one @main, and it must remain in MyApp.swift.
Important goal:
Improve the existing runnable app without breaking it.
Do not only explain.
Do not only propose architecture.
Return actual updated Swift code files that I can paste into Swift Playgrounds.
Constraints:
- Keep Swift Playgrounds compatibility on iPad.
- Keep local JSON persistence using Codable.
- No SwiftData.
- No external libraries.
- No server.
- No login.
- Keep code beginner-friendly.
- Avoid huge single-file code.
- Avoid complex Swift expressions.
- Clean UTF-8 Swift code.
- Do not include hidden or unprintable characters.
- Do not include @main except in MyApp.swift.
Add:
1. Building settings
2. Opening fund balance
3. Dynamic number of units
4. Editable units
5. Recurring utility bills
6. Data migration
7. Dashboard update
8. Report update
Definition of done:
The app compiles and runs in Swift Playgrounds.
The user can edit building information, set number of units, edit units, enter opening fund balance, add/edit bill profiles, register bill payments, and see updated dashboard/reports.

⸻

Prompt 4 — Fix Swift Playgrounds Errors

The app is being pasted into Swift Playgrounds on iPad.
Please fix the code for Swift Playgrounds compatibility.
Known problems:
- Duplicate @main
- Missing import SwiftUI
- Hidden or unprintable characters
- Compiler type-checking too slow
- Too much code in one file
Rules:
- Keep only one @main in MyApp.swift.
- Every SwiftUI View file must start with import SwiftUI.
- Model files can use import Foundation.
- Avoid hidden characters.
- Avoid long complex chained expressions.
- Replace complex digit conversion with simple switch-based functions.
- Keep files small.
- Provide file-by-file corrected code.

⸻

Prompt 5 — Update Documentation After Code Changes

After updating the P14 app, update the documentation.
Please update:
- README.md
- docs/changelog.md
- docs/feature-list.md
- docs/data-model.md
- docs/ui-flow.md
Include:
- What changed
- What files changed
- What features were added
- What is still planned
- Known issues
- Next steps

⸻

Notes

Good Codex prompts should be:

* Specific
* File-based
* Build-focused
* Small enough to test
* Clear about constraints
* Clear about what must not break

P14 is not only a coding project.

It is also a test of an AI-assisted product development workflow.