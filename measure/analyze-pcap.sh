#!/bin/bash

export LC_NUMERIC=C

PROTOCOL=$1
PCAP_FILE_PATH=$2
TSHARK_PATH=`which tshark`

if [ -z $PROTOCOL ]; then
    echo "Protocol must be given as first argument!"
    exit 1
fi
if [ -z $PCAP_FILE_PATH ]; then
    echo "Capture file must be given as second argument!"
    exit 1
fi

if [ ! -x $TSHARK_PATH ]; then
    echo "Cannot find tshark executable!"
    exit 1
fi

if [ ! -e $PCAP_FILE_PATH ]; then
    echo "Capture file '$PCAP_FILE_PATH' not found!"
    exit 1
fi
if [ ! -f $PCAP_FILE_PATH ]; then
    echo "Capture file '$PCAP_FILE_PATH' not a regular file!"
    exit 1
fi
if [ ! -r $PCAP_FILE_PATH ]; then
    echo "Capture file '$PCAP_FILE_PATH' not readable!"
    exit 1
fi

capinfos -u $PCAP_FILE_PATH


case $PROTOCOL in
tls*)
    SERVER_ADDRESS=`tshark -2 -R 'ssl.handshake.type==1' -Tfields -e ip.dst -r $PCAP_FILE_PATH | head -1`
    SERVER_PORT=`tshark -2 -R 'ssl.handshake.type==1' -Tfields -e tcp.dstport -r $PCAP_FILE_PATH | head -1`

    echo -e "Server:\t\t     ${PROTOCOL}://${SERVER_ADDRESS}:${SERVER_PORT}"

    IN_DATA=`tshark -qz io,stat,0 -2 -R "ip.dst==$SERVER_ADDRESS and tcp.dstport==$SERVER_PORT" -r $PCAP_FILE_PATH | tail -2 | head -1 | cut -d '|' -f 4`
    echo -e "Incoming data:     $IN_DATA bytes"
    OUT_DATA=`tshark -qz io,stat,0 -2 -R "ip.src==$SERVER_ADDRESS and tcp.srcport==$SERVER_PORT" -r $PCAP_FILE_PATH | tail -2 | head -1 | cut -d '|' -f 4`
    echo -e "Outgoing data:    $OUT_DATA bytes"

    echo -e -n "Client hello:\t     "
    tshark -r $PCAP_FILE_PATH -Y 'ssl.handshake.type==1' 2>/dev/null | wc -l
    echo -e -n "Server hello:\t     "
    tshark -r $PCAP_FILE_PATH -Y 'ssl.handshake.type==2' 2>/dev/null | wc -l
    echo -e -n "Server kex:\t     "
    tshark -r $PCAP_FILE_PATH -Y 'ssl.handshake.type==12' 2>/dev/null | wc -l
    ;;
ssh*)
    SERVER_ADDRESS=`tshark -d tcp.port==1-65535,ssh -2 -R 'ssh.message_code==30 or ssh.message_code==32' -Tfields -e ip.dst -r $PCAP_FILE_PATH | head -1`
    SERVER_PORT=`tshark -d tcp.port==1-65535,ssh -2 -R 'ssh.message_code==30 or ssh.message_code==32' -Tfields -e tcp.dstport -r $PCAP_FILE_PATH | head -1`

    echo -e "Server:\t\t     ${PROTOCOL}://${SERVER_ADDRESS}:${SERVER_PORT}"

    IN_DATA=`tshark -qz io,stat,0 -2 -R "ip.dst==$SERVER_ADDRESS and tcp.dstport==$SERVER_PORT" -r $PCAP_FILE_PATH | tail -2 | head -1 | cut -d '|' -f 4`
    echo -e "Incoming data:     $IN_DATA bytes"
    OUT_DATA=`tshark -qz io,stat,0 -2 -R "ip.src==$SERVER_ADDRESS and tcp.srcport==$SERVER_PORT" -r $PCAP_FILE_PATH | tail -2 | head -1 | cut -d '|' -f 4`
    echo -e "Outgoing data:    $OUT_DATA bytes"

    echo -e -n "KEX/GEX init:\t     "
    tshark -d tcp.port==1-65535,ssh -r $PCAP_FILE_PATH -Y 'ssh.message_code==30 or ssh.message_code==32' 2>/dev/null | wc -l
    echo -e -n "KEX/GEX reply:\t     "
    tshark -d tcp.port==1-65535,ssh -r $PCAP_FILE_PATH -Y 'ssh.message_code==31 or ssh.message_code==33' 2>/dev/null | wc -l
    ;;
ikev2*)
    SERVER_ADDRESS=`tshark -d udp.port==1-65535,isakmp -2 -R 'isakmp.nextpayload==33' -Tfields -e ip.dst -r $PCAP_FILE_PATH | head -1`
    SERVER_PORT=`tshark -d udp.port==1-65535,isakmp -2 -R 'isakmp.nextpayload==33' -Tfields -e udp.dstport -r $PCAP_FILE_PATH | head -1`

    echo -e "Server:\t\t     ${PROTOCOL}://${SERVER_ADDRESS}:${SERVER_PORT}"

    IN_DATA=`tshark -qz io,stat,0 -2 -R "ip.dst==$SERVER_ADDRESS and udp.dstport==$SERVER_PORT" -r $PCAP_FILE_PATH | tail -2 | head -1 | cut -d '|' -f 4`
    echo -e "Incoming data:     $IN_DATA bytes"
    OUT_DATA=`tshark -qz io,stat,0 -2 -R "ip.src==$SERVER_ADDRESS and udp.srcport==$SERVER_PORT" -r $PCAP_FILE_PATH | tail -2 | head -1 | cut -d '|' -f 4`
    echo -e "Outgoing data:    $OUT_DATA bytes"

    echo -e -n "IKE SA init:\t     "
    tshark -d udp.port==1-65535,isakmp -r $PCAP_FILE_PATH -Y 'isakmp.flags & 0x08 and isakmp.nextpayload==33' 2>/dev/null | wc -l
    echo -e -n "IKE SA init:\t     "
    tshark -d udp.port==1-65535,isakmp -r $PCAP_FILE_PATH -Y 'isakmp.flags & 0x20 and isakmp.nextpayload==33' 2>/dev/null | wc -l
    ;;
*)
    echo "Unknown protocol '$PROTOCOL'!"
    exit 1
    ;;
esac
