# Déplacement des Spams dans Junk si les entêtes sont présentes :
require ["fileinto","mailbox", "regex"];

if header :contains "X-Spam-Flag" "YES" {
	fileinto :create "Junk";
}

if header :contains "X-Spam" "Yes" {
	fileinto :create "Junk";
}

# Vérifie si le destinataire est du domaine concerné
if address :regex "to" "^([a-z0-9]+)\..*@.*$" {
  # Capture la partie avant le premier point
  set "prefix" "${1}";

  # Déplace le mail dans le dossier INBOX.PREFIX (créé si inexistant)
  fileinto :create "INBOX.${prefix}";


