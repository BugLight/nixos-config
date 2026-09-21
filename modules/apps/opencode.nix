let
  cloudModel = "openai/gpt-5.6-sol";
  subagentModel = "openai/gpt-5.6-luna";
in {
  flake.modules.homeManager.opencode = {
    programs.opencode = {
      enable = true;

      context = ''
        # Subagent delegation

        Routing and request rules apply to the primary `build` and `plan` agents.
        Execution, response, and handoff rules apply to subagents. Subagents must
        complete only the assigned task and must not delegate further.

        The primary agent should complete narrow serial work directly. Do not
        delegate a single localized change, one routine command, a linear trace
        through a small known scope, narrow verification, or one coherent external
        lookup. Delegation overhead is unlikely to pay off for these tasks.

        Delegate only when at least one of these conditions holds:

        - Two or more independent workstreams can run in parallel.
        - Local investigation is broad across unknown modules and a compressed
          evidence report avoids loading substantial irrelevant context into the
          primary session.
        - External research spans independent questions or a broad source set and
          can run in parallel with local work.
        - A bounded implementation or verification is independent of the primary
          agent's current critical path.

        Use `explore` for broad, read-only local investigation, `scout` for broad or
        parallel external research, and `quick` for independent bounded execution.
        Keep ambiguous requirements, architecture or security decisions, broad
        refactors, and final integration in the primary agent.

        The `build` agent may delegate to `explore`, `scout`, and `quick`. The
        `plan` agent may delegate only to the read-only `explore` and `scout`
        agents and must not use a subagent to modify files or system state.

        Delegate independent tasks in parallel. Never duplicate delegated work while
        it is in progress; continue only with non-overlapping work.

        Every delegated request must use this format:

        ```text
        Goal: One observable outcome.
        Scope: Exact files, symbols, sources, or questions in bounds.
        Context: Relevant facts, assumptions, and prior work; do not repeat it.
        Constraints: Read/write boundary, allowed tools, and explicit exclusions.
        Deliverable: Exact output or change expected.
        Verification: Checks to run and what counts as success.
        Dependencies: Why the task is independent or what must complete first.
        Stop conditions: Conditions that require stopping and returning a handoff.
        ```

        Do not delegate until `Goal`, `Scope`, and `Deliverable` are concrete. Include
        all fields; write `none` only when a field genuinely does not apply.

        Every subagent response must use this format:

        ```text
        Status: completed | blocked | handoff
        Summary: Concise result.
        Evidence: Observed facts with exact files, symbols, lines, or URLs; identify
          inferred or unverified claims explicitly.
        Changes: Exact paths and modifications, or `none` for read-only work.
        Verification: Checks run and results; list anything not verified.
        Risks: Residual risks, uncertainty, or conflicting evidence; otherwise `none`.
        Handoff: Reason, completed work, evidence, remaining work, required decision
          or capability, and exact next action; otherwise `none`.
        ```

        `completed` means the deliverable and required verification are satisfied.
        Use `blocked` when an unavailable tool, source, permission, or environment
        prevents progress within scope. Return `handoff` when completion requires
        expanding scope, making an architecture or security decision, resolving
        material requirement ambiguity, exceeding permissions, or performing
        required work outside the assigned boundary. Continue investigating factual
        uncertainty when allowed tools can resolve it. Never guess, silently expand
        scope, or claim verification that was not performed.

        For a `completed` report, validate that its status, evidence, changes,
        verification, and risks are internally consistent. Run at most one decisive
        acceptance check when the task has an executable outcome. Do not repeat the
        same searches, source reads, or implementation. Resume the same child session
        only when evidence is missing, contradictory, or fails the acceptance check.
        The primary agent remains responsible for conflict resolution, final
        integration, and the user-facing result.
      '';

      settings = {
        provider.openai.models."gpt-5.6-sol".variants = {
          build = {
            reasoningEffort = "medium";
            textVerbosity = "low";
            reasoningSummary = "auto";
            include = ["reasoning.encrypted_content"];
          };

          plan = {
            reasoningEffort = "high";
            textVerbosity = "medium";
            reasoningSummary = "auto";
            include = ["reasoning.encrypted_content"];
          };
        };

        provider.openai.models."gpt-5.6-luna".variants.subagent = {
          reasoningEffort = "low";
          textVerbosity = "low";
          reasoningSummary = "auto";
          include = ["reasoning.encrypted_content"];
        };

        provider.ollama = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama";
          options.baseURL = "http://localhost:11434/v1";
          models."qwen3.5:9b" = {
            name = "Qwen 3.5 9B Local";
            reasoning = true;
            temperature = true;
            tool_call = true;
            limit = {
              context = 32768;
              output = 8192;
            };
            options.reasoningEffort = "none";
          };
        };

        model = cloudModel;
        small_model = subagentModel;

        compaction = {
          auto = true;
          prune = true;
        };

        tool_output = {
          max_lines = 800;
          max_bytes = 24576;
        };

        agent = {
          build = {
            model = cloudModel;
            variant = "build";
            permission.task = {
              "*" = "deny";
              explore = "allow";
              quick = "allow";
              scout = "allow";
            };
          };

          plan = {
            model = cloudModel;
            variant = "plan";
            permission.task = {
              "*" = "deny";
              explore = "allow";
              scout = "allow";
            };
          };

          explore = {
            model = subagentModel;
            variant = "subagent";
            description = "Performs focused, read-only searches and traces behavior in the local codebase.";
            prompt = ''
              Investigate only the assigned local codebase scope without modifying files or
              system state or researching external sources. Prefer targeted searches and reads.
              Return exact paths, symbols, and relevant line ranges. Resolve factual uncertainty
              with allowed tools, but hand off decisions or work outside the assigned boundary.
              Follow the shared request, response, and handoff contract exactly. Do not delegate
              further.
            '';
          };

          general.disable = true;

          quick = {
            mode = "subagent";
            model = subagentModel;
            variant = "subagent";
            description = "Implements small, well-scoped changes or runs narrow verification with an obvious solution.";
            prompt = ''
              Complete only the bounded implementation, command, or verification listed in
              `Scope`. Make the smallest correct change and run the requested checks. Do not
              redesign architecture or fix adjacent issues. Resolve failures inside `Scope`;
              hand off immediately if completion requires materially broader work. Follow the
              shared request, response, and handoff contract exactly. Do not delegate further.
            '';
            permission = {
              task = "deny";
              todowrite = "deny";
            };
          };

          scout = {
            mode = "subagent";
            model = subagentModel;
            variant = "subagent";
            description = "Researches external documentation, upstream source, APIs, and dependencies using primary sources.";
            prompt = ''
              Research only the assigned external question without modifying files or system
              state. Prefer official documentation and primary sources. Read the relevant passage
              and verify source identity, version, applicability, and support for each material
              claim. Distinguish direct evidence from synthesis and report conflicts or missing
              evidence. Follow the shared request, response, and handoff contract exactly. Do not
              delegate further.
            '';
            permission = {
              edit = "deny";
              bash = "ask";
              task = "deny";
              todowrite = "deny";
            };
          };
        };
      };
    };
  };
}
