# Mind Trust (عقل وثقة)

A mobile app for **mental health consultations** in **Arabic**, with a right-to-left layout.  
Patients book sessions with approved doctors. Doctors manage their schedule and appointments.

---

## Table of contents

1. [What this app does](#what-this-app-does) — for clients & stakeholders  
2. [Who uses the app](#who-uses-the-app)  
3. [Main features](#main-features)  
4. [How booking works](#how-booking-works)  
5. [How payment works](#how-payment-works)  
6. [Reminders & notifications](#reminders--notifications)  
7. [What is included vs not included](#what-is-included-vs-not-included)  
8. [Where data is stored](#where-data-is-stored)  
9. [For developers](#for-developers)  
10. [Running the app](#running-the-app)  
11. [One-time Supabase setup](#one-time-supabase-setup)  
12. [Project folder overview](#project-folder-overview)

---

## What this app does

**Mind Trust** connects **patients** with **psychology professionals** on their phone (iPhone or Android).

- Patients can **sign up**, **browse doctors**, and **book a time slot** that the doctor has marked as available.  
- Doctors can **apply to join the platform**, upload documents, set their **session price** and **weekly schedule**, and **accept or manage** appointment requests.  
- The app is built for **Algeria-style payment brands** (Golden Card / Edahabia and CIB) in the **demo payment flow** — see [How payment works](#how-payment-works).

There is **no website version** in this repository — only the mobile app.

---

## Who uses the app

| Role | What they do in the app |
|------|-------------------------|
| **Patient** | Create an account, book appointments, pay when the doctor charges a fee, get reminders on their phone. |
| **Doctor** | Register with professional details and documents, wait for **admin approval**, then manage availability and appointments. |
| **Admin** (outside the app) | Approves new doctors in the **Supabase** online dashboard (not inside the mobile app). |

---

## Main features

- **Arabic interface** (RTL — text flows right to left).  
- **Email sign-up and login** with optional **reCAPTCHA** bot protection.  
- **Doctor onboarding** with document upload (stored securely in the cloud).  
- **Weekly schedule** — doctors choose when they are available; patients only see free slots.  
- **Appointment statuses** — e.g. waiting for payment, pending doctor approval, accepted, history.  
- **Demo payment screen** — looks like a real Algerian card checkout (Golden Card or CIB); **no real money** is charged in the current version.  
- **Local reminders** on the patient’s device after the doctor accepts a session.

---

## How booking works

**For the patient**

1. Sign in and choose a doctor.  
2. Pick a date and time from the doctor’s **available** slots.  
3. If the session has a **price greater than zero**, the app opens the **payment screen** (demo).  
4. After “payment,” the request goes to the doctor as **pending**.  
5. When the doctor **accepts**, the patient gets reminders before the session.

**For the doctor**

1. Register and wait until an admin sets their status to **approved** in Supabase.  
2. Set session price and weekly availability in the app.  
3. See new requests, **accept** them, and view accepted / history lists.  
4. If a booking was **already paid**, the doctor **cannot reject** it (business rule in the database).

**Free sessions**  
If the doctor’s session price is **0**, booking skips payment and sends the request directly.

---

## How payment works

> **Important for clients:** Today’s version uses a **simulated (mock) payment** inside the app.  
> It **does not** connect to a real bank or Chargily. **No real card is charged.**

| Topic | Explanation |
|--------|-------------|
| **What the user sees** | A checkout-style screen: choose **Golden Card (Edahabia)** or **CIB**, enter card-style fields, then a success screen. |
| **What happens in the background** | The app tells Supabase that payment is complete; the appointment moves from “awaiting payment” to “pending” for the doctor. |
| **Real payments later** | A future phase would plug in a real payment provider; the current UI is for **testing and demos** only. |

---

## Reminders & notifications

- Reminders run **on the patient’s phone** (local notifications).  
- They are scheduled **after the doctor accepts** the appointment (e.g. before the session, on the day of the session).  
- They do **not** require SMS in the current version.

---

## What is included vs not included

| Included in this project | Not included (yet) |
|--------------------------|---------------------|
| iOS and Android mobile app | Web app for patients or doctors |
| Supabase (login, database, file storage) | Real payment gateway / bank settlement |
| Demo Edahabia / CIB payment UI | Firebase |
| Doctor approval via Supabase dashboard | In-app admin panel |
| reCAPTCHA on login | SMS reminders |

---

## Where data is stored

All live data (accounts, appointments, payments records, uploaded files) is stored in **[Supabase](https://supabase.com)** — a secure cloud service (similar idea to “app backend in the cloud”).

- **No Firebase** is used in this project.  
- Patient and doctor passwords are handled by Supabase **authentication**; secret keys stay on the server, not in the app store build for production best practice.

---

## For developers

This section is for people who build or deploy the app.

### Technology in simple terms

| Layer | What it is | Used for |
|--------|------------|----------|
| **Flutter** | Google’s toolkit for one codebase → iOS + Android | The whole mobile app |
| **Dart** | Programming language for Flutter | All app logic under `lib/` |
| **Supabase** | Backend-as-a-service (PostgreSQL + auth + storage + serverless functions) | Login, data, files, payment confirmation |
| **TypeScript** | Language for small server scripts | `supabase/functions/payment` and `verify-recaptcha` |
| **SQL** | Database scripts | `supabase/migrations/` — run once in Supabase SQL Editor |

### Languages & tools

| Item | Version / notes |
|------|----------------|
| **Dart SDK** | `>=3.2.0` (see `pubspec.yaml`) |
| **Flutter** | 3.x recommended |
| **State management** | Riverpod |
| **Navigation** | go_router |
| **IDE** | Cursor or VS Code + Flutter extension |
| **iOS builds** | macOS + Xcode + CocoaPods |
| **Android builds** | Android Studio + SDK |
| **Optional** | Node.js — only if you use `npx supabase` CLI to deploy functions |

### Development environment

- **OS:** Developed on **macOS** (iOS Simulator + Android Emulator).  
- **Platforms:** iOS and Android only.  
- **Backend:** Hosted Supabase project (cloud) — no custom Node/Python server in this repo.  
- **Config file:** `supabase.env.json` (copy from `supabase.env.example.json`) — holds project URL and public anon key for local runs.

---

## Running the app

### Connected to Supabase (normal development)

```bash
cd mind_trust
flutter pub get
./run_supabase.sh
```

`./run_supabase.sh` loads keys from `supabase.env.json` and starts the app on a simulator or device.

### Offline demo (no Supabase)

```bash
flutter run
```

Data stays **in memory only** — useful for quick UI tests; **registration will not appear in Supabase.**

---

## One-time Supabase setup

Do this once per Supabase project.

### 1. Create a Supabase project

Sign up at [supabase.com](https://supabase.com) and create a project.

### 2. Run database scripts (migrations)

In the Supabase dashboard → **SQL Editor**, run these files **in order** from `supabase/migrations/`:

| Order | File | Purpose (plain English) |
|-------|------|-------------------------|
| 1 | `001_initial_schema.sql` | Core tables: users, doctors, appointments |
| 2 | `002_scheduling_security_notifications.sql` | Scheduling and security rules |
| 3 | `003_storage_policies.sql` | Rules for uploaded files |
| 4 | `004_admin_doctor_review.sql` | Doctor approval workflow |
| 5 | `004_fix_rls_recursion.sql` | Fix sign-up error if you see “infinite recursion” on `profiles` |
| 6 | `004_fix_storage_upload.sql` | Storage upload fixes (if needed) |
| 7 | `006_remove_sms.sql` | Removes SMS-related pieces |
| 8 | `007_patient_date_of_birth_profile.sql` | Patient profile fields |
| 9 | `008_payments_chargily.sql` | Payments table (filename is historical; not Chargily) |
| 10 | `009_payments_doctor_read.sql` | Doctors can read payment info |
| 11 | `010_block_reject_paid_appointment.sql` | Block rejecting paid bookings |

### 3. Create storage buckets

In **Storage**, create:

- `doctor-documents` (private)  
- `doctor-profiles` (public)

### 4. Email settings (development)

**Authentication → Providers → Email** → turn off **Confirm email** while testing so doctors can finish sign-up from the app.

### 5. Approve doctors

After a doctor registers in the app:

- Open **Table Editor → `doctors`**  
- Change `status` from `pending` to `approved` for that doctor  

Or in SQL Editor:

```sql
select * from public.pending_doctor_applications;
update public.doctors set status = 'approved' where user_id = 'PASTE-UUID-HERE';
```

### 6. Deploy server functions (Edge Functions)

In **Edge Functions**, create and deploy:

| Function name | Source file | JWT verification |
|---------------|-------------|------------------|
| `payment` | `supabase/functions/payment/index.ts` | **OFF** |
| `verify-recaptcha` | `supabase/functions/verify-recaptcha/index.ts` | **OFF** |

For `verify-recaptcha`, add secret **`RECAPTCHA_SECRET_KEY`** under **Edge Functions → Secrets** (never put the secret key inside the mobile app).

### 7. reCAPTCHA (login protection)

- Copy `supabase.secrets.example.json` → `supabase.secrets.local.json` and add your secret (file is git-ignored).  
- Public site key in the app (or pass via `--dart-define=RECAPTCHA_SITE_KEY=...`).

### 8. Test paid booking

1. Set a doctor’s **session price ≥ 75 DZD** (or your test minimum).  
2. Run `./run_supabase.sh`.  
3. Book as a patient → **Confirm & pay** → complete the demo payment form.  
4. Doctor should see the request as **pending**, then **accept**.

---

## Project folder overview

```
mind_trust/
├── lib/                 # Mobile app (Dart / Flutter)
├── assets/              # Images, reCAPTCHA page, env template
├── supabase/
│   ├── migrations/      # Database setup scripts (SQL)
│   └── functions/       # Cloud functions (payment, reCAPTCHA)
├── run_supabase.sh      # Start app with Supabase keys
├── pubspec.yaml         # App dependencies
└── README.md            # This file
```

**Logo asset:** `assets/mindtrustlogo-removebg-preview.png` (login screens).

---

## Quick reference — roles after sign-up

| Role | Sign-up details | After sign-up |
|------|-----------------|---------------|
| **Patient** | Name, phone, age, gender, password | Book available slots |
| **Doctor** | Full profile + documents | `pending` until admin approves in Supabase; then manage schedule |

---

## Support & handoff notes

- **Demo payment** is intentional for MVP demos and user testing.  
- **Production launch** will need: real payment provider, production Supabase keys, app store accounts, and privacy/terms review.  
- For function deploy details, use the Supabase dashboard **Edge Functions** editor and paste code from `supabase/functions/`.

*Last updated for mock payment flow (Golden Card / CIB UI, no Chargily).*
