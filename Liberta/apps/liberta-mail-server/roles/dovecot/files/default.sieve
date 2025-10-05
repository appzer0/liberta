require ["fileinto", "mailbox", "regex", "variables"];

# Déplacement des spams dans Junk
if header :contains "X-Spam-Flag" "YES" {
    fileinto :create "Junk";
}

if header :contains "X-Spam" "Yes" {
    fileinto :create "Junk";
}

# Déplacement dynamique basé sur préfixe avant le point
if address :regex "to" "^([a-z0-9]+)\..*@.*$" {
    set "prefix" "${1}";
    fileinto :create "INBOX.${prefix}";
    stop;
}

