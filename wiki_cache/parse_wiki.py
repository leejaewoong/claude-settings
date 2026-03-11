import json, os, re, html
from pathlib import Path

cache_dir = Path('C:/Users/jaewoong/.claude/wiki_cache')

def strip_html(text):
    text = re.sub(r'<ac:structured-macro[^>]*>.*?</ac:structured-macro>', '', text, flags=re.DOTALL)
    text = re.sub(r'<ac:image[^>]*>.*?</ac:image>', '[image]', text, flags=re.DOTALL)
    text = re.sub(r'<ac:link[^>]*>.*?</ac:link>', '', text, flags=re.DOTALL)
    text = re.sub(r'<ac:[^>]*/?>', '', text)
    text = re.sub(r'</ac:[^>]*>', '', text)
    text = re.sub(r'<ri:[^>]*/?>', '', text)
    text = re.sub(r'</ri:[^>]*>', '', text)
    text = re.sub(r'<h[1-6][^>]*>(.*?)</h[1-6]>', r'\n## \1\n', text, flags=re.DOTALL)
    text = re.sub(r'<tr[^>]*>(.*?)</tr>', r'\1\n', text, flags=re.DOTALL)
    text = re.sub(r'<t[hd][^>]*>(.*?)</t[hd]>', r'\1 | ', text, flags=re.DOTALL)
    text = re.sub(r'<li[^>]*>(.*?)</li>', r'- \1\n', text, flags=re.DOTALL)
    text = re.sub(r'<p[^>]*>(.*?)</p>', r'\1\n', text, flags=re.DOTALL)
    text = re.sub(r'<br\s*/?>', '\n', text)
    text = re.sub(r'<strong>(.*?)</strong>', r'**\1**', text, flags=re.DOTALL)
    text = re.sub(r'<em>(.*?)</em>', r'*\1*', text, flags=re.DOTALL)
    text = re.sub(r'<code>(.*?)</code>', r'`\1`', text, flags=re.DOTALL)
    text = re.sub(r'<[^>]+>', '', text)
    text = html.unescape(text)
    text = re.sub(r'\n{3,}', '\n\n', text)
    text = re.sub(r'[ \t]+', ' ', text)
    return text.strip()

for f in sorted(cache_dir.glob('*.json')):
    try:
        data = json.loads(f.read_text(encoding='utf-8'))
        title = data.get('title', '')
        body_raw = data.get('body', {}).get('storage', {}).get('value', '')
        body = strip_html(body_raw)
        out_path = cache_dir / f'{f.stem}.txt'
        out_path.write_text(f'# {title}\n\n{body}', encoding='utf-8')
        print(f'{f.stem}: {len(body)} chars')
    except Exception as e:
        print(f'{f.stem}: ERROR - {e}')
