#!/bin/bash

# Script de vérification de la cohérence des scripts CyberGuard Unified SOC
# Vérifie que tous les scripts respectent la structure d'arborescence

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Compteurs
TOTAL_SCRIPTS=0
CORRECT_SCRIPTS=0
INCORRECT_SCRIPTS=0

print_header "VÉRIFICATION DE LA COHÉRENCE DES SCRIPTS"

# Fonction pour vérifier un script
check_script() {
    local script_file="$1"
    local script_type="$2"
    
    TOTAL_SCRIPTS=$((TOTAL_SCRIPTS + 1))
    
    if [ ! -f "$script_file" ]; then
        print_error "Script non trouvé: $script_file"
        INCORRECT_SCRIPTS=$((INCORRECT_SCRIPTS + 1))
        return 1
    fi
    
    echo -e "\n${YELLOW}Vérification: $script_file${NC}"
    
    local issues=0
    
    if [ "$script_type" == "bash" ]; then
        # Vérifier les références au dossier docker
        if grep -q "cd docker" "$script_file" && ! grep -q "cd ../docker\|cd \.\./docker" "$script_file"; then
            print_error "Utilise 'cd docker' au lieu de 'cd ../docker'"
            issues=$((issues + 1))
        fi
        
        # Vérifier les chemins relatifs vers les backups
        if grep -q '\./backups' "$script_file" && ! grep -q '\.\./backups' "$script_file"; then
            print_warning "Utilise './backups' au lieu de '../backups'"
            issues=$((issues + 1))
        fi
        
        # Vérifier la présence de docker-compose
        if grep -q 'docker-compose' "$script_file"; then
            if ! grep -q 'COMPOSE_CMD\|docker compose' "$script_file"; then
                print_warning "N'utilise pas la détection automatique de docker-compose"
            fi
        fi
        
    elif [ "$script_type" == "powershell" ]; then
        # Vérifier les références au dossier docker
        if grep -q 'Set-Location "docker"' "$script_file" && ! grep -q 'Set-Location "\.\./docker"' "$script_file"; then
            print_error "Utilise 'Set-Location \"docker\"' au lieu de 'Set-Location \"../docker\"'"
            issues=$((issues + 1))
        fi
        
        # Vérifier les chemins Windows
        if grep -q 'docker\\' "$script_file"; then
            print_success "Utilise les bons séparateurs de chemin Windows"
        fi
    fi
    
    if [ $issues -eq 0 ]; then
        print_success "Script conforme à la structure"
        CORRECT_SCRIPTS=$((CORRECT_SCRIPTS + 1))
    else
        print_error "Script avec $issues problème(s)"
        INCORRECT_SCRIPTS=$((INCORRECT_SCRIPTS + 1))
    fi
}

# Vérification des scripts Bash
print_header "SCRIPTS BASH (.sh)"
for script in scripts/*.sh; do
    if [ -f "$script" ] && [ "$(basename "$script")" != "verify-scripts.sh" ]; then
        check_script "$script" "bash"
    fi
done

# Vérification des scripts PowerShell
print_header "SCRIPTS POWERSHELL (.ps1)"
for script in scripts/*.ps1; do
    if [ -f "$script" ]; then
        check_script "$script" "powershell"
    fi
done

# Vérification de la structure de fichiers
print_header "VÉRIFICATION DE LA STRUCTURE DE FICHIERS"

# Vérifier que le dossier docker existe
if [ -d "docker" ]; then
    print_success "Dossier docker/ existe"
    
    # Vérifier les fichiers docker-compose
    for compose_file in docker-compose.yml docker-compose.minimal.yml docker-compose.dev.yml; do
        if [ -f "docker/$compose_file" ]; then
            print_success "Fichier docker/$compose_file trouvé"
        else
            print_error "Fichier docker/$compose_file manquant"
        fi
    done
else
    print_error "Dossier docker/ manquant"
fi

# Vérifier que le dossier scripts existe
if [ -d "scripts" ]; then
    print_success "Dossier scripts/ existe"
else
    print_error "Dossier scripts/ manquant"
fi

# Vérifier que le dossier backups peut être créé
if [ -d "backups" ] || mkdir -p "backups" 2>/dev/null; then
    print_success "Dossier backups/ accessible"
else
    print_error "Impossible de créer le dossier backups/"
fi

# Résumé final
print_header "RÉSUMÉ DE LA VÉRIFICATION"
echo "Scripts vérifiés: $TOTAL_SCRIPTS"
echo -e "${GREEN}Scripts conformes: $CORRECT_SCRIPTS${NC}"
echo -e "${RED}Scripts non-conformes: $INCORRECT_SCRIPTS${NC}"

if [ $INCORRECT_SCRIPTS -eq 0 ]; then
    echo -e "\n${GREEN}🎉 TOUS LES SCRIPTS SONT CONFORMES !${NC}"
    exit 0
else
    echo -e "\n${RED}⚠️  $INCORRECT_SCRIPTS SCRIPT(S) NÉCESSITENT DES CORRECTIONS${NC}"
    exit 1
fi
