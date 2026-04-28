# Presenter Retrospective — Isambard 3 Practical Workshop (21 April 2026)

This document records the presenter’s observations from the creation and delivery of the workshop, including what went
well, what did not, and what should be done differently in future runs. It is written for future presenters,
maintainers, and any stakeholders involved in planning similar events.

## Context and Timeline

The workshop was conceived as a practical companion to the Isambard 3 HPC Showcase (20 April 2026). One pre-existing
BriCS tutorial existed that covers related ground: [Installing and Running
Software](https://docs.isambard.ac.uk/user-documentation/tutorials/intro-tour/). Reviewing its content makes clear why
it could not serve as the basis for this workshop. The tutorial is written for Isambard-AI (a GPU system), not Isambard
3 (a CPU-only Grace system): its Slurm examples use `--gpus` flags throughout and explicitly note they assume GPU
compute nodes; the interactive session examples start with `srun --gpus=1`; and the multi-node benchmark job requests
eight GPUs. None of these translate directly to Isambard 3. Beyond the platform mismatch, the tutorial is designed for
individual self-paced study, not for facilitated group delivery, and it does not cover the topics most relevant to this
workshop’s audience — debugging failed jobs, CPU parallelism strategies, or anything specific to the Grace CPU
architecture. It is a useful reference document, but a very different kind of artefact.

The timeline of the development effort is worth recording precisely. A first draft of the workshop schedule was produced
on 26 March 2026. The repository was created on 9 April, and the decision that materials needed to be built from scratch
— rather than adapting existing content — was confirmed on 10 April. The workshop ran on 21 April. The effective
development window was approximately eleven days. This is not a comment on anyone’s individual decisions; it reflects
the pace at which the event came together and the absence of a standing library of workshop materials to draw from.
Placing full responsibility for creating, reviewing, and delivering a workshop on a single individual under these
conditions was disproportionate to the stakes involved. Future workshops should build in a longer lead time, shared
authorship, and review cycles, so that no single person carries the entire risk.

A secondary factor is a tendency — understandable but worth naming — for the materials to grow in scope when one person
is both the domain expert and the author with no external brake. Without time for feedback or iteration, it is very
difficult to cut material, because everything feels necessary. The result here was a workshop that was technically
thorough but significantly over-scoped for the actual audience on the day.

## Audience Profile: Expectations vs Reality

Pre-registration responses indicated roughly equal numbers of beginners and intermediate users. On the day, the actual
experience level of participants was substantially lower. Some participants were unfamiliar with basic terminal
operations such as copy-pasting commands from a document into a shell. Only a small minority — perhaps a quarter of the
room — could follow the interactive exercises at a comfortable pace. The majority listened and observed rather than
actively completing the exercises.

This gap between registered level and actual level is a known risk with self-reported surveys; people often self-assess
optimistically, particularly for skills they have used occasionally but not built into regular practice.

For future planning, participants should be treated as falling into three distinct groups, and the design should
acknowledge this explicitly:

- **Group 0 — UNIX beginners:** Participants who lack sufficient command-line fluency to follow HPC materials without
  prior preparation. These participants need a prerequisite session on terminal basics before they can benefit from an
  HPC workshop. They should be identified and redirected before arrival rather than discovered on the day.
- **Group 1 — HPC beginners:** Participants who are comfortable in a terminal but are new to HPC concepts — job
  schedulers, resource requests, thinking about the “shape” of a job. This is the correct target audience for this
  workshop.
- **Group 2 — Intermediate/advanced HPC users:** Participants who are comfortable accessing and submitting jobs on an
  HPC system but are new to Isambard 3 specifically, or want to improve efficiency, understand the CPU architecture,
  parallelise workloads effectively, or adopt better reproducibility practices. These participants would benefit from a
  separate, more advanced session.

Running a single session that tries to serve all three groups simultaneously is structurally difficult and risks
satisfying none of them well.

The pre-workshop communication should set clear expectations: the session runs at group pace, helpers circulate for
individual support, and participants who encounter blocking issues during a section should raise a hand for helper
support rather than stopping the presenter. A prerequisite check — confirming that participants have completed the setup
steps and have a working login before arriving — would significantly reduce the likelihood of individual blockages
disrupting the room.

## Delivery: What Happened on the Day

Approximately halfway through the session, it became clear that the interactive format was not working for the majority
of the room. The decision was made to shift to a presenter-led demo mode, with interactive exercises becoming optional
for those who could keep up rather than required for everyone. The key adjustments were:

- **Section 4:** The fallback path (loading a centrally pre-configured environment) became the default rather than the
  alternative. This was the right call given the room, but it means participants did not build the environment
  themselves and may not be able to reproduce the setup independently.
- **Section 5:** Only the earlier examples (single job and the Monte Carlo Pi timing table) were demonstrated. The array
  job and GNU Parallel exercises were not completed as hands-on activities.
- **Section 6:** Skipped entirely due to time.

These are significant departures from the intended workshop design and suggest that the planned 2.5 hours is not enough
to cover the current scope even for a Group 1 audience, let alone a mixed room with Group 0 participants present.

## Materials: Navigation and Accessibility

Participants needed to navigate to the workshop materials independently during the session. The path — finding the
repository URL, landing on the right page, and then knowing which section to look at — was not straightforward for many.
The slide-based format (Reveal.js) is appropriate for presenter-led sections, but it is not well suited to self-directed
navigation: there is no persistent table of contents, no visible progress indicator, and the arrow-key navigation is not
obvious to participants who have not used it before.

A live discussion channel would have helped participants stay oriented. A GitHub Discussions thread was used on the day
but was a subpar experience for sharing links and short snippets in real time. Creating a Teams group or Slack channel
was not practical given the logistics and the absence of shared organisational infrastructure across institutions.

For future runs, a shared HackMD document (or equivalent) prepared before the session — with section links, the current
URL, short commands to copy, and a place to paste output for comparison — would significantly improve the experience.
Establishing this “single onboarding link” and walking everyone through it in the first five minutes of the session
should be a standard step.

The website format itself is worth revisiting. The materials were deliberately designed not to resemble a documentation
site, partly to avoid duplication with the official Isambard 3 documentation. However, a documentation-style structure —
such as JupyterBook, as used by the Centre for Reproducible Research — would make the materials significantly easier to
navigate, both for participants during the session and for anyone returning to the materials afterwards. It is worth
asking whether a dual-compilation approach (the same source rendered as both a slide deck for live delivery and a
structured web page for self-study) is achievable within the existing toolchain.

## Coordination: Helpers and Stakeholders

Helpers from the RSE group and from BriCS were present on the day, and their support was valuable. However, coordinating
a shared understanding of the materials in advance — what was being taught, where the exercises lived, what the common
failure modes were, and how to handle edge cases — was difficult given the compressed timeline. Helpers effectively had
to read the materials cold.

For future runs, a brief helper briefing document — distinct from the detailed MAINTAINER.md — would be useful. This
should be a one-page summary: session structure, the most common issues participants are likely to hit, and what to do
when someone is blocked versus when to redirect to support. It should be short enough to read in ten minutes.

More broadly, helper coordination benefits from a shared understanding of the system that goes beyond any single
workshop. Helpers who work regularly with Isambard 3 users should have a common baseline — this is partly addressed by
the official documentation, but explicit workshop-specific notes fill the gap between “what the docs say” and “what we
actually teach here and why”.

## Structural and Political Context

Several structural tensions affected both the creation and delivery of this workshop, and they are worth naming clearly
so that future organisers can take them into account.

**Cross-institutional coordination is difficult.** GW4 comprises four universities, each with its own RSE team. BriCS
hosts and operates Isambard 3, but RSE support for users is distributed across the partner institutions. These are not a
single team with a shared goal and shared capacity; they are separate groups with separate pressures who cooperate on an
ad hoc basis. Meaningful coordination — co-authoring materials, running joint review cycles, building a shared
understanding of what to teach — requires sustained time investment that none of the parties currently has budgeted for.
A lightweight steering group or committee with representation from BriCS and each university’s RSE team would help, but
only if all parties genuinely have time allocated for it rather than treating it as an add-on to already full schedules.

**The relationship between workshop materials and official documentation needs clarifying.** The workshop materials were
deliberately designed to complement rather than duplicate the official Isambard 3 documentation. In practice, the
official documentation has gaps that the workshop fills with more specific or opinionated guidance. This creates a
structural tension: workshop materials that are harder to navigate because they avoid the documentation format, and
teaching practices that cannot easily feed back into the official docs. Establishing a clearer agreement on scope — what
belongs in the documentation, what belongs in workshop materials, and how the two relate — would benefit both.

**The format dimension is worth revisiting.** The current workshop is a single format — a structured, scheduled, group
session. Other formats may be more appropriate for different needs: a shorter, drop-in office-hours session for
one-on-one SSH and login help; a hackathon-style session where participants work on their own code with helpers
circulating; a masterclass for a more advanced audience. Planning a small portfolio of formats, rather than a single
monolithic workshop, would allow the right format to be matched to the right audience.

## Recommendations for Future Runs

1.  **Extend the lead time.** A minimum of eight weeks from “green light” to delivery, with a review checkpoint at four
    weeks. This allows time for feedback cycles, scope reduction, and helper briefing.

2.  **Distribute authorship and review.** No single person should be solely responsible for creating, reviewing, and
    delivering workshop materials. Even light-touch review from one or two colleagues would have caught scope creep
    early.

3.  **Screen participants by level before registration confirms.** Add a short (3–5 question) skills survey to the
    registration process. Use responses to identify Group 0 participants and redirect them to prerequisite material
    before the workshop, rather than discovering the mismatch on the day.

4.  **Set participant expectations explicitly.** The pre-workshop email should state clearly: the session runs at group
    pace; individual support comes from circulating helpers; participants who are significantly behind a section should
    raise a hand for one-on-one help and may need to return to the materials asynchronously.

5.  **Prepare a live-session link sheet.** Before the session, prepare a HackMD (or equivalent) document with the
    session URL, section links, key commands, and a place to paste output. Walk every participant through opening it in
    the first five minutes.

6.  **Prepare a one-page helper briefing.** Separate from MAINTAINER.md; short enough to read in ten minutes; covers
    session structure, common issues, and escalation paths.

7.  **Scope the materials to one audience level.** Choose Group 1 (HPC beginners with terminal fluency) as the primary
    audience and design the core path entirely for them. Stretch goals can serve Group 2. Group 0 should be redirected
    to a prerequisite session.

8.  **Reduce Section 4 and Section 5 scope.** Both sections are currently overloaded. Section 4 should have a single
    mandatory route with everything else clearly labelled as take-home reference. Section 5 should have at most two core
    exercises with the remainder as post-workshop extensions.

9.  **Plan for multiple formats.** Commission a short skills survey to understand demand for office-hours, hackathon,
    and advanced sessions alongside the standard workshop. The audience exists; the format may need to be matched more
    carefully to their needs.

10. **Establish a documentation feedback loop.** Work towards a formal agreement on how workshop-developed content can
    flow back into the official documentation, reducing duplication and ensuring improvements are preserved.
