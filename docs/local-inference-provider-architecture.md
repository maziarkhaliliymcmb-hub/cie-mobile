# Local Inference Provider Architecture v1

## Decision

The iOS app uses a provider-neutral local inference contract. UI and engineering workflows must not depend directly on a specific model SDK.

The first registered provider remains Apple Foundation Models so the existing proof of concept stays buildable. The next provider to evaluate and integrate is Google's LiteRT-LM Swift SDK. The provider contract deliberately allows LiteRT-LM, llama.cpp, or another verified on-device runtime to be added without rewriting the UI or task orchestration.

## Components

- `LocalInferenceRequest`: task type, system instructions, prompt, and input budget.
- `LocalInferenceResponse`: output, provider/model identifiers, and elapsed time.
- `LocalInferenceProvider`: availability and generation contract for one local runtime.
- `LocalInferenceRouter`: explicit provider selection and dispatch. It does not silently fall back to cloud inference.
- `FoundationModelsProvider`: current adapter for Apple's OS-managed on-device model.
- `LocalModelService`: UI-facing coordinator; it knows the router, not a model SDK.

## Initial task taxonomy

- `codeAnalysis`
- `codeGeneration`
- `testDesign`
- `debugging`

Only bounded code analysis is exposed in the current UI. The taxonomy establishes stable task contracts for later capabilities; it does not claim those workflows are implemented.

## Runtime candidate

LiteRT-LM is the preferred next candidate because its official Swift API supports native iOS integration, GPU/Metal execution, streaming, multimodal inputs, and tool use. It supports converted model artifacts, so model compatibility and conversion are part of the evaluation gate. The package must be pinned to a verified release and included in the Xcode target only after an iOS simulator build and physical-device smoke test pass.

Candidate model families include Gemma, Qwen, Llama, and Phi variants where an officially supported LiteRT-LM artifact exists. Do not assume arbitrary GGUF files can be loaded by LiteRT-LM; GGUF is a llama.cpp format and requires a separate provider.

## Security and execution boundary

- Providers registered in this router are local-only.
- No silent cloud fallback.
- Prompt/source text is treated as untrusted data.
- No shell, filesystem, GitHub write, test execution, deployment, or merge tools are granted to the model.
- Inference output is advisory. CI and deterministic tests remain authoritative.
- CIE integration and Compute Node registration remain out of scope for this PR.

## Acceptance gates before adding LiteRT-LM

1. Pin an official LiteRT-LM Swift package release.
2. Select a model artifact with documented iOS compatibility and verify its license.
3. Add model download/storage lifecycle, integrity checks, and explicit user consent.
4. Benchmark first-token latency, tokens/second, peak memory, thermal behavior, context limit, and crash rate on the actual iPhone 16 Pro Max.
5. Add tests for unavailable model, invalid input, cancellation, memory pressure, and provider failure.
6. Keep provider selection explicit; no cloud or alternative-runtime fallback without user consent.

## Non-goals

This PR does not add a persistent background worker, CIE task claiming, Compute Node identity, model download, autonomous repository modification, or on-device compilation of arbitrary projects. Full Xcode builds and simulator/device test execution remain CI/macOS responsibilities.
