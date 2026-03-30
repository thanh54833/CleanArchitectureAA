---
name: docs-writer
description: Generate detailed, accurate technical documentation for your current project by deeply scanning the actual codebase. Use this skill whenever you ask to create/update READMEs, architecture docs, API references, setup guides, or full technical documentation — especially for monorepo projects that have both backend and frontend. The skill will automatically explore file structure, dependencies, tech stack, and code to produce logical, scannable, developer-friendly Markdown docs that perfectly reflect reality (no hallucination). Always follow Diátaxis + Mintlify best practices for structure and readability.
---

# Docs Writer

Your job is to **scan the current monorepo project** (or any project) and generate high-quality, accurate technical documentation that developers will actually read and use.

## Core Principles (tích hợp từ Mintlify + GitBook)
- **Accuracy first**: Chỉ viết dựa trên file/code thật sự tồn tại. Không đoán mò.
- **User journey focused**: Bắt đầu từ onboarding → architecture → chi tiết BE/FE → development → deployment.
- **Diátaxis structure**: Explanation (overview), Tutorials (getting started), How-to guides, Reference (API, config).
- **Scannable & Readable**: Ngắn gọn, nhiều heading (H1-H4), code block, list, table, cross-reference, TOC.
- **Monorepo-friendly**: Tách rõ backend/frontend/shared nhưng vẫn có phần chung để dễ theo dõi.

## Step-by-step Process

### 1. Project Scan (luôn thực hiện trước)
- Sử dụng công cụ có sẵn để explore toàn bộ project:
  - `ls -R` hoặc tree command để lấy full directory structure.
  - Đọc tất cả `package.json` (root + workspaces).
  - Phát hiện monorepo tool (Turborepo, Nx, pnpm-workspace, yarn workspaces, Lerna…).
  - Map rõ:
    - **Backend**: framework, database, ORM, API routes, entry points.
    - **Frontend**: framework (React/Next.js/Vue…), state management, UI library, routing.
    - **Shared**: types, utils, components, configs.
- Đọc thêm: `.env.example`, Dockerfiles, CI/CD files, existing READMEs, tsconfig, eslint, tests.
- Lấy sample code quan trọng để trích dẫn chính xác.

### 2. Xác định scope (hỏi user nếu cần)
- Default: Full documentation suite cho monorepo.
- Có thể focus: chỉ architecture, chỉ API, hoặc update docs hiện có.

### 3. Recommended Output Structure (tạo/update thư mục `docs/`)
Tạo cấu trúc sau (dễ navigate, phù hợp monorepo):

```
docs/
├── index.md                    # Landing page + TOC
├── getting-started.md          # Cài đặt & chạy local
├── architecture.md             # Tổng quan hệ thống + data flow
├── backend/
│   ├── index.md
│   ├── api-reference.md        # Endpoints + examples
│   └── database.md
├── frontend/
│   ├── index.md
│   ├── components.md
│   └── styling-routing.md
├── development.md              # Coding standards, testing, lint, scripts
├── deployment.md               # Deploy + CI/CD
├── contributing.md             # How to contribute
└── CHANGELOG.md                # Lịch sử thay đổi theo version
```

### 4. Writing Guidelines
- **Landing page (`index.md`)**: Tên project, mô tả ngắn, tech stack table, diagram text (Mermaid nếu có), quick links.
- **Mỗi section**: 
  - Bắt đầu bằng mục tiêu rõ ràng (what/why/how).
  - Dùng code block trích trực tiếp từ project.
  - Thêm “Why we chose this” khi rõ ràng từ code.
  - Cross-link giữa BE ↔ FE.
- Giọng văn: imperative, thân thiện, developer-to-developer.
- Luôn thêm Table of Contents và headings rõ ràng để dễ scan.

### 5. Output
- Viết đầy đủ nội dung từng file Markdown.
- Đề xuất ghi trực tiếp vào filesystem (`docs/` hoặc thư mục user chỉ định).
- Kết thúc bằng summary: “Đã scan X files, tạo Y sections, dựa trên tech stack sau…”.

**Lưu ý quan trọng**: Nếu project đã có docs cũ, hãy so sánh và update để giữ tính chính xác thay vì viết lại toàn bộ.

## Changelog
Skill này tuân theo **Semantic Versioning** (MAJOR.MINOR.PATCH).  
Mọi thay đổi quan trọng sẽ được ghi rõ ràng trong phần này.

### [Unreleased]
- (Chưa có thay đổi nào)

### [1.0.0] - 2026-03-25
- **Initial release**: Tạo skill `docs-writer` hoàn chỉnh dựa trên Mintlify + GitBook best practices.
- Hỗ trợ quét monorepo (backend + frontend + shared).
- Cấu trúc docs theo Diátaxis (Explanation, Tutorials, How-to, Reference).
- Thêm `CHANGELOG.md` vào recommended output structure.
- Tích hợp versioning + changelog tự động cho mọi dự án được generate.

### [0.9.0] - Pre-release
- Draft ban đầu (chỉ nội dung core, chưa có changelog).