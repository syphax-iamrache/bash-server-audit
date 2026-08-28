#!/bin/bash 

set -uo pipefail

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
RAPPORT="rapport_audit_${DATE}.txt "
SEUIL_DISQUE=80
EMAIL_DESTINATAIRE="syphax@example.com"

#une fonction qui va nous permettre de mettre le titre à chaque fois  dans le rapport
section(){
        echo " " >> "$RAPPORT"
        echo "========================================" >> "$RAPPORT"
        echo "$1" >> "$RAPPORT"
        echo "========================================" >> "$RAPPORT"

}

#debut du rapport
echo "RAPPORT D'AUDIT SERVEUR" > "$RAPPORT"
echo "généré le : $(date)" >> "$RAPPORT"
echo "hostname  : $(hostname)" >> "$RAPPORT"


#  Espace disque 
section "1. ESPACE DISQUE"
df -h --output=source,size,used,avail,pcent,target | grep -v "tmpfs\|loop" >> "$RAPPORT" #éliminer les tmpfs et loop

echo "" >> "$RAPPORT"
echo " Alertes disque (seuil ${SEUIL_DISQUE}%) " >> "$RAPPORT"
#tail (pour afficher à partir de la 2eme ligne 
df -h --output=pcent,target | tail -n +2 | while read -r pcent target; do
    valeur=$(echo "$pcent" | tr -d '%') #vers la fin on supprime le %(avec tr -d %), (45% devient 45) pour pouvoir le comparer 
    if [ "$valeur" -ge "$SEUIL_DISQUE" ]; then
        echo "⚠ ALERTE : $target utilisé à ${pcent}" >> "$RAPPORT"
    fi
done

# --- 2. Services actifs ---
section "2. SERVICES ACTIFS (systemd)"
systemctl list-units --type=service --state=running --no-pager --no-legend | \
    awk '{print $1}' >> "$RAPPORT"

NB_SERVICES=$(systemctl list-units --type=service --state=running --no-pager --no-legend | wc -l) # ici  wc -l pour compter les lignes, si c'est
#wc -w c'est pour compter les mots, wc -c pour compter les octets ...
echo "" >> "$RAPPORT"
echo "Total : $NB_SERVICES services actifs" >> "$RAPPORT"


# --- 3. Ports ouverts ---

section "3. PORTS OUVERTS (en écoute)"
if command -v ss &> /dev/null; then # si la commande ss existe, tu fais ss (la réponse est mise à la corbeille)
    ss -tulnp 2>/dev/null >> "$RAPPORT"
else
    netstat -tulnp 2>/dev/null >> "$RAPPORT" # sinon tu utilise netstat à la place de  ss
fi

# --- 4. Utilisateurs connectés ---
section "4. UTILISATEURS CONNECTÉS"
who >> "$RAPPORT"

echo "" >> "$RAPPORT"
echo "-- Historique des dernières connexions --" >> "$RAPPORT"
last -n 10 >> "$RAPPORT"

# --- 5. CPU / RAM ---
section "5. CPU / RAM"

echo "-- Charge système (CPU) --" >> "$RAPPORT"
uptime >> "$RAPPORT"

echo "" >> "$RAPPORT"
echo "-- Utilisation de la mémoire RAM --" >> "$RAPPORT"
free -h >> "$RAPPORT"
# --- Fin du rapport ---
section "FIN DU RAPPORT"
echo "Rapport généré : $RAPPORT" >> "$RAPPORT"

# --- Affichage à l'écran ---
echo "✔ Audit terminé."
echo "✔ Rapport sauvegardé dans : $RAPPORT"
cat "$RAPPORT"

# --- 6. ENVOI DU RAPPORT PAR EMAIL ---
if command -v mail &> /dev/null; then
    mail -s "Audit serveur - $(hostname) - $(date)" "$EMAIL_DESTINATAIRE" < "$RAPPORT"
    echo "✔ Rapport envoyé par email à : $EMAIL_DESTINATAIRE"
else
    echo "⚠ La commande 'mail' n'est pas installée."
fi

 