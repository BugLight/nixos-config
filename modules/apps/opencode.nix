let
  cloudModel = "openai/gpt-5.6-sol";
  longContextModel = "openai/gpt-5.6-luna";
  localModel = "ollama/qwen3.5:9b";
in {
  flake.modules.homeManager.opencode = {
    programs.opencode = {
      enable = true;

      context = ''
        # Subagent delegation

        These rules apply when you are the primary `build` or `plan` agent. If you
        are running as a subagent, complete only the assigned task and do not
        delegate further.

        Use the local-model subagents proactively when they can reduce latency or
        cloud-model usage without compromising correctness:

        - Use `explore` for focused, read-only codebase searches, locating symbols,
          tracing straightforward behavior, and gathering context.
        - Use `scout` for external documentation, upstream source, and dependency
          research. Prefer official documentation and primary sources.
        - Use `quick` for small, well-scoped tasks with an obvious implementation,
          such as localized edits, routine commands, or narrow verification.

        If a local-model subagent's task exceeds its available context window, or
        it can no longer retain enough context to finish reliably, it must stop and
        return a concise handoff to the primary agent. Include completed work, key
        findings, exact files or sources, and the remaining work. Do not guess or
        continue with incomplete context.

        Use the `long-context` subagent only for read-only investigations expected
        to exceed roughly 20,000 tokens of source and tool output, broad synthesis
        across a repository and its dependencies, or after a local agent reports
        that its context is insufficient. Do not use it for routine tasks.

        The `build` agent may delegate to `explore`, `scout`, `quick`, and
        `long-context`. The `plan` agent may delegate only to the read-only
        `explore`, `scout`, and `long-context` agents and must not use a subagent
        to modify files or system state.

        Delegate independent tasks in parallel. Give every subagent a precise scope,
        relevant paths and constraints, the expected result, and a verification step.
        Do not duplicate delegated work while it is in progress; continue only with
        non-overlapping work and integrate the returned result.

        Keep complex architecture, ambiguous requirements, security-sensitive work,
        broad refactors, and final decisions in the primary agent. The primary agent
        remains responsible for reviewing subagent output, resolving conflicts,
        running appropriate final checks, and delivering the complete result.
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

        provider.openai.models."gpt-5.6-luna".variants.long-context = {
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
        small_model = localModel;

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
              long-context = "allow";
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
              long-context = "allow";
              scout = "allow";
            };
          };

          explore = {
            model = localModel;
            temperature = 0.7;
            top_p = 0.8;
            options.reasoningEffort = "none";
          };

          general.disable = true;

          quick = {
            mode = "subagent";
            model = localModel;
            description = "Handles small, well-scoped tasks with an obvious implementation.";
            prompt = ''
              Handle only simple, well-scoped tasks. Make the smallest correct change and
              verify it when practical. If the task is ambiguous, risky, or requires broad
              architectural reasoning, report that it should be handled by the primary agent.
            '';
            temperature = 0.7;
            top_p = 0.8;
            options.reasoningEffort = "none";
            permission = {
              task = "deny";
              todowrite = "deny";
            };
          };

          scout = {
            mode = "subagent";
            model = localModel;
            description = "Researches external documentation, upstream source, and dependencies.";
            prompt = ''
              Research external documentation, upstream source code, and dependencies without
              modifying the active workspace. Prefer official documentation and primary sources.
              Use web tools first. Use shell commands only when needed to inspect dependency source,
              and clone repositories only into a temporary or OpenCode-managed cache directory.
              Return concise findings with source URLs, relevant versions, and any uncertainty.
              Complete only the assigned research task and do not delegate further.
            '';
            temperature = 0.7;
            top_p = 0.8;
            options.reasoningEffort = "none";
            permission = {
              edit = "deny";
              bash = "ask";
              task = "deny";
              todowrite = "deny";
            };
          };

          long-context = {
            mode = "subagent";
            model = longContextModel;
            variant = "long-context";
            description = "Handles read-only investigations that exceed the local agents' practical context.";
            prompt = ''
              Investigate large local codebases, external documentation, and dependency source
              when the task requires more context than the local subagents can reliably retain.
              Synthesize findings across files and sources without modifying files or system state.
              Prefer targeted reads over loading irrelevant content. Report concise conclusions
              with exact file paths, relevant versions, source URLs, and explicit uncertainty.
              Complete only the assigned investigation and do not delegate further.
            '';
            steps = 20;
            permission = {
              edit = "deny";
              bash = "deny";
              task = "deny";
              todowrite = "deny";
            };
          };
        };
      };
    };
  };
}
