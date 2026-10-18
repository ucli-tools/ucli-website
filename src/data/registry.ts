// The tool list comes from the registry (apps.yaml, the "official" list) at build time. If the
// fetch fails or yields nothing, the committed snapshot is used, so a registry outage never
// breaks a deploy or empties the page.
import snapshot from './registry-snapshot.json';

export interface RegistryTool { name: string; desc: string }

const REGISTRY_URL = 'https://raw.githubusercontent.com/ucli-tools/ucli-registry/main/registry/apps.yaml';
const NAME_OK = /^[a-z0-9][a-z0-9-]*$/;

// Reads only `- name:` and `description:` (with folded continuation lines) up to `community:`.
export function parseOfficial(text: string): RegistryTool[] {
  const out: RegistryTool[] = [];
  let cur: RegistryTool | null = null;
  let inDesc = false;
  for (const line of text.split(/\n  community:/)[0].split('\n')) {
    let m = line.match(/^ {2}- name: (\S+)\s*$/);
    if (m) { cur = { name: m[1], desc: '' }; out.push(cur); inDesc = false; continue; }
    if (!cur) continue;
    m = line.match(/^ {4}description: (.*)$/);
    if (m) { cur.desc = m[1].trim(); inDesc = true; continue; }
    if (inDesc && /^ {6}\S/.test(line)) { cur.desc += ' ' + line.trim(); continue; }
    inDesc = false;
  }
  return out.filter((t) => NAME_OK.test(t.name));
}

export async function getTools(): Promise<RegistryTool[]> {
  try {
    const res = await fetch(REGISTRY_URL);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const tools = parseOfficial(await res.text());
    if (tools.length === 0) throw new Error('no tools parsed');
    return tools;
  } catch (e) {
    console.warn(`registry fetch failed (${e}); using the committed snapshot`);
    return snapshot as RegistryTool[];
  }
}

// Tools that have a page on this site; every other tool links to its repository.
export const PAGES = ['ucli', 'gits', 'mdtexpdf', 'mdaudiobook', 'docx2md'];
export const repoUrl = (name: string) => `https://github.com/ucli-tools/${name}`;
