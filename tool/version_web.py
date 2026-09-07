"""Version web entry files by content so Pages cannot mix old and new builds."""
from pathlib import Path
import hashlib
import re

root = Path(__file__).resolve().parents[1] / 'build' / 'web'
main = root / 'main.dart.js'
digest = hashlib.sha256(main.read_bytes()).hexdigest()[:12]
main_name = f'main.{digest}.dart.js'
(root / main_name).write_bytes(main.read_bytes())
bootstrap = (root / 'flutter_bootstrap.js').read_text(encoding='utf-8')
bootstrap = bootstrap.replace('"mainJsPath":"main.dart.js"', f'"mainJsPath":"{main_name}"')
bootstrap = re.sub(r'_flutter.loader.load\(\{\s*serviceWorkerSettings:.*?\}\s*\}\);', '_flutter.loader.load({});', bootstrap, flags=re.S)
boot_hash = hashlib.sha256(bootstrap.encode()).hexdigest()[:12]
boot_name = f'flutter_bootstrap.{boot_hash}.js'
(root / boot_name).write_text(bootstrap, encoding='utf-8')
index = (root / 'index.html').read_text(encoding='utf-8')
index = re.sub(r'src="flutter_bootstrap(?:\.[a-f0-9]+)?\.js"', f'src="{boot_name}"', index)
(root / 'index.html').write_text(index, encoding='utf-8')
print(f'Published entry: {main_name}')
