cd "$DOCUMENTS/synthesis/vpns" && \
    sudo openvpn --config "$DOCUMENTS/synthesis/vpns/client.conf" \
    --setenv PATH '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' \
    --script-security 2 \
    --up /etc/openvpn/scripts/update-systemd-resolved \
    --down /etc/openvpn/scripts/update-systemd-resolved \
    --down-pre
