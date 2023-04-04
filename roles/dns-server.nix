{ pkgs, config, ... }:
# Config for pi-hole like device (adguard) and the dns resolver it queries (unbound)
{

  environment.systemPackages = with pkgs; [
    adguardhome
  ];

  services.unbound = {
    enable = true;
    settings = {
      server = {
        port = 54;

        do-ip4 = "yes";
        do-ip6 = "yes";
        do-udp = "yes";

        # You want to leave this to no unless you have *native* IPv6.
        prefer-ip6 = "yes";

        # Trust glue only if it is within the server's authority
        harden-glue = "yes";
        # Require DNSSEC data for trust-anchored zones, if such data is absent, the zone becomes BOGUS
        harden-dnssec-stripped = "yes";

        # Don't use Capitalization randomization as it known to cause DNSSEC issues sometimes
        # see https://discourse.pi-hole.net/t/unbound-stubby-or-dnscrypt-proxy/9378 for further details
        use-caps-for-id = "no";

        # Reduce EDNS reassembly buffer size.
        # Suggested by the unbound man page to reduce fragmentation reassembly problems
        edns-buffer-size = 1232;

        # Perform prefetching of close to expired message cache entries
        # This only applies to domains that have been frequently queried
        prefetch = "yes";

        # One thread should be sufficient, can be increased on beefy machines. In reality for most users running on small networks or on a single machine, it should be unnecessary to seek performance enhancement by increasing num-threads above 1.
        num-threads = 1;

        # Ensure kernel buffer is large enough to not lose messages in traffic spikes
        # Be aware that if enabled (requires CAP_NET_ADMIN or privileged), the kernel buffer must have the defined amount of memory, if not, a warning will be raised.
        #so-rcvbuf: 1m
      };
    };
  };

  # Ensure privacy of local IP ranges
  services.adguardhome = {
    enable = false;
    openFirewall = true;
    settings.dns.bind_host = "0.0.0.0";
  };

  networking.firewall = {
    allowedUDPPorts = [ 53 ];
    allowedTCPPorts = [ 53 ];
  };

  # add to host file here so it works for entire network..
  networking.extraHosts = ''
    192.168.7.170 brother
  '';
}

