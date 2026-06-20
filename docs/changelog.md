P14 Changelog

All important project changes should be recorded here.

Format:

YYYY-MM-DD
- Change 1
- Change 2
- Change 3

⸻

2026-06-15

* Created GitHub repository: P14-iOS-Building-Manager.
* Added initial README.md.
* Added docs/project-brief.md.
* Defined P14 as a Persian iOS/iPadOS building management app.
* Documented the shift from Python prototype to SwiftUI iOS app.
* Defined core product scope:
    * Building settings
    * Units and residents
    * Monthly payments
    * Expenses
    * Utility bills
    * Opening fund balance
    * Debtors
    * Monthly reports
* Started organizing project documentation inside the docs/ folder.

⸻

2026-06-14

* Built initial SwiftUI version of P14 using Codex.
* App was tested inside Swift Playgrounds on iPad.
* Encountered Swift Playgrounds issues:
    * Duplicate @main
    * Missing import SwiftUI
    * Type-checking issues in digit conversion helpers
    * Hidden/unprintable character errors
* Learned that Swift Playgrounds requires smaller, cleaner Swift files.
* Refactored direction toward split Swift files instead of one huge Swift file.
* Confirmed that the app can run after correcting project structure.

⸻

2026-06-13

* Installed and tested Pyto on iPad.
* Created first Python prototype of P14.
* Ran the first P14 Python script on iPad.
* Confirmed local JSON storage approach.
* Built a terminal-based Python version with:
    * Units
    * Payments
    * Expenses
    * Debtors
    * Monthly report
* Discovered that terminal UI is not practical for real building management.
* Decided to move toward a real iOS/iPadOS app.

⸻

2026-06-12

* Started the P14 idea from a real building management need.
* Initial concept:
    * Manage a small residential building.
    * Avoid bringing laptop home.
    * Use iPad as the main working device.
* Explored Python on iPad.
* Compared Pyto and Pythonista.
* Chose Pyto for the first prototype.

⸻

Notes

This changelog should be updated after every meaningful change, especially when:

* A new feature is added.
* A bug is fixed.
* A major decision is made.
* Codex generates a new version.
* The app successfully runs after a major change.
* A feature is removed or delayed.

⸻

Current Project Status

Current status:

Early MVP development

The project has:

* GitHub repository
* README
* Project brief
* Roadmap
* Changelog
* Python prototype history
* SwiftUI app direction

Next planned documents:

* Feature list
* Data model
* UI flow
* Codex prompts archive