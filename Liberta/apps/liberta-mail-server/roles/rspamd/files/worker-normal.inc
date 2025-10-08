worker {
  type = "normal";
  count = 4;
  memcache_servers = "127.0.0.1:11311";
  max_connections = 100;
  # Limiter cache Bayes
  bayes {
    max_size = 10000000; # ~10 Mo
    expiration = 30d;
  }
  # Timeout DNS court
  dns_timeout = 2s;
}
