const fs = require("fs");
const path = require("path");
const db = require("../../src/config/db");

const migrationsDir = path.join(__dirname);

async function runMigrations() {
  const files = fs
    .readdirSync(migrationsDir)
    .filter(file => file.endsWith(".sql"))
    .sort();

  for (const file of files) {
    console.log(`🛠 Running migration: ${file}`);
    const sql = fs.readFileSync(path.join(migrationsDir, file), "utf8");
    await db.query(sql);
  }
}

module.exports = runMigrations;
