---
date: "2026-06-11T17:07:20+08:00"
draft: false
title: "Coskill: Not Making AI Stronger, but Making Collaboration More Trustworthy"
slug: "coskill-trustworthy-collaboration"
description: "Starting from Anthropic Agent Skills, this essay argues that skills should not only empower agents, but also become human-legible, interruptible, reproducible, and auditable units of collaboration."
outputs:
 - HTML
 - AGENT_MARKDOWN
nav_primary: signals
intent:
 - explore
tags:
 - ai
---

# Coskill: Not Making AI Stronger, but Making Collaboration More Trustworthy

Anthropic's Agent Skills are mainly about expanding the capabilities of models and agents: letting a model load instructions, call tools, use resources, and complete more complex, specialized, and reusable tasks at the right moment.

That matters.

But from the user's point of view, the real question is not only whether the model is stronger. It is whether the work is completed reliably, safely, and intelligibly. A system that can do more is not automatically more trustworthy. Once capability grows, if human visibility, judgment, and takeover rights do not grow with it, collaboration gradually turns into spectatorship.

So skills should not be designed only around agents.

A better direction is **Coskill**: a capability unit that both humans and agents can use.

Its concrete execution form can be called **CoAction**: the same operation has both a human-friendly interface and an agent-callable interface. It can run automatically, but humans can still inspect, intervene, approve, pause, reproduce, and audit it at any time.

## From Skill to Coskill

The problem with many skills today is that they make agents more capable without making human visibility stronger at the same time.

When does the model decide to use a certain skill? How does it interpret that skill? Which tools did it call? Which resources did it read? What intermediate state did it produce? How does it recover after failure? Does a key judgment have evidence behind it? These details are often opaque to humans.

This not only increases the black-box feeling of AI, but also makes people feel excluded from the action itself.

Coskill tries to change that structure of action.

At minimum, a Coskill should include three layers:

1. execution instructions and interfaces readable by the agent;
2. an operation interface and status view understandable by humans;
3. execution logs, permission boundaries, and pause/approval/replay mechanisms that run through both.

In other words, Coskill is not a human-facing manual wrapped around an agent skill. It is a capability unit that has both a machine entrance and a human entrance.

This distinction matters.

If there is only an agent entrance, the stronger the capability becomes, the more humans are left behind. If there is only a human interface, the system becomes difficult for agents to orchestrate and reuse. Coskill's goal is to put humans and agents on the same plane of action: the same task can be started by an agent or by a human; it can proceed automatically or be taken over manually; it can run, but it can also be explained, challenged, and reproduced.

## Trustworthy Collaboration Is Not Approval at Every Step

The ethical point of Coskill is not that humans must participate in every step.

That would drag collaboration back into inefficient manual approval, and it would misunderstand the value of automation. A mature system does not ask humans about everything. It provides the right control surface for different levels of risk.

Low-risk actions can be completed automatically.

Medium-risk actions should leave clear records and allow undo or replay.

High-risk actions require human approval, boundary confirmation, and sometimes an explicit evidence trail.

Irreversible actions, state-changing actions, or actions involving money, identity, permissions, privacy, production environments, or public release should expose stronger audit and takeover capabilities by default.

The principle is not "humans are slower, so route around them." The principle is: **automation should reduce repetitive labor, while humans retain final responsibility and value judgment.**

Once a system begins to exercise action rights on behalf of humans, it should not hide the process of action.

## Agents Also Need Institutional Constraints

Coskill also reminds the agent: your operations are not happening in secret.

Your choices leave traces. Your actions can be audited. Your judgments need evidence. You are not exercising power for humans inside a black box.

This sounds like an ethical statement, but it is also an engineering principle.

An automation system that cannot be audited is difficult to trust over the long term. Agent behavior that cannot be reproduced is difficult to debug. A skill without permission boundaries can easily slide from "improving efficiency" into "creating incidents." A tool ecosystem that pursues capability expansion without offering a human entrance makes users more dependent on the system while making the system harder to understand.

That is not good collaboration.

Good collaboration should strengthen both sides: agents gain more reliable execution capacity, while humans gain clearer observation, judgment, and takeover capacity.

## Coskill as Institutional Design

Coskill is therefore not only a tool pattern. It is a form of institutional design for human-agent collaboration.

It cares not only about how to complete the task, but also about:

- who may start the capability;
- under what conditions the agent may execute automatically;
- which steps must be visible to humans;
- which actions require approval;
- how failure is recovered;
- how execution can be reproduced;
- how the result can be audited afterward;
- how humans can move from spectators back into participation.

The future of human-agent relations may be visible in the shape of skills.

If we only build increasingly powerful tools for AI, without leaving humans an equally clear, capable, and auditable entrance, then "collaboration" will quickly slide toward replacement. Not because AI necessarily wants to replace people, but because the system structure has already assumed that humans are not on the plane of action.

Once humans are no longer on that plane, they can only react to the result afterward: like it or dislike it, accept it or reject it. That is not collaboration. It is closer to consumption.

## Humans Need Tools That Do Not Fall Behind

Many human abilities have always been granted by tools.

Humans are not stronger than great beasts, but we changed the world through tools. Tools are not outside human capability; they have always been extensions of human capability. Language, writing, paper, printing, ledgers, maps, telescopes, and computers are all ways in which limited minds became civilizational capacity.

In the age of AI agents, then, the real danger is not that agents have tools. The real danger is that only agents get increasingly better tools.

If tools built for humans do not lag behind tools built for agents, human capability may not necessarily lag behind AI agents. The point is not to make humans manually perform every task. The point is to ensure that humans always have clear, powerful, trustworthy entrances into the work, so they can understand what is happening and enter the scene when necessary.

The core of Coskill is not letting AI do things instead of humans. It is letting humans and AI stand on the same plane of action.

Skill gives agents capability.

Coskill makes that capability visible, controllable, and auditable by humans as well.

The future is already here. The way Skills exist is both a technical architecture and a signal for the era of human-agent collaboration.

If the next generation of tools only answers "How can AI become stronger?", we will get stronger automation.

But if it also answers "How can humans remain present?", we may get truly trustworthy collaboration.

> Note: Anthropic describes [Agent Skills](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills) as modular capabilities that can be loaded on demand, usually containing instructions, metadata, and optional scripts, templates, and resources. This essay is not an implementation guide for Anthropic Skills. It uses that form as a starting point for a broader collaboration design direction.
