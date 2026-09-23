---
root: false
targets:
  - '*'
---
# クエリパラメータ

- `plainDate`, `utcDateTime`, `plainTime` 型を単体でクエリパラメータに含める場合は、必ず `explode: true` を設定すること。
- これらの型を配列でクエリパラメータに含める場合は、`explode: true` の設定は不要。
