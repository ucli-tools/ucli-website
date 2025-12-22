# UCLI Tools Website

**Marketing site for UCLI Tools - Professional CLI tools for developers**

🌐 **Live:** [ucli.tools](https://ucli.tools)  
🎉 **Status:** Production Ready - v1.0.0 (Dec 2025)

---

## 🚀 Tech Stack

- **[Astro](https://astro.build)** - Ultra-fast static site generator
- **[TailwindCSS v3](https://tailwindcss.com)** - Modern utility-first CSS
- **GitHub Pages** - Free, fast hosting

---

## 🛠️ Development

```bash
# Install dependencies
npm install

# Start dev server (http://localhost:4321)
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

---

## 📦 Deployment

Automatically deploys to GitHub Pages on every push to `main`.

**URLs:**
- **Production:** `https://ucli.tools` (custom domain)
- **GitHub Pages:** `https://ucli-tools.github.io/ucli-website/`

---

## 🌐 DNS Setup

### Automated Setup (Recommended)

Use the included DNS setup script to automatically configure your domain:

```bash
# Install jq if not already installed
sudo apt-get install jq  # or equivalent for your system

# Copy environment template
cp .env.example .env

# Edit .env with your Name.com credentials
nano .env

# Run the DNS setup script
bash scripts/setup_dns.sh
```

The script will automatically:
- Remove any existing A records for @
- Create the 4 required A records for GitHub Pages
- Verify the configuration

### Manual Setup

If you prefer to set up DNS manually, create these A records for `ucli.tools`:

```
ucli.tools  →  185.199.108.153
ucli.tools  →  185.199.109.153
ucli.tools  →  185.199.110.153
ucli.tools  →  185.199.111.153
```

### Name.com API Setup

To use the automated script:

1. Go to [Name.com API Settings](https://www.name.com/account/settings/api)
2. Generate an API token
3. Add credentials to `.env` file:
   ```
   NAMECOM_USERNAME=your_username
   NAMECOM_API_TOKEN=your_api_token
   ```

---

## 📄 Site Sections

✅ **Hero** - Yellow/orange gradient with CLI-focused messaging  
✅ **Tool Manager Banner** - UCLI one-command install highlighting  
✅ **Flagship Tool (GitS)** - Problem/Solution format with ASCII diagrams  
✅ **Developer Experience** - 4 key CLI features (cross-platform, batch ops, AI, one-command)  
✅ **How It Works** - 3-step process from zero to productivity  
✅ **Ecosystem Overview** - ucli/GitS/Documentation with status badges  
✅ **CTA** - Get started section  

## 🎯 Tools Status (Dec 2025)

**4 Professional CLI Tools Available!**

**Core Tools (Production Ready):**
- ✅ **gits** - Git workflow automation (Forgejo, Gitea, GitHub)
- ✅ **mdtexpdf** - Markdown to PDF with LaTeX support
- ✅ **mdaudiobook** - Markdown to audiobook converter
- ✅ **ucli** - Tool manager and installer

**Key Features:**
- ✅ **Cross-platform** - Works on Linux, macOS, and Windows
- ✅ **One-command install** - `ucli build [tool]` for instant setup
- ✅ **Batch operations** - Handle multiple repos/files simultaneously
- ✅ **AI integration** - Smart suggestions and automated workflows
- ✅ **Professional quality** - Production-ready for development teams

**What this means:**
- Install any CLI tool with one command
- Professional git workflows across all platforms
- Convert documents and create audiobooks instantly
- Cross-platform consistency for development teams

---

## 🔗 Related Repositories

- **[ucli](https://github.com/ucli-tools/ucli)** - Tool manager and installer
- **[gits](https://github.com/ucli-tools/gits)** - Git workflow automation
- **[mdtexpdf](https://github.com/ucli-tools/mdtexpdf)** - Markdown to PDF converter
- **[mdaudiobook](https://github.com/ucli-tools/mdaudiobook)** - Markdown to audiobook
- **[ucli-www-docs](https://github.com/ucli-tools/ucli-www-docs)** - Documentation site
- **[community](https://github.com/ucli-tools/community)** - Community resources

---

## 📝 License

Apache 2.0 License  
**Copyright 2025 UCLI Tools**
