P14 Current Status

Date

2026-06-15

Project Status

P14 is currently in early MVP development.

The project has moved through three stages:

1. Concept and real building-management need
2. Python prototype on iPad using Pyto
3. SwiftUI iOS/iPadOS app prototype using Swift Playgrounds

⸻

What Is Done

Repository

GitHub repository created:

P14-iOS-Building-Manager

Documentation

The following documentation files have been created:

* README.md
* docs/project-brief.md
* docs/roadmap.md
* docs/changelog.md
* docs/feature-list.md
* docs/data-model.md
* docs/ui-flow.md
* docs/codex-prompts.md

iOS App Files

Swift files have been added under:

ios-app/

The app currently contains SwiftUI files for:

* App entry point
* Models
* Helpers
* Store
* Dashboard
* Units
* Unit editing
* Building settings
* Payments
* Expenses
* Bill profiles
* Bill payments
* Debtors
* Reports

⸻

Current Product Direction

P14 is intended to become a Persian iOS/iPadOS building management app for small residential buildings.

The app should support:

* Building settings
* Editable units
* Owners and tenants
* Monthly charge payments
* Normal expenses
* Opening fund balance
* Recurring utility bills
* Debtor tracking
* Monthly reports
* Copyable resident messages

⸻

Current Technical Direction

* SwiftUI
* Swift Playgrounds compatibility
* Local JSON persistence using Codable
* Persian UI
* Right-to-left layout
* No server
* No login
* No external libraries
* No SwiftData for now

⸻

Known Issues

* Swift Playgrounds can be sensitive to:
    * duplicate @main
    * hidden/unprintable characters
    * large single files
    * complex Swift expressions
* File paths in GitHub must remain consistent.
* Official source folder should be:

ios-app/

Not:

iOS-app/ios-app/

⸻

Next Technical Step

The next step is to verify that the GitHub version matches the working Swift Playgrounds version.

After that, the next development step is:

1. Make sure app still runs.
2. Fix any GitHub file path mistakes.
3. Create a stable baseline version.
4. Continue feature development from that baseline.

⸻

Next Product Step

The next product milestone is:

MVP-1: Practical Building Setup

MVP-1 should include:

* Edit building information
* Edit units
* Set number of units
* Add opening fund balance
* Save all changes locally
* Reopen app without losing data

After MVP-1, the next milestone is:

MVP-2: Recurring Utility Bills