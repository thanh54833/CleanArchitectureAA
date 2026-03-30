---
name: convert-to-html
description: Convert any URL to a standalone HTML file in _stores directory
---

# convert-to-html

Convert any webpage URL into a **fully standalone HTML file** saved to `/Users/phamthanh/Desktop/resources/dev_hub/_stores/` directory with ALL external assets (CSS, JS, images, icons, fonts) downloaded locally.

## How to Use

When user requests to convert/clone a URL to HTML:

```
/convert-to-html https://example.com
```

Or simply:

```
convert to html https://example.com
```

## Critical Requirement: 100% Standalone

The converted HTML MUST work completely offline. This means:

- **ALL** external CSS, JS, fonts, images, icons must be downloaded
- HTML must be updated to reference local assets
- No broken images, missing styles, or failed scripts

## Workflow (One-Shot)

### Step 1: Fetch HTML

Use `webfetch` tool to get the HTML content:

```
webfetch(url="https://example.com/page/", format="html")
```

### Step 2: Create Assets Directory

Create a subdirectory for all external assets:

```
mkdir -p "_stores/[slug]_assets"
```

Filename slug: extract from URL (e.g., `https://aidevhub.io/tool-approval-matrix-compiler/` → `tool-approval-matrix-compiler`)

### Step 3: Identify External Resources

Parse the HTML to find ALL external resources:

- CSS files (look for `<link rel="stylesheet"` and `href` ending in `.css`)
- JS files (look for `<script` tags with `src` ending in `.js`)
- Images (look for `src` or `href` ending in `.png`, `.jpg`, `.svg`, `.ico`, `.webp`, `.gif`)
- Fonts (look for `url()` in CSS or `@font-face`)
- Icons (look for `apple-touch-icon`, `favicon`, `manifest`)
- Web manifests (`.webmanifest`, `site.webmanifest`)

Common patterns to search for:
- `href="` or `src="` pointing to external domains
- `url(` in inline styles or CSS
- `/favicon`, `/apple-touch-icon`, `/og-`, `/_astro/`

### Step 4: Download All Assets

Use `bash` with `curl` to download all assets in PARALLEL:

```bash
cd "_stores/[slug]_assets"

# Download all identified resources
curl -sL "https://origin.com/path/file.css" -o "file.css"
curl -sL "https://origin.com/path/file.js" -o "file.js"
curl -sL "https://origin.com/path/image.png" -o "image.png"
# ... continue for all resources
```

**IMPORTANT**: Download ALL assets immediately after creating the directory. Do not skip any.

### Step 5: Update HTML References

Update the HTML to use local asset paths:

**Before (external):**
```html
<link rel="stylesheet" href="https://origin.com/_astro/index.css">
<img src="https://origin.com/og-image.png">
<link rel="icon" href="/favicon.ico">
```

**After (local):**
```html
<link rel="stylesheet" href="[slug]_assets/index.css">
<img src="[slug]_assets/og-image.png">
<link rel="icon" href="[slug]_assets/favicon.ico">
```

Apply this transformation for:
- `href="https://` → `href="[slug]_assets/`
- `src="https://` → `src="[slug]_assets/`
- `url(https://` → `url([slug]_assets/`

### Step 6: Save HTML

Write the updated HTML to:
```
/Users/phamthanh/Desktop/resources/dev_hub/_stores/[slug].html
```

### Step 7: Verify

Run `ls -la` to confirm:
- `[slug].html` exists
- `[slug]_assets/` directory exists with all downloaded files

## Example

User: `convert https://aidevhub.io/tool-approval-matrix-compiler/ to html in _stores`

### Execution:

```bash
# 1. Fetch HTML
webfetch(url="https://aidevhub.io/tool-approval-matrix-compiler/", format="html")

# 2. Create assets directory
mkdir -p "_stores/tool-approval-matrix-compiler_assets"

# 3. Download all assets
cd "_stores/tool-approval-matrix-compiler_assets"
curl -sL "https://aidevhub.io/_astro/index.7sQw0z69.css" -o "index.7sQw0z69.css"
curl -sL "https://aidevhub.io/_astro/SearchBar.CttUgEdg.js" -o "SearchBar.CttUgEdg.js"
curl -sL "https://aidevhub.io/_astro/ToolApprovalMatrixCompiler.CV6ntsg1.js" -o "ToolApprovalMatrixCompiler.CV6ntsg1.js"
curl -sL "https://aidevhub.io/_astro/client.0jk3GtEx.js" -o "client.0jk3GtEx.js"
curl -sL "https://aidevhub.io/og-tool-approval-matrix-compiler.png" -o "og-tool-approval-matrix-compiler.png"
curl -sL "https://aidevhub.io/apple-touch-icon.png" -o "apple-touch-icon.png"
curl -sL "https://aidevhub.io/favicon.svg" -o "favicon.svg"
curl -sL "https://aidevhub.io/favicon.ico" -o "favicon.ico"
# ... download all other assets

# 4. Update HTML references (replace external URLs with local paths)
# 5. Write HTML to _stores/tool-approval-matrix-compiler.html
```

### Verification:

```bash
ls -la _stores/tool-approval-matrix-compiler.html
ls -la _stores/tool-approval-matrix-compiler_assets/
```

## Output Format

Always confirm:
- File path where saved
- Total size (HTML + assets)
- List of downloaded assets
- Brief description of what was converted

## Common Asset Patterns

| Asset Type | Look For | Download |
|------------|----------|----------|
| CSS | `<link href="*.css">` | Yes |
| JS | `<script src="*.js">` | Yes |
| Images | `<img src="*.{png,jpg,svg,gif,webp}">` | Yes |
| Favicons | `href="*favicon*"` | Yes |
| Apple Touch | `href="*apple-touch*"` | Yes |
| OG Images | `content="*og-*.png"` | Yes |
| Fonts | `url(*.{woff2,woff,ttf,eot})` | Yes |
| Web Manifest | `href="*.webmanifest"` | Yes |

## Checklist (Must Complete)

- [ ] HTML fetched successfully
- [ ] Assets directory created
- [ ] ALL external CSS downloaded
- [ ] ALL external JS downloaded  
- [ ] ALL images downloaded
- [ ] ALL icons (favicon, apple-touch) downloaded
- [ ] HTML references updated to local paths
- [ ] HTML saved to correct location
- [ ] Verification confirms all files exist
