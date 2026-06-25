---
date: "2026-06-12T17:56:53+08:00"
draft: false
title: "CoSkill: The Future of Human-Agent Collaboration"
slug: "coskill-trustworthy-collaboration"
description: "Starting from Anthropic Skills, this essay proposes CoSkill: a capability unit that both humans and agents can use."
outputs:
 - HTML
 - AGENT_MARKDOWN
nav_primary: signals
intent:
 - explore
tags:
 - ai
 - tooling
---

# The Future of Human-Agent Collaboration, Seen Through Skills

Give AI/agents a little less room for autonomous improvisation, and give tools and fixed workflows a little more weight. The fate of humans being replaced will feel a little less close to reality.

![CoSkill, the future of human-agent collaboration](coskill-trustworthy-collaboration.png)

## A Subtle Difference

Anthropic's Skills are mainly about [expanding the capabilities of models and agents](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills): [letting a model load instructions and call tools on demand](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview).

That certainly matters. But for human users, the more important question is whether the task is completed predictably and reliably.

For a recurring task, people usually want stable, step-by-step delivery. They do not want the model/agent to invent something new every time.

So unless the task is exploratory or research-oriented, Skills may be the more central layer.

This is a subtle psychological difference between everyday agent users and large-model companies.

## Skills Should Not Only Be AI Add-ons. They Should Also Be a Human Foundation.

Some people mount hundreds of Skills for Codex / Claude Code, yet do not understand the details of how the model uses them.

Skills often operate on concrete objects: modifying a code project, or calling an API to place and pay for an order.

Today, we rarely hear that humans can bypass the agent and directly operate or orchestrate Skills themselves.

Many of our abilities have always been granted by tools.

Humans are not stronger than great beasts, but we changed the world through tools.

If tools built for humans do not lag behind tools built for AI, we may not necessarily lag behind AI either.

## We Cannot Easily Improve Large Models, but We Can Improve Skills

It is hard for us to modify large models. With commercial models, we may not even have bargaining power.

Skills are different. This is an example Skill from the Claude documentation:

```text
pdf-skill/
├── SKILL.md (main instructions)
├── FORMS.md (form-filling guide)
├── REFERENCE.md (detailed API reference)
└── scripts/
    └── fill_form.py (utility script)
```

The `.md` files are text, and the `scripts` directory contains code. Almost anyone can change them.

## Skill Usage Is Valuable Experience

As the digital world and agent ecosystem become more abundant, there will often be more than one path to the same goal.

Some birds weave nests from reeds. Some animals sleep while hanging upside down. The Sumerians wrote records on clay tablets. The Chinese used ceramics to make water jars.

Large-model/agent companies can easily collect which Skills users use and how they use them, then improve their own models.

If we add even a little structure to Skills or agents:

1. record the usage frequency and sequence paths of each capability inside Skills;
2. record the result after each capability is used, whether it succeeds or fails.

Then we can form our own experience assets for the digital world, without binding ourselves to any particular large-model/agent company.

## I Propose the Concept of CoSkill

A capability unit that both humans and agents can use.

It roughly contains:

1. execution instructions and interfaces readable by the agent (Skills);
2. a human-understandable operation interface and status view (App);
3. a shared layer for logs, permissions, and approvals.

At the execution level, each executable operation can also be called a **CoAction**.

A CoAction can be initiated by an agent or by a human. It can run automatically, and it can also be reviewed, approved, or taken over by humans.

This also reminds the agent: your operation is not happening in secret. It will be recorded.

So CoSkill is not only a tool pattern. It is also a design idea for human-agent collaboration.

## Skills WorldTree, the Next Step After CoSkill

When there are more CoSkills, we can consider:

1. a unified UI protocol, so a browser-like tool can display the UI of all CoSkills;
2. aggregating massive numbers of CoSkills, with unified classification, indexing, and orchestration. This interface can center human operation, with agents as assistants, for example to bridge the gaps between Skills.

## A Leaf Reveals Autumn

The future is already here. The way Skills exist can already be seen as a signal for the era of human-agent collaboration.

If we only build increasingly powerful tools for AI, without leaving humans an equally powerful and enterable interface, then so-called collaboration will quickly slide toward replacement.

The question is not whether AI should become stronger.

The question is whether, when AI becomes stronger, humans can still stand on the same plane of action.
