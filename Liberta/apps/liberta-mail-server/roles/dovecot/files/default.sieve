# Déplacement des Spams dans Junk si les entêtes sont présentes :
require ["fileinto","mailbox"];

if header :contains "X-Spam-Flag" "YES" {
	fileinto :create "Junk";
}

if header :contains "X-Spam" "Yes" {
	fileinto :create "Junk";
}

