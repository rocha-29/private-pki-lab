#!/bin/bash
# check-certs.sh - PKI lab monitor
# 1) Alerts if the Nginx certificate expires in less than 8 hours.
# 2) Alerts if the step-ca CA does not answer its health check.
# Exit code: 0 = all OK, 1 = at least one alert (used by the cron job).

CERT=/etc/nginx/certs/web.crt
FECHA=$(date '+%Y-%m-%d %H:%M:%S')
ESTADO=0

if sudo openssl x509 -checkend 28800 -noout -in "$CERT" > /dev/null; then
  echo "$FECHA OK: el certificado tiene más de 8 horas de vida"
else
  echo "$FECHA ALERTA: el certificado expira en menos de 8 horas"
  ESTADO=1
fi

if step ca health > /dev/null 2>&1; then
  echo "$FECHA OK: la CA responde"
else
  echo "$FECHA ALERTA: la CA no responde"
  ESTADO=1
fi

exit $ESTADO
