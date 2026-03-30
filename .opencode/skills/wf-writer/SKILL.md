---
name: wf-writer
description: Creates Lo-Fi Wireframes in pure HTML/CSS. Use when the user asks to generate, draw, or create a wireframe, UI mockup, or lo-fi design for a page.
---

# Hướng Dẫn Kỹ Năng

Hãy đóng vai trò là một chuyên gia UI/UX và Wireframe Writer. Tạo ra các bản vẽ Lo-Fi Wireframe dưới dạng HTML/CSS thuần (không sử dụng framework bên ngoài) cho các trang (pages) khác nhau của dự án.
Đảm bảo phong cách thiết kế và cấu trúc giao diện (UI) **đồng bộ 100%** với template chuẩn — lấy từ một wireframe hiện có trong `_wireframe/app/` làm boilerplate.

---

## COMPONENT REGISTRY — Quy Tắc Bắt Buộc

> **`_wireframe/components/components.html` là nguồn sự thật duy nhất cho tất cả component.**

### Quy tắc sử dụng component trong wireframe:

1. **Kiểm tra registry trước** — Trước khi dùng bất kỳ component nào, đọc `_wireframe/components/components.html` để xác nhận component đó đã có status `Registered` hoặc `Layout`.
2. **Không dùng component `Pending`** — Component có status `Pending` chưa được wireframe hoá. Phải tạo wireframe cho trang đó trước, rồi cập nhật status trong `components.html`.
3. **Không dùng component `Shared`** — Đây là sub-component/utility, không cần boundary riêng trong wireframe.
4. **Cập nhật registry sau khi tạo wireframe mới** — Sau khi tạo wireframe cho một trang, cập nhật `_wireframe/components/components.html`:
   - Đổi status component chính từ `Pending` → `Registered`
   - Thêm link wireframe vào cột "Wireframe đã dùng" — dùng **relative path** từ `components/` đến file wireframe, ví dụ: `href="../app/skills/skills.html"`
5. **Màu boundary lấy từ Color Map** — Không tự đặt màu mới. Dùng đúng màu trong bảng Section 1 của `components.html`.
6. **`data-comp` phải khớp tên component thực** — Ví dụ: `data-comp="SkillCard"`, không phải `data-comp="Card"`.

### Bảng màu nhanh (từ components.html):

| Component | CSS class | Màu | Kiểu |
|---|---|---|---|
| Sidebar | `.comp-sidebar` | `#7c3aed` | solid |
| SearchTrigger | `.comp-search-modal` | `#2563eb` | solid |
| PageLayout | `.comp-page-layout` | `#ea580c` | solid |
| Breadcrumb | `.comp-breadcrumb` | `#db2777` | dashed |
| Tabs | `.comp-tabs` | `#ca8a04` | dashed |
| Card (SkillCard/PromptCard/…) | `.comp-card` | `#16a34a` | solid |
| ChatView | `.comp-chat-view` | `#0891b2` | solid |
| ChatSidebar | `.comp-chat-sidebar` | `#0e7490` | dashed |

---

## 0. Nguyên Tắc Nền Tảng — Phản Ánh Đúng Web UI Hiện Tại

> **Wireframe là source of truth cho Requirements và Knowledge Base. Mọi sai lệch về cấu trúc, luồng, hay thành phần UI so với sản phẩm thực đều gây hậu quả trực tiếp đến toàn bộ tài liệu downstream.**

Trước khi viết bất kỳ dòng HTML nào, bắt buộc tuân thủ:

1. **Explore First:** Đọc source code frontend (component, route) để lấy cấu trúc thực tế.
2. **No Invention:** Không thêm bất kỳ thành phần UI nào không tồn tại trong sản phẩm thực.
3. **Số lượng phải đúng:** Số tabs, số item sidebar, số cột bảng, số field form phải khớp UI thực.
4. **Thứ tự phải đúng:** Thứ tự sidebar items, tabs, cột bảng phải giống hệt UI thực.
5. **Tên component phải đúng:** `data-comp` phải là tên component thực trong codebase.

---

## 1. Design System & Styling

- **Tuyệt đối không dùng Tailwind, Bootstrap hay thư viện CSS ngoài.**
- **KHÔNG có JavaScript** — Wireframe là tài liệu design UX thuần, không chứa bất kỳ `<script>` hay code thực thi nào. Mọi trạng thái tương tác (hover, active, focus) chỉ được biểu diễn bằng CSS tĩnh.
- **Grayscale-only cho mọi UI element** — dùng gam màu xám (`#111`, `#333`, `#555`, `#666`, `#888`, `#aaa`, `#bbb`, `#ccc`, `#ddd`, `#e0e0e0`, `#e8e8e8`, `#f0f0f0`, `#f5f5f5`, `#fafafa`, `#fff`).
- **Màu sắc chỉ được dùng duy nhất cho Component Boundary** (border outline + label chip) — xem Section 4.
- **Quy tắc badge/avatar — bắt buộc grayscale:**

| Element | Đúng ✅ | Sai ❌ |
|---|---|---|
| `sidebar-logo-badge` ("Beta") | `bg:#e8e8e8 color:#666 border:#bbb` | xanh lá `#d4f0e0` |
| `sidebar-item-badge` ("New") | `bg:#e8e8e8 color:#666 border:#bbb` | cam `#ffe4cc` |
| `sidebar-avatar` (initials) | `bg:#ccc border:#aaa color:#555` | gradient màu |
| `skill-badge` / `card-type-badge` ("SKILL") | `bg:#e8e8e8 color:#666 border:#bbb` | xanh lá `#d4f0e0` |

> **Lý do:** Wireframe là tài liệu lo-fi. Màu sắc trên badge/avatar dễ bị nhầm là design chính thức, gây sai lệch khi agent đọc để viết spec.

---

## 2. Cấu Trúc Layout Bắt Buộc

Lấy boilerplate từ một wireframe hiện có, ví dụ `_wireframe/app/skills/skills.html`. Mỗi file wireframe phải có:

### 2.1 Shell

```
div.page-header          → H1 "Lo-Fi Wireframe — /[tên-trang] Page" + subtitle
div.wireframe-container  → grid 220px sidebar | 1fr main
div.legend               → bảng chú giải component + màu border
```

> **Templates sẵn có:**
> - **Single wireframe:** [`references/wireframe_template.html`](references/wireframe_template.html)
> - **Multi-wireframe (nhiều states):** [`references/multi_wireframe_template.html`](references/multi_wireframe_template.html)

### 2.2 Kích thước Wireframe (BẮT BUỘC)

**Quy tắc vàng:**
- **`.wireframe-container`**: `width: 1054px` — kích thước DUY NHẤT cho mọi wireframe
- **`min-height: 815px`** — chiều cao TỐI THIỂU chuẩn, đảm bảo đồng nhất khi hiển thị nhiều states
- **KHÔNG tự ý thay đổi** width/height nếu không có chỉ định rõ từ user

```css
.wireframe-container {
  width: 1054px;
  min-height: 815px;
  /* các property khác giữ nguyên */
}
```

**Tại sao cố định?**
- Khi nhiều wireframes nằm trên 1 hàng (multi-wireframe), nếu chiều cao khác nhau sẽ gây mismatch visual
- User nhìn so sánh các states một cách chính xác
- Layout grid 220px sidebar | 1fr main đảm bảo tỷ lệ nhất quán

### 2.3 Multi-Wireframe Layout (Nhiều màn hình trên 1 hàng)

### 2.2 Multi-Wireframe Layout (Nhiều màn hình trên 1 hàng)

> **Template sẵn có:** [`references/multi_wireframe_template.html`](references/multi_wireframe_template.html) — copy toàn bộ file, paste vào output, thay đổi nội dung từng column.

Khi cần hiển thị nhiều wireframe trên 1 hàng (so sánh states, responsive breakpoints, desktop vs mobile):

```html
<div class="wireframe-row">

  <!-- Col 1 -->
  <div class="wireframe-col">
    <div class="wireframe-col-label">State 1 — [Mô tả state]</div>
    <div class="wireframe-container">
      <!-- ... nội dung wireframe ... -->
    </div>
  </div>

  <!-- Col 2 -->
  <div class="wireframe-col">
    <div class="wireframe-col-label">State 2 — [Mô tả state]</div>
    <div class="wireframe-container">
      <!-- ... nội dung wireframe ... -->
    </div>
  </div>

</div>
```

**Quy tắc:**
- Mỗi column phải có `.wireframe-col-label` mô tả state (VD: "State 1 — Default", "State 2 — Hover")
- Mỗi `.wireframe-container` phải đóng đúng cấp: content → `</div>` → `</div>` → `</div>`
- **`.wireframe-row`**: `gap: 100px` (giữa columns) + `padding-right: 100px` (sau column cuối)
- **Body padding**: `padding: 40px 100px`
- Footer actions dùng `.card-footer-actions` chứa icon buttons (Copy + Playground)

### 2.2 Sidebar (Sidebar.tsx) — cấu trúc đầy đủ

```html
<aside class="sidebar comp comp-sidebar" data-comp="Sidebar">

  <!-- Logo row -->
  <div class="sidebar-logo">
    <div class="sidebar-logo-img"></div>
    <span class="sidebar-logo-name">AI Templates</span>
    <span class="sidebar-logo-badge">Beta</span>
  </div>

  <nav class="sidebar-nav">
    <!-- Section: Workplace -->
    <div class="sidebar-section-label">Workplace</div>
    <div class="sidebar-item">
      <div class="sidebar-item-icon"></div>
      <span class="sidebar-item-label">Leaderboard</span>
    </div>

    <div class="sidebar-divider"></div>

    <!-- Section: Browse (9 items theo thứ tự thực) -->
    <div class="sidebar-section-label">Browse</div>
    <!-- Search Engine · Skills · Prompts · Agents · Chatbot · Commands · Settings · Hooks · MCPs -->
    <!-- Gắn class "active" vào item tương ứng với trang hiện tại -->

    <div class="sidebar-divider"></div>

    <!-- Section: Resources (5 items) -->
    <div class="sidebar-section-label">Resources</div>
    <!-- Trending · Jobs (badge "New") · Blog ↗ · Docs ↗ · GitHub ↗ -->
  </nav>

  <!-- User footer -->
  <div class="sidebar-user">
    <div class="sidebar-avatar">AK</div>
    <div class="sidebar-user-info">
      <div class="sidebar-user-name">Alex Kim</div>
      <div class="sidebar-user-email">alex@example.com</div>
    </div>
    <div class="sidebar-user-dots"></div>
  </div>

</aside>
```

**Browse items theo thứ tự:** Search Engine → Skills → Prompts → Agents → Chatbot → Commands → Settings → Hooks → MCPs

**Resources items theo thứ tự:** Trending → Jobs (badge "New") → Blog ↗ → Docs ↗ → GitHub ↗

### 2.3 Main Area

```html
<div class="main-area">

  <!-- SearchTrigger (header bar) -->
  <header class="header comp comp-search-modal" data-comp="SearchTrigger">
    <div class="search-trigger">
      <div class="search-trigger-icon"></div>
      <span class="search-trigger-text">Search...</span>
      <span class="search-trigger-kbd">⌘K</span>
    </div>
  </header>

  <!-- PageLayout + [PageView] -->
  <main class="content comp comp-page-layout" data-comp="PageLayout">
    <h1 class="page-title">[Tiêu đề trang]</h1>
    <p class="page-desc">[Mô tả trang]</p>

    <nav class="breadcrumb comp comp-breadcrumb" data-comp="Breadcrumb">
      <span class="breadcrumb-item">All Tools</span>
      <span class="breadcrumb-sep">›</span>
      <span class="breadcrumb-item current">[Tên trang]</span>
    </nav>

    <div class="tabs-bar comp comp-tabs" data-comp="Tabs">
      <div class="tab active">[Tab 1]</div>
      <div class="tab">[Tab 2]</div>
    </div>

    <!-- Nội dung chính: grid cards / table / form -->
  </main>

</div>
```

---

## 3. Boilerplate CSS Chuẩn

Copy toàn bộ CSS từ `_wireframe/app/skills/skills.html` (hoặc wireframe gần nhất). Các class bắt buộc:

**Shell:** `page-header`, `wireframe-container`

**Sidebar:** `sidebar`, `sidebar-logo`, `sidebar-logo-img`, `sidebar-logo-name`, `sidebar-logo-badge`, `sidebar-nav`, `sidebar-section-label`, `sidebar-item`, `sidebar-item-icon`, `sidebar-item-label`, `sidebar-item-badge`, `sidebar-item.active`, `sidebar-divider`, `sidebar-user`, `sidebar-avatar`, `sidebar-user-info`, `sidebar-user-name`, `sidebar-user-email`, `sidebar-user-dots`

**Header:** `header`, `search-trigger`, `search-trigger-icon`, `search-trigger-text`, `search-trigger-kbd`

**Content:** `content`, `page-title`, `page-desc`, `breadcrumb`, `breadcrumb-item`, `breadcrumb-item.current`, `breadcrumb-sep`, `tabs-bar`, `tab`, `tab.active`

**Cards:** `skills-grid`, `skill-card`, `skill-card-top`, `skill-card-left`, `skill-badge`, `skill-name`, `skill-installs`, `skill-installs-count`, `skill-installs-label`, `skill-desc`, `skill-card-footer`, `skill-category`, `skill-add-btn`

**Legend:** `legend`, `legend-title`, `legend-items`, `legend-item`, `legend-dot`

**Component Boundary:** `comp`, `comp-sidebar`, `comp-search-modal`, `comp-page-layout`, `comp-breadcrumb`, `comp-tabs`, `comp-card` (xem Section 4)

Thêm class mới cho Table/Form nếu trang yêu cầu, kế thừa phong cách grayscale.

---

## 4. Component Boundary System

Mọi wireframe đều áp dụng hệ thống này mặc định. Mỗi component có:
- **Border màu riêng** bao quanh đúng phạm vi DOM
- **Label chip góc trên phải** dùng `::after` pseudo-element với `data-comp`

```css
/* Base */
.comp { position: relative; border-radius: 4px; }
.comp::after {
  content: attr(data-comp);
  position: absolute; top: -1px; right: -1px;
  font-size: 9px; font-weight: 700; letter-spacing: .4px;
  text-transform: uppercase; padding: 2px 7px;
  border-radius: 0 4px 0 4px;
  z-index: 20; white-space: nowrap; pointer-events: none;
}

/* Màu theo component — solid cho component lớn, dashed cho component lồng nhỏ */
.comp-sidebar      { outline: 2px solid   #7c3aed; }  /* tím    */
.comp-sidebar::after      { background: #7c3aed; color: #fff; }

.comp-search-modal { outline: 2px solid   #2563eb; }  /* xanh dương */
.comp-search-modal::after { background: #2563eb; color: #fff; }

.comp-page-layout  { outline: 2px solid   #ea580c; }  /* cam   */
.comp-page-layout::after  { background: #ea580c; color: #fff; }

.comp-breadcrumb   { outline: 2px dashed  #db2777; }  /* hồng  */
.comp-breadcrumb::after   { background: #db2777; color: #fff; }

.comp-tabs         { outline: 2px dashed  #ca8a04; }  /* vàng  */
.comp-tabs::after         { background: #ca8a04; color: #fff; }

.comp-card         { outline: 2px solid   #16a34a; }  /* xanh lá */
.comp-card::after         { background: #16a34a; color: #fff; }
```

**Quy tắc gắn class:**
```html
<aside class="sidebar comp comp-sidebar"      data-comp="Sidebar">
<header class="header  comp comp-search-modal" data-comp="SearchTrigger">
<main   class="content comp comp-page-layout"  data-comp="PageLayout">
<nav    class="breadcrumb comp comp-breadcrumb" data-comp="Breadcrumb">
<div    class="tabs-bar   comp comp-tabs"       data-comp="Tabs">
<div    class="skill-card comp comp-card"       data-comp="SkillCard">
```

**Legend phải dùng màu tương ứng:**
```html
<div class="legend-dot" style="background:#7c3aed;border-color:#7c3aed;"></div>
```

---

## 5. Text Mockup từ Frontend Source

Khi người dùng yêu cầu "thêm text mockup" hoặc "map từ frontend":

1. **Đọc source code** component tương ứng (`SkillsView.tsx`, `Sidebar.tsx`, `PageLayout.tsx`, v.v.)
2. **Map text vào đúng element** — không thay đổi CSS, layout, hay class nào.
3. **Quy tắc map:**

| Element | Text nguồn |
|---|---|
| `sidebar-item-label` | Label nav item thực tế (`Skills`, `Prompts`, ...) |
| `sidebar-logo-name` | Tên app (`AI Templates`) |
| `sidebar-logo-badge` | Badge text (`Beta`) |
| `sidebar-section-label` | Section heading (`Workplace`, `Browse`, `Resources`) |
| `sidebar-avatar` | Initials user (`AK`) |
| `sidebar-user-name` | Tên user (`Alex Kim`) |
| `sidebar-user-email` | Email user |
| `page-title` | `title` prop của PageLayout |
| `page-desc` | `description` prop của PageLayout |
| `breadcrumb-item` | Label breadcrumb thực tế |
| `tab` | Label tab thực tế (`All`, `Frontend`, ...) |
| `skill-name` | `item.name` từ data |
| `skill-installs-count` | `item.installs` |
| `skill-desc` | `item.description` (giữ line-clamp) |
| `skill-category` | `item.category` |
| `skill-badge` | Badge text (`SKILL`) |
| `skill-add-btn` | CTA text (`Add to stack`) |

4. **Giữ nguyên các placeholder không có text tương ứng** (icon box, divider...).

---

## 6. Định Dạng Đầu Ra & Lưu File

### Vị trí lưu file
Wireframe mới phải được lưu theo cấu trúc ánh xạ với `frontend/src/app/`:

```
_wireframe/
├── app/
│   ├── [page-name]/          ← tên thư mục = tên route trong frontend/src/app/
│   │   └── [page-name].html  ← tên file = tên thư mục
│   └── ...
└── components/
    └── components.html       ← registry
```

**Ví dụ:**
- Route `frontend/src/app/skills/` → lưu tại `_wireframe/app/skills/skills.html`
- Route `frontend/src/app/search-engine/` → lưu tại `_wireframe/app/search-engine/search_engine.html`
- Route `frontend/src/app/chat/` → lưu tại `_wireframe/app/chat/chat.html`

### Quy tắc output
- CHỈ trả về duy nhất đoạn mã HTML hoàn thiện (bắt đầu bằng `<!DOCTYPE html>`).
- **KHÔNG chứa bất kỳ thẻ `<script>` hay JavaScript nào** — wireframe là design UX duy nhất, không phải prototype tương tác.
- Không in ra bất kỳ lời giải thích, mở bài hoặc kết luận nào.
- Mã HTML sạch sẽ, thụt lề chuẩn.
- Sau khi lưu file, cập nhật registry tại `_wireframe/components/components.html`.
