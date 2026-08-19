# Design - AI CV Builder

A locked mobile design system based on the approved "Soft Glass Refined"
direction. Every product screen uses the same tokens and component voice.

## Genre
- Atmospheric mobile workbench.
- Frosted, gentle, approachable, and compact.
- The atmosphere supports the interface; it never competes with content.

## Macrostructure
- Dashboard: personal greeting, resume score, quick actions, recent resumes,
  persistent glass dock with a centered create action.
- Editor: compact app bar, progress summary, segmented steps, one focused form.
- Templates: compact two-column product catalogue and persistent save actions.
- Preview: document-first review with quiet edit and export controls.

## Color
- Background top: `#174B77`.
- Background middle: `#103B63`.
- Background bottom: `#092845`.
- Primary action: `#2F8DFF`; primary light: `#72B5FF`.
- Progress accent: `#65D5EE`.
- Primary text: `#F7FBFF`; secondary text: `#C8D9E8`.
- Glass fill: white at 10%; strong glass fill: white at 17%.
- Glass border: white at 30%; soft border: white at 15%.
- Status colors appear only for real status information.

## Typography
- Primary UI font: Inter.
- Headings are upright, medium or semibold, and compact.
- Dashboard greeting is 24 px; screen titles are 18 px; section titles are 13 px.
- Supporting labels use 9-12 px with sufficient contrast and line height.
- Avoid oversized SaaS marketing headlines inside product screens.

## Spacing
- Use a 4-point base scale.
- Screen gutters: 20 px; compact gutters: 12-16 px.
- Section rhythm: 18-24 px; card padding: 12-14 px.
- Controls remain single-line at 320, 375, 414, and 768 px widths.

## Components
- Glass cards: 12 px radius, 1 px translucent border, 16 px background blur.
- Primary buttons: blue gradient, 9 px radius, 44 px standard height.
- Secondary buttons: frosted fill, thin glass border, 9 px radius.
- Inputs: frosted fill, 10 px radius, clear blue focus border.
- Navigation: floating glass dock with four destinations and a centered blue FAB.
- Score indicators: restrained cyan progress; no unrelated green metric tiles.
- Template previews: white document samples in a compact two-column grid.

## Background
- Use the three-stop petrol-blue diagonal gradient on every product screen.
- Two low-opacity diagonal light planes provide depth.
- Do not add radial neon blooms, decorative particles, or purple gradients.

## Motion
- Page reveal: opacity plus 12 px vertical translation, 360 ms ease-out.
- Selection and control transitions: 180-220 ms ease-out.
- Editor step change: short horizontal translate plus opacity.
- Reduced-motion mode removes spatial movement.
- Never use bounce, elastic motion, or perpetual animation.

## Product Voice
- Confident, calm, and practical.
- Dashboard copy is personal and task-oriented, not promotional.
- Primary actions use direct verbs: Create, Save, Export, Improve.

## Source Of Truth
- Flutter color tokens: `lib/app/theme/app_colors.dart`.
- Flutter theme: `lib/app/theme/app_theme.dart`.
- Shared surfaces and dock: `lib/core/widgets/`.
