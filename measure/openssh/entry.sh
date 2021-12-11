#!/usr/bin/env bash

set -ex

stop() {
    local pid=$(cat /run/sshd/sshd.pid)
    kill -SIGTERM "${pid}"
    wait "${pid}"
}

trap stop SIGTERM
$@ &
pid="$!"
echo "${pid}" > /run/sshd/sshd.pid
wait "${pid}"
exit $?
