cd "$DOCUMENTS/synthesis/vpns" && \
    sudo -E openvpn --config "$DOCUMENTS/synthesis/vpns/client.conf" \
    --setenv PATH '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' \
