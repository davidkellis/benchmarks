const pattern = /c?ei/g;

function isValid(s: string): boolean {
  const matches = s.match(pattern);
  if (!matches) return true;
  for (const match of matches) {
    if (!match.startsWith("c")) return false;
  }
  return true;
}

const path = process.argv[2] || Bun.argv[2];
const content = await Bun.file(path).text();
for (const line of content.split("\n")) {
  if (line.length > 0 && !isValid(line)) {
    console.log(line);
  }
}
