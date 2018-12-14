#!/usr/bin/env bash

set -u

if [ -z "$RSSMX100A_INSTANCE" ]; then
    echo "RSSMX100A_INSTANCE environment variable is not set." >&2
    exit 1
fi

RSSMX100A_TYPE=$(echo ${RSSMX100A_INSTANCE} | grep -Eo "[^0-9]+");
RSSMX100A_NUMBER=$(echo ${RSSMX100A_INSTANCE} | grep -Eo "[0-9]+");

if [ -z "$RSSMX100A_TYPE" ] || [-z "$RSSMX100A_NUMBER" ]; then
    echo "Device instance is not valid. Valid device options are: SMA, and SMB." >&2
    echo "The instance format is: <device type><device index>. Example: SMA1" >&2
    exit 5
fi

export RSSMX100A_CURRENT_PV_AREA_PREFIX=RSSMX100A_${RSSMX100A_INSTANCE}_PV_AREA_PREFIX
export RSSMX100A_CURRENT_PV_DEVICE_PREFIX=RSSMX100A_${RSSMX100A_INSTANCE}_PV_DEVICE_PREFIX
export RSSMX100A_CURRENT_DEVICE_IP=RSSMX100A_${RSSMX100A_INSTANCE}_DEVICE_IP
export RSSMX100A_CURRENT_DEVICE_TELNET_PORT_SUFFIX=RSSMX100A_${RSSMX100A_INSTANCE}_TELNET_PORT_SUFFIX
# Only works with bash
export RSSMX100A_PV_AREA_PREFIX=${!RSSMX100A_CURRENT_PV_AREA_PREFIX}
export RSSMX100A_PV_DEVICE_PREFIX=${!RSSMX100A_CURRENT_PV_DEVICE_PREFIX}
export RSSMX100A_DEVICE_IP=${!RSSMX100A_CURRENT_DEVICE_IP}
export RSSMX100A_DEVICE_TELNET_PORT=${PROCSERV_RSSMX100A_PORT_PREFIX}${!RSSMX100A_CURRENT_DEVICE_TELNET_PORT_SUFFIX}

if [ -z "${RSSMX100A_CURRENT_DEVICE_TELNET_PORT_SUFFIX}" ]; then
    echo "TELNET port is not set." >&2
    exit 1
fi

./runProcServ.sh \
    -t "${RSSMX100A_DEVICE_TELNET_PORT}" \
    -i "${RSSMX100A_DEVICE_IP}" \
    -d "${RSSMX100A_TYPE}" \
    -P "${RSSMX100A_PV_AREA_PREFIX}" \
    -R "${RSSMX100A_PV_DEVICE_PREFIX}"

