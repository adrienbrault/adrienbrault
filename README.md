# Adrien Brault

Self-hosting a home lab and running large models on small GPUs — 2× RTX 5090 and 4× passively-cooled CMP 170HX — with measured numbers in every recipe. PHP/Symfony by trade, TypeScript and Python for the rest.

[Blog](https://adrien.brage.fr) · [X](https://twitter.com/AdrienBrault)

## Selected projects

### Local LLM inference

Recipes, patches and dated throughput measurements for serving large models on consumer hardware.

- **[qwen3.8-27b-rtx5090](https://github.com/adrienbrault/qwen3.8-27b-rtx5090)** — Qwen3.8-27B on 2× RTX 5090: 1.49M KV, NVFP4 + vLLM + MTP. 264 t/s at one stream, 2,649 t/s at sixteen.
- **[qwen3.8-flash-next-2x-rtx5090](https://github.com/adrienbrault/qwen3.8-flash-next-2x-rtx5090)** — 262k context on 2× RTX 5090, ExLlamaV3 + TabbyAPI, 8-bit KV pool, MTP + prompt lookup.
- **[glm5.3-flash-2x-rtx5090](https://github.com/adrienbrault/glm5.3-flash-2x-rtx5090)** — 321B MoE on 2× RTX 5090 with CPU-offloaded experts and runtime hot-expert swaps.
- **[deepseek-v4.1-flash-4x-cmp170hx](https://github.com/adrienbrault/deepseek-v4.1-flash-4x-cmp170hx)** — DeepSeek V4.1 Flash at TP4 on 4× CMP 170HX, vLLM recipe and measurements.

### LLM tooling

- **[hf-gguf-to-ollama](https://github.com/adrienbrault/hf-gguf-to-ollama)** — Dagger functions to import Hugging Face GGUF models into a local Ollama, and optionally publish them to ollama.com.
- **[json-schema-to-gbnf](https://github.com/adrienbrault/json-schema-to-gbnf)** — Convert JSON Schema to GBNF grammars for constrained decoding with llama.cpp.
- **[instructrice](https://github.com/adrienbrault/instructrice)** — Typed LLM outputs in PHP: GPT, Claude, Gemini or any OpenAI-compatible provider.
- **[hermes2pro-proxy](https://github.com/adrienbrault/hermes2pro-proxy)** — Hermes-2-Pro function calling behind an OpenAI-compatible API.

### Home Assistant and hardware

- **[geekmagic-hacs](https://github.com/adrienbrault/geekmagic-hacs)** — Home Assistant integration for GeekMagic displays (SmallTV Pro/Ultra): server-side rendering, no device flashing.
- **[ha-jsx-strategy](https://github.com/adrienbrault/ha-jsx-strategy)** — Dynamic Home Assistant dashboards written in JSX/TSX.
- **[cmp-170hx-duct](https://github.com/adrienbrault/cmp-170hx-duct)** — Parametric 3D-printable fan ducts for passively cooled CMP 170HX cards, validated with OpenFOAM CFD.

### Play

- **[salvo](https://github.com/adrienbrault/salvo)** — Browser shoot'em-up roguelike à la Balatro; fully procedural assets, three.js WebGPU.
- **[dokuel](https://github.com/adrienbrault/dokuel)** — Real-time 1v1 sudoku duels, peer-to-peer, no account needed.
- **[blitz-py](https://github.com/adrienbrault/blitz-py)** — Render HTML/CSS to images from Python, no browser required (Stylo + Taffy + Parley + Vello).
- **[carotte](https://github.com/adrienbrault/carotte)** — Symfony + Ollama/OpenAI + Turbo + Mercure playground.

### From the archives

2011–2019 PHP and Symfony work: [hhvm-vagrant](https://github.com/adrienbrault/hhvm-vagrant), [symfony-hateoas-sandbox](https://github.com/adrienbrault/symfony-hateoas-sandbox), [itunes-client](https://github.com/adrienbrault/itunes-client), [boardee](https://github.com/adrienbrault/boardee).

## Recently updated repositories

Regenerated daily by [a scheduled workflow](.github/workflows/update-recent.yml); the list below is non-fork repositories ordered by last push.

<!-- RECENT:START -->

| Repository | Description | Updated |
| --- | --- | --- |
| [pi-ui](https://github.com/adrienbrault/pi-ui) | — | 2026-11-24 |
| [qwen3.8-27b-rtx5090](https://github.com/adrienbrault/qwen3.8-27b-rtx5090) | Qwen3.8-27B on 2× RTX 5090 · 1.49M KV · code/prose t/s: c1 264/216, c16 2,649/2,240 · NVFP4 + vLLM + MTP | 2026-11-24 |
| [inkling-2-mini-2x-rtx5090](https://github.com/adrienbrault/inkling-2-mini-2x-rtx5090) | — | 2026-11-24 |
| [deepseek-v4.1-flash-4x-cmp170hx](https://github.com/adrienbrault/deepseek-v4.1-flash-4x-cmp170hx) | DeepSeek V4.1 Flash on 4× NVIDIA CMP 170HX (TP4, vLLM): recipe, patches and measured numbers | 2026-11-23 |
| [geekmagic-hacs](https://github.com/adrienbrault/geekmagic-hacs) | Home Assistant integration for GeekMagic displays (SmallTV Pro/Ultra). Server-side rendering, no device flash… | 2026-11-23 |
| [blitz-py](https://github.com/adrienbrault/blitz-py) | Render HTML/CSS to images from Python — no browser required. Powered by Blitz (Stylo + Taffy + Parley + Vello… | 2026-11-17 |
| [qwen3.8-flash-next-2x-rtx5090](https://github.com/adrienbrault/qwen3.8-flash-next-2x-rtx5090) | Qwen3.8-Flash-Next (turboderp's 2.68bpw EXL3) on 2× RTX 5090, ExLlamaV3 + TabbyAPI: 262k context, 819k-token … | 2026-11-16 |
| [dokuel](https://github.com/adrienbrault/dokuel) | Real-time 1v1 sudoku duels. Peer-to-peer, no account needed. | 2026-11-09 |
| [cmp-170hx-duct](https://github.com/adrienbrault/cmp-170hx-duct) | 3D-printable, parametric fan ducts for passively cooled NVIDIA CMP 170HX cards: push duct, exhaust collectors… | 2026-11-07 |
| [qwen3.8-flash-next-2x-cmp170hx](https://github.com/adrienbrault/qwen3.8-flash-next-2x-cmp170hx) | — | 2026-10-21 |
| [claude-fix-bash-diffs](https://github.com/adrienbrault/claude-fix-bash-diffs) | Claude Code mod that cuts the file diffs under Bash calls from 40 lines to 8 per file | 2026-10-19 |
| [glm5.3-flash-2x-rtx5090](https://github.com/adrienbrault/glm5.3-flash-2x-rtx5090) | GLM-5.3-Flash (321B MoE, 2.05bpw EXL3) on 2× RTX 5090 + 64 GB DDR5, ExLlamaV3 + TabbyAPI. CPU-offloaded exper… | 2026-10-10 |
| [salvo](https://github.com/adrienbrault/salvo) | A shoot'em-up roguelike à la Balatro, in the browser. Timed score-attack levels, and a shop of relics and equ… | 2026-09-24 |
| [adrien.brage.fr](https://github.com/adrienbrault/adrien.brage.fr) | — | 2026-09-04 |
| [dsphp](https://github.com/adrienbrault/dsphp) | — | 2026-01-28 |

<!-- RECENT:END -->
