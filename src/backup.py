#!/usr/bin/env python3
"""backup.py - Database and file backup utility for MyApp."""
import argparse, subprocess, os, sys, datetime

BACKUP_DIR = "/mnt/backups"
DB_NAME    = "myapp_prod"
DB_USER    = "myapp_user"
RETENTION  = 7

def parse_args():
    p = argparse.ArgumentParser(description="MyApp backup utility")
    p.add_argument("--env", choices=["production", "staging"], default="staging")
    p.add_argument("--output", default=BACKUP_DIR)
    p.add_argument("--dry-run", action="store_true")
    return p.parse_args()

def run(cmd, dry_run=False):
    print(f"[RUN] {cmd}")
    if not dry_run:
        r = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        if r.returncode != 0:
            print(f"[ERROR] {r.stderr.strip()}", file=sys.stderr)
            sys.exit(1)

def main():
    args = parse_args()
    os.makedirs(args.output, exist_ok=True)
    print(f"[INFO] Starting backup env={args.env}")
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    run(f"pg_dump -U {DB_USER} {DB_NAME} | gzip > {args.output}/db_{args.env}_{ts}.sql.gz", args.dry_run)
    print("[INFO] Done.")

if __name__ == "__main__":
    main()
