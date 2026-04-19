#!/usr/bin/env bash                                                                                                                                                             
  # deploy.sh - Deploy MyApp to production or staging.                                                                                                                            
  set -euo pipefail
                                                                                                                                                                                  
  ENV=${1:-staging}                                                                                                                                                             
  APP_DIR=/opt/myapp                                                                                                                                                              
  SERVICE=myapp                                                                                                                                                                 

  log() { echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] $*"; }                                                                                                                      
  die() { echo "[$(date +"%Y-%m-%d %H:%M:%S")] [ERROR] $*" >&2; exit 1; }
                                                                                                                                                                                  
  [ "$ENV" = "production" ] || [ "$ENV" = "staging" ] || die "Usage: $0 [production|staging]"                                                                                     
                                                                                                                                                                                  
  log "Deploying to $ENV"                                                                                                                                                         
  git -C "$APP_DIR" pull origin main || die "git pull failed"                                                                                                                   
  "$APP_DIR/.venv/bin/pip" install -q -r "$APP_DIR/requirements.txt" || die "pip failed"                                                                                          
  "$APP_DIR/.venv/bin/python" "$APP_DIR/manage.py" migrate --noinput || die "migration failed"                                                                                    
  systemctl restart "$SERVICE" || die "restart failed"                                                                                                                            
  sleep 3                                                                                                                                                                         
  curl -sf http://localhost:8080/health || die "health check failed"                                                                                                              
  log "Deploy to $ENV complete."
