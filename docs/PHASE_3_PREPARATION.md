# Phase 3 Preparation: PRO Application Pack

Phase 3 turns the CV builder into a job-application workspace. The planned
outcome from [ROADMAP.md](../ROADMAP.md) is:

- protected backend API
- job-description intake
- PDF resume import
- AI comparison between a resume and a job
- reviewed, restorable revisions

This document is a preparation checkpoint. It does not mark Phase 3 complete
and does not require production secrets in the mobile app.

## Current Baseline

Already available:

- local-first resume editing and Supabase resume sync
- anonymous Supabase authentication with row-level ownership policies
- immutable resume version snapshots with a 20-version retention trigger
- vector PDF export
- Turkish and English localization
- 16 template renderers with measured pagination
- automated coverage for pagination, Unicode, templates, PDF generation, and
  editor card state

Not available yet:

- a protected server-side AI endpoint
- job-description storage and parsing
- PDF/document import and text extraction
- structured match results and explainable recommendations
- a user review screen for proposed changes
- usage limits, idempotency, and abuse controls for AI requests

## Recommended Delivery Order

### 3.0 Contract and Security Foundation

Create the server boundary before adding AI UI:

- Add a server-side function or API route for all AI requests.
- Keep provider keys and prompts outside Flutter.
- Authenticate every request with the Supabase user session.
- Validate resumeId, job text size, language, and requested operation.
- Add an idempotency key and request status so retries cannot create duplicate
  revisions.
- Persist request metadata without storing provider secrets or unnecessary
  personal data.

Acceptance criteria:

- unauthenticated and cross-user requests are rejected
- no provider key exists in the mobile bundle
- repeated client retries return one logical operation
- errors are safe, localized, and actionable

### 3.1 Job Intake

Add a job_postings document owned by the user:

- title, company, source URL, raw text, detected language
- normalized requirements and optional notes
- created/updated timestamps
- schema version and sync state

Support paste-first intake initially. URL fetching should be a later,
server-side capability with explicit domain and size limits.

Acceptance criteria:

- pasted text survives app restart and sync
- empty or very short descriptions are rejected with a clear message
- Turkish characters and line breaks are preserved
- the user can edit or delete an intake without affecting the original CV

### 3.2 PDF Import

Keep import separate from export:

- select a local PDF
- extract text off the UI thread
- show the extracted text before parsing
- map only supported fields into a new draft
- preserve the original file metadata locally; do not upload it by default

The importer must report scanned/image-only PDFs as unsupported or route them
to an explicitly consented OCR service. It must never silently invent fields.

Acceptance criteria:

- import never overwrites the active resume
- extraction errors leave the current resume untouched
- imported Turkish text remains Unicode-correct
- the user confirms before creating a new draft

### 3.3 AI Comparison

Use a versioned request/response contract:

- input: selected resume version, job posting, locale, operation id
- output: match score, matched requirements, missing requirements,
  keyword suggestions, evidence references, and confidence
- every recommendation links back to source resume or job text
- generated text is a proposal, never an automatic overwrite

The first operation should be deterministic comparison and explanation.
Generation of improved bullets can follow after the comparison contract is
stable.

Acceptance criteria:

- result identifies evidence for each important recommendation
- unsupported claims are never presented as existing experience
- Turkish and English labels match the selected app locale
- stale results cannot be applied to a newer resume version

### 3.4 Reviewed Revisions

Add a review flow that reuses the existing version infrastructure:

- show original and proposed text side by side
- allow accept, reject, and edit per change
- create a new snapshot only after explicit user confirmation
- preserve the source version and comparison result
- provide restore from version history

Acceptance criteria:

- no AI result changes the resume without an explicit accept action
- partial acceptance creates a valid resume
- rejected suggestions are not silently reintroduced
- restore remains available after a revision is accepted

## Data Model Direction

The likely Phase 3 tables are:

- job_postings
- job_analysis_runs
- job_analysis_items
- resume_revision_drafts

Every table should include user_id, ownership RLS, timestamps, and a schema
version where the stored shape may evolve. Analysis records should reference
the exact resume_version_id or immutable document hash used as input.

## Release Gates

Before calling Phase 3 complete:

- run the full Flutter test suite
- add server contract and RLS tests
- test offline behavior and retry/idempotency behavior
- test Turkish and English content end to end
- verify no secret is present in APK strings
- verify imported documents cannot overwrite existing resumes
- verify AI suggestions are reviewable and reversible
- update ROADMAP.md only after the checkpoint is implemented, verified,
  committed, and pushed

## First Implementation Slice

The safest first slice is 3.0 Contract and Security Foundation plus a
paste-only 3.1 Job Intake screen. It gives the product a useful PRO entry
point and establishes the data contract before PDF parsing or AI generation
adds complexity.
