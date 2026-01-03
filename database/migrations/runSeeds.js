const fs = require("fs");
const path = require("path");
const db = require("../../src/config/db");

const seedsDir = path.join(__dirname);

async function runSeeds() {
  console.log("🌱 Running seed data...");

  const files = fs
    .readdirSync(seedsDir)
    .filter(file => file.endsWith(".sql"))
    .sort();

  for (const file of files) {
    const sql = fs.readFileSync(path.join(seedsDir, file), "utf8");
    await db.query(sql);
  }
}

module.exports = runSeeds;
