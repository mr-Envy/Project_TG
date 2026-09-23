import sqlite3
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parents[2]
DATABASE_PATH = BASE_DIR / "data" / "question_bank.db"
def get_connection():
    connection=sqlite3.connect(DATABASE_PATH)
    return connection