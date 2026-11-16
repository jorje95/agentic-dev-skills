---
name: intentional-product-design
description: >-
  Anti-"vibecoded" UI/UX audit and redesign framework (derived from VibeMole's StyleMole 14-signal guide). Eliminates nested card overload, generic feature grids, decorative gradients/glows, pill badge spam, vague SaaS copy, flat typography, icon-box grids, decorative colored borders, fake product evidence, and purposeless motion. Use when designing, auditing, or refactoring landing pages, web apps, browser extensions, or mobile UIs.
---

# Intentional Product Design (Anti-Vibecoded UI/UX)

> Core rule: **Vibe coding is not the problem — shipping the first default AI output is.** A page feels "vibecoded" when 5–10 small defaults stack together into something that looks plausible, polished, and completely indistinguishable from every other AI-generated SaaS template.

## The 14 Anti-Patterns & Concrete Fixes

1. **No Cards Inside Cards Inside Cards**
   - *Signal:* Outer rounded container → inner glass panel → 3 feature cards → icon tile → badge → progress bar.
   - *Fix:* Remove at least one wrapper layer from every section. Each container must earn its place by grouping genuinely related data or showing real product evidence — never decoration.
2. **Break the Default Feature Grid**
   - *Signal:* Equal-weight 3- or 6-card grid with identical icon boxes, short headings, and 2-line descriptions.
   - *Fix:* Make one primary workflow or artifact **visually dominant**. Replace "feature grid" thinking with a concrete user workflow (input → what happens → output).
3. **One Visual Signature, Not Decorative Glows**
   - *Signal:* Unmotivated purple/blue gradients, blurred orbs, gradient headline text, neon borders, glassmorphism.
   - *Fix:* Pick one restrained accent color, one intentional visual signature, and real product evidence instead of floating blobs. Trust/audit/verification products lose credibility with excessive glow.
4. **Eliminate Pill Badge Spam**
   - *Signal:* Eyebrow pills above every heading (`"AI Powered"`, `"Privacy First"`, `"Built for..."`, `"Beta"`, `"New"`).
   - *Fix:* Keep 1–2 badges only if they convey verifiable facts (e.g., `"Manifest V3"`, `"Open-Source"`). Delete decorative filler pills.
5. **Replace Vague SaaS Copy with Product-Specific Verbs**
   - *Signal:* `"Effortless"`, `"Seamless"`, `"Supercharge"`, `"Unlock"`, `"Transform your workflow"`, `"Ship with confidence"`.
   - *Fix:* State what the product actually *checks, extracts, compares, blocks, exports, or warns about*. If a sentence could describe 500 other SaaS products, rewrite it.
6. **Vary Section Headings (Pass the H2 Read-Aloud Test)**
   - *Signal:* Repeated heading templates (`"Everything you need to..."`, `"Built for..."`, `"Powerful features for..."`).
   - *Fix:* Read all `H2` headings out loud in sequence. Each heading must name concrete product behavior or a specific user question.
7. **Establish Real Typographic Hierarchy (Not Flat Sans)**
   - *Signal:* Uniform font weights where H1, H2, card titles, labels, and body all feel the same weight/scale.
   - *Fix:* Define a strict scale: one unmistakable `H1`, one clear `H2`, readable body text, and quiet metadata/captions that never compete with headings. Use fewer weights with sharper contrast between levels.
8. **Avoid Identical Icon-Box Grids**
   - *Signal:* Every item uses the same Lucide/icon square + 2-word title + 2-line blurb.
   - *Fix:* Use icons only where they clarify an action or state. Mix in real UI outputs, examples, or checklists instead of decorative icon tiles.
9. **Reserve One-Sided Colored Borders for Meaning**
   - *Signal:* Decorative left/top accent strips on every card or callout.
   - *Fix:* Use colored borders strictly for semantic meaning (severity, verdict, status) — never to fill empty space.
10. **Never Use Dark Mode to Hide Weak Structure**
    - *Signal:* Dramatic dark canvas + glow + glass cards that fail to explain what the product does.
    - *Fix:* Ensure the page answers 6 concrete questions cleanly in daylight *before* styling dark mode:
      1. What does this do?
      2. Who is it for?
      3. What do I enter / select?
      4. What do I get back?
      5. What happens next?
      6. Why should I trust the result?
11. **Zero Fake Product Evidence**
    - *Signal:* Fake dashboards, placeholder customer logos, fabricated `"Trusted by"` strips, or implied live metrics on static demos.
    - *Fix:* Show an honest, clearly labeled sample finding, real checklist, or exact before/after output. Say less and show real evidence.
12. **Purposeful Motion Only (No Pulsing Dots)**
    - *Signal:* Pulsing status dots next to static labels, infinite card glows, moving gradients, animated button borders.
    - *Fix:* Motion must communicate real state (active scan stages, revealing a finding, highlighting a passage) and respect `prefers-reduced-motion: reduce`.
13. **Ban Confident-Sounding Empty Claims**
    - *Signal:* Polished sentences that avoid specifics (`"Get actionable insights to improve your experience"`).
    - *Fix:* Trade polish for precision. Longer, concrete explanations build more trust than short slogans.
14. **Make the Product Workflow Visible**
    - *Signal:* Landing page lists benefits without showing step-by-step usage.
    - *Fix:* Show the exact flow visibly (e.g., *Select a claim → Check what sources say → Inspect numbered evidence*).

## 5-Step Redesign Checklist (Run Before Shipping)

1. **Replace vague copy** with product-specific verbs and verifiable facts.
2. **Remove at least one wrapper/card layer** from every over-wrapped section.
3. **Make one artifact visually dominant** (the actual product output, finding, or interactive workflow).
4. **Show real product evidence** (honest labeled examples, exact source trails, real checklists).
5. **Apply strict design constraints** in code and prompts (no decorative gradients, no nested cards, no badge spam, clear H1→H2→body hierarchy).
