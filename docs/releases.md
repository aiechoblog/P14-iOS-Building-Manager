# P14 Releases

This document tracks important internal project versions.

---

## v0.1.0 — GitHub Baseline

Date: 2026-06-15

Status: Internal baseline

### Summary

This is the first organized GitHub baseline for P14.

At this point, the project includes:

- README.md
- Project documentation under docs/
- Swift source files under ios-app/
- Python prototype history
- Product brief
- Roadmap
- Feature list
- Data model
- UI flow
- Codex prompt archive
- Current status document

### Purpose

This version marks the transition from scattered prototype work into a structured software project.

### Included

Documentation:

- README.md
- docs/project-brief.md
- docs/roadmap.md
- docs/changelog.md
- docs/feature-list.md
- docs/data-model.md
- docs/ui-flow.md
- docs/codex-prompts.md
- docs/current-status.md

Source code:

- ios-app/MyApp.swift
- ios-app/Models.swift
- ios-app/Helpers.swift
- ios-app/P14Store.swift
- ios-app/ContentView.swift
- ios-app/DashboardView.swift
- ios-app/UnitsView.swift
- ios-app/UnitEditView.swift
- ios-app/BuildingSettingsView.swift
- ios-app/AddPaymentView.swift
- ios-app/AddExpenseView.swift
- ios-app/BillProfilesView.swift
- ios-app/BillProfileEditView.swift
- ios-app/AddBillPaymentView.swift
- ios-app/DebtorsView.swift
- ios-app/ReportView.swift

### Known Issues

- The GitHub version should be verified against the working Swift Playgrounds version.
- Any misplaced folders such as iOS-app/ios-app/ should be removed later.
- Swift Playgrounds compatibility must remain a priority.
- The app is still an early MVP and not ready for real users.

### Next Version

Planned next version:

v0.2.0 — Practical Building Setup

Target features:

- Stable building settings
- Editable units
- Opening fund balance
- Dynamic unit count
- Safe local JSON persistence