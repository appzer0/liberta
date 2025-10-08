require ["fileinto", "mailbox"];

# Déplacement des spams dans Junk
if header :contains "X-Spam-Flag" "YES" {
    fileinto :create "Junk";
    stop;
}

if header :contains "X-Spam" "Yes" {
    fileinto :create "Junk";
    stop;
}

# Déplacement dynamique dans des nouveaux sous-dossiers basés sur
# préfixes avec ou sans tirets avant le point, via un script Python:
# Exemples (3 niveaux max de sous-dossiers) :
# alias@liberta.email -> ./ # (INBOX)
# banque.alias@liberta.email -> ./Banque/
# banque-visa.alias@liberta.email -> ./Banque/Visa/
# shopping-amazon-france.alias@liberta.email -> ./Shopping/Amazon/France/
pipe :flags "user" "/etc/dovecot/sieve/mail_move_dynamic.py";
stop;
