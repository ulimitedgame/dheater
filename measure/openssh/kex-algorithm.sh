#!/usr/bin/env sh

DH_PARAM_SIZE=$1

case $DH_PARAM_SIZE in
	1024) KEX_ALGORITHM=diffie-hellman-group1-sha1 ;;
	2048) KEX_ALGORITHM=diffie-hellman-group14-sha256 ;;
	3072) KEX_ALGORITHM=diffie-hellman-group15-sha512 ;;
	4096) KEX_ALGORITHM=diffie-hellman-group16-sha512 ;;
	6144) KEX_ALGORITHM=diffie-hellman-group17-sha512 ;;
	8192) KEX_ALGORITHM=diffie-hellman-group18-sha512 ;;
        *) exit 1;;
esac

echo $KEX_ALGORITHM
