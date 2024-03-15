Navigiere in der Benutzeroberfläche von Portainer zu Einstellungen > Authentifizierung und wähle OAuth als Authentifizierungsmethode aus. 
Lege die folgenden Werte fest:

Single Sign-On: aktiviert

Automatische Benutzerbereitstellung: deaktiviert (dies ist nur meine Präferenz)

Anbieter: benutzerdefiniert

Kunden-ID: [Fügen Sie die oben generierte Zufalls-ID ein]

Client-Geheimnis: [Fügen Sie das oben generierte Klartext-Geheimnis ein]

Autorisierungs-URL: https://auth.home.yourdomain.com/api/oidc/authorization

Zugriffstoken-URL: https://auth.home.yourdomain.com/api/oidc/token

Ressourcen-URL: https://auth.home.yourdomain.com/api/oidc/userinfo

Weiterleitungs-URL: https://portainer.home.yourdomain.com

Benutzerkennung: preferred_username

Geltungsbereiche: openid profile groups email

Hinweis: Stelle sicher, dass die obigen Dummy-URLs durch die Eigenen ersetzen.
