# Feedback on the Isambard 3 Practical Workshop

This feedback reviews the course materials in this repository against established adult-learning and technical-teaching
principles.

The short version: the course is already strong as a practical adult-learning workshop. It is relevant, hands-on,
problem-centred, and built around authentic HPC tasks rather than abstract exposition. Its main weaknesses are not the
technical examples themselves, but the absence of explicit learning outcomes, assessment checkpoints, reflection prompts,
inclusive alternatives, and a consistent timing story across the repository. Those gaps matter because effective adult
technical teaching should be outcome-aligned, learner-centred, feedback-rich, inclusive, and adaptive. The addition of these other 
elements would help to ensure that the materials used in the workshop follow best practice. 

## Evaluation Framework

The review uses the following adult-learning and technical-teaching principles:

- **Andragogy / adult learning:** adults prefer self-direction, bring prior experience, learn best when the content is
  relevant to immediate roles or problems, prefer problem-centred learning, and are often driven by intrinsic motivation.
- **Constructivism:** learners build understanding actively through doing, exploration, problem-solving, and reflection.
- **Behaviourism:** repeated practice, observable behaviours, and immediate feedback can reinforce core skills.
- **Social learning:** learners benefit from modelling, peer discussion, collaborative work, and seeing how others solve
  the same problem.
- **Experiential and transformative learning:** concrete experiences should be followed by reflection and reframing, not
  only successful task completion.
- **ADDIE and backward design:** lessons should start from learner needs, define outcomes, align activities and
  assessments, implement deliberately, and evaluate using learner feedback.
- **Bloom's Taxonomy:** learning should move from remembering and understanding through applying, analysing, evaluating,
  and creating, with objectives and assessments matched to the intended level.
- **Differentiation:** mixed-ability rooms need core paths, stretch paths, pacing decisions, and targeted support.
- **Project/problem-based learning:** technical activities should be realistic, incremental, and connected to real user
  work.
- **Universal Design for Learning (UDL):** materials should offer multiple ways to access information, engage with tasks,
  and demonstrate progress.
- **Growth mindset and anxiety reduction:** errors should be normalised, challenge should be scaffolded, and feedback
  should focus on strategies, effort, and progress.
- **Metacognition and self-regulation:** learners should pause to assess what they understand, choose next steps, and
  identify gaps.
- **Immediate and incremental feedback:** learners need quick signals that they are on track, not only a final survey.
- **Learner feedback and continuous improvement:** course design should include a plan for gathering, analysing, and
  acting on feedback.

All of the above are based on principles discussed within pedagogy literature generally, and taught through the 
Train the Trainer program (email Liam Berrisford if you are interested in the course material!)

## Overall Judgement

The workshop has a solid andragogical foundation:

- It is anchored in authentic HPC work: logging in, submitting jobs, installing software, running parallel jobs, and
  debugging failures.
- The README identifies a clear adult audience: new, beginner, and intermediate HPC users
  ([README.md](README.md:8)).
- The maintainer notes record actual cohort needs, experience mix, domains, and learning goals
  ([MAINTAINER.md](MAINTAINER.md:28)). This is a strong ADDIE-style analysis step.
- The course explicitly prefers hands-on active sections and a Present -> Demo -> Hands-on -> Discussion rhythm
  ([MAINTAINER.md](MAINTAINER.md:15)).
- Stretch paths are used rather than splitting the room into rigid beginner/advanced tracks
  ([MAINTAINER.md](MAINTAINER.md:13)).
- The debugging section is a particularly good example of problem-centred adult learning: learners pick relevant
  failures, form hypotheses, fix scripts, and verify results.

The main pedagogical risk is that the course depends heavily on the live instructor to supply the learning design. The
repository contains rich technical material, but it does not consistently make the learning objectives, success criteria,
reflection moments, feedback mechanisms, or inclusive alternatives visible to learners. That makes the materials less
robust if delivered by a new presenter or reused asynchronously.

## Highest-Priority Recommendations

1. **Add explicit learner-facing outcomes to every section.** Each section should state what learners will be able to do
   by the end. Use Bloom-level verbs: "submit", "inspect", "diagnose", "choose", "compare", "explain", "adapt". At the
   moment, the schedule names topics but does not consistently define outcomes
   ([README.md](README.md:15)).

E.g. For Section 3 you could have the following as some learner facing outcomes:

```
# Learning Outcomes
By the end of this section, you will be able to:
1. Submit a simple Slurm batch job with `sbatch`.
2. Identify the main parts of a batch script, including `#SBATCH` directives, resource requests, and the shell commands that run on the compute node.
3. Decide when to use a batch job versus a short interactive job, and use `scancel` to cancel a job you submitted by mistake.
```

2. **Add formative checks inside the workshop, not only an end survey.** Formative checks give learners immediate,
   incremental feedback while there is still time to adjust. Add quick checkpoints such as "green/yellow/red",
   one-minute prompts, or output-matching checks after Sections 2, 3, 4, and 5 as a method of ensuring that the learner have gathered what you intended 
   from a given session and are on the right tracks without assessing them yourself. 

3. **Add reflection prompts after each active section.** The materials ask technical questions in places, but they do not
   consistently ask learners to identify what changed in their mental model, what still feels unclear, or how the
   workflow maps to their own research. Adding this would allow the learner to become more indepdent. 

4. **Strengthen UDL and accessibility.** Provide alternative paths for learners who cannot log in, cannot use VS Code,
   process text visually differently, or need lower cognitive load. The current fallback is mostly "follow along on the
   projected screen" ([src/section_01_welcome_login_overview/00-pre-session.markdown](src/section_01_welcome_login_overview/00-pre-session.markdown:166)),
   which is useful but limited. It might be worth considering if there are any other routes that could be used? (E.g. pair program with a colleague?)

5. **Make the Section 4 software path less overloaded.** It currently includes modules, installation routes, clone/fork,
   SSH keys, dotfiles, mamba, conda vocabulary, environment creation, Pixi, and fallback stack material. For adult
   learners, relevance is good; overload is not. Split "must do now" from "reference only" more visibly. I think having one
   route in this case might be worthwhile particuarly if they can all sort of do the same thing and then have the other 
   "Follow-up" stuff as something you introduce at the end. 

6. **Turn learner choice into explicit self-directed learning.** The debugging menu already does this well. Add similar
   choice points in Section 5: "choose arrays if you run many independent samples; choose MPI if tasks communicate;
   choose GNU parallel for one-node command lists".

7. **Consider a JupyterBook-style website structure for navigation and accessibility.** The current website can be
   difficult to navigate because each lesson opens as a slide-style page, and it is not always clear where the learner is
   in the course, how much content remains, or how to move to another lesson without using the browser back button. A
   structure like JupyterBook, as used by CfRR, would give learners a persistent left-hand menu or table of contents
   showing the whole course at once. This would make it easier to see the course structure, move between sections, and
   understand progress through the material. It may also improve accessibility: relying on arrow-key navigation inside
   Reveal.js-style pages is not obvious to learners who have not used that format before, and it may be less accessible
   than conventional page navigation with visible next/previous links and a stable menu.

8. **Add a course feedback plan in the repo.** The course currently says a survey will be emailed after the workshop
   ([src/section_07_tips/README.md](src/section_07_tips/README.md:109)). A good feedback plan should define what you want
   to learn, which methods you will use, when feedback will be collected, whether responses are anonymous, how responses
   will be analysed, and which follow-up actions will be taken. Add a `feedback_plan.md` or a section in `MAINTAINER.md`.

## Course-Wide Strengths

- Practical topics are well matched to learner needs: login, batch jobs, software installation, Python parallelism, and
  debugging.
- The audience analysis in `MAINTAINER.md` is strong and clearly informed the course design.
- The course uses a good active-learning rhythm: Present -> Demo -> Hands-on -> Discussion.
- Core and stretch paths support mixed experience levels without splitting the room too early.
- Exercises are authentic: learners submit jobs, inspect output, alter scripts, and debug real failure modes.
- Section 6 is especially strong because learners choose a relevant debugging problem, form a hypothesis, fix, and
  verify.
- The repository tooling is strong: Pixi tasks, formatting, generated environments, docs build, and Python entry points
  support reproducibility.

## Course-Wide Weaknesses

- Learner-facing outcomes are mostly implicit rather than clearly stated at the start of each section.
- Formative assessment is limited; the course often checks whether commands ran, but less often checks whether learners
  can transfer the idea to their own work.
- Reflection prompts are underused, so some hands-on experiences may not turn into durable learning.
- Peer learning is present informally through helpers and discussion, but it is not designed into the exercises often
  enough.
- UDL/accessibility support could be stronger, especially for login-blocked learners and learners who need lower
  cognitive load.
- Section 4 risks overload because it covers many software concepts and setup routes in a short time.

## Section-by-Section Feedback

### Section 1: Welcome, Login, and System Overview

**Recommended changes**

- Add a learner-facing "By the end of this section..." slide: "You will know the default login route, the editor route,
  and what to do if login fails."
- Add a minimal offline follow-along pack for anyone blocked on login: sample terminal transcript, sample Slurm output,
  and the same observation questions used later.

### Section 2: Login Checkpoint and First Commands

**Recommended changes**

- Add expected output examples for `whoami`, `hostname`, storage variables, and `module list`. E.g. what does your whoami look like and why is their different etc.
- Add a storage mini-scenario: "You have a script, a shared input file, and a temporary output. Choose HOME, PROJECTDIR,
  or SCRATCHDIR for each."

### Section 3: First Batch Job With Slurm

**Recommended changes**

- Add "Common mistakes" boxes: submitting from the wrong directory, missing execute permission if running directly,
  confusing job ID and task ID, reading output before the job completes.
- Add a pair discussion prompt: "Are output lines ordered? Predict first, then inspect."
- Add a Bloom-aligned extension: "Create your own minimal batch script for a command you already use."

### Section 4: Installing Software

**Recommended changes**

- Make one "core route" slide that is the only required path.
- Move fork/SSH-key instructions, dotfiles, Pixi details, Spack, containers, and fallback stack to an appendix or
  clearly labelled take-home section.
- Add a decision tree: "Need Python package? Try conda/mamba. Need compiler? Load `PrgEnv-gnu`. Need complex compiled
  stack? Follow up with Spack/docs. Need deployment portability? Containers later."
- Add a success check: `which python`, `python --version`, import `numpy`, import `numba`, run one workshop entry point, similar to above where you include some example outputs. 
- Add a recovery path for failed environment creation: "If this fails, do not keep retrying; raise a hand and use the
  fallback shared stack."

### Section 5: Python Example, Array Jobs, and Parallelism Strategies

**Recommended changes**

- Generally I think this section is quite heavy on the content and could be quite overwhelming to move between all the different exercises so much. I would
reduce it down to just two, at a push three of the examples. 
- Add a "same problem, different strategies" visual summary.
- Add expected output snippets for the timing table and reduced results.
- Add learner reflection: "Which of your workflows has independent tasks? Which has communication?"
- Make all advanced variants clearly labelled as "post-workshop extension".

### Section 6: Debugging Failed Jobs

**Recommended changes**

- Add a worksheet-style table: "Symptom / Evidence / Hypothesis / Fix / Result" which the students can refer back to, like a little cheat sheet. 
- Add sample `.out` and `.err` snippets so login-blocked or queue-delayed learners can still practise diagnosis.
- Add a peer moment: learners explain their hypothesis to a neighbour before reading hints.
- Add a short "wrong but useful hypotheses" note to reduce anxiety when a first guess is incorrect.

### Section 7: Tips, Help, Wrap-Up, Q&A, and Feedback

**Recommended changes**

- Add a three-question exit ticket:
  1. What is one workflow you can now attempt?
  2. What is still unclear?
  3. What should we change for the next workshop?
- Add a simple self-assessment against the section outcomes.