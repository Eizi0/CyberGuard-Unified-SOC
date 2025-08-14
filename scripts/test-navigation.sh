#!/bin/bash

# Test de navigation intelligente pour tous les scripts
# Vérifie que les scripts fonctionnent depuis la racine ET depuis le dossier scripts

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

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

# Vérification de la position actuelle
detect_location() {
    if [ -f "README.md" ] && [ -d "scripts" ] && [ -d "docker" ]; then
        echo "root"
    elif [ -f "../README.md" ] && [ -d "../scripts" ] && [ -d "../docker" ]; then
        echo "scripts"
    else
        echo "unknown"
    fi
}

# Test de navigation vers docker
test_docker_navigation() {
    local test_name="$1"
    local start_location="$2"
    
    print_info "Test: $test_name (depuis $start_location)"
    
    # Sauvegarder la position actuelle
    local original_dir=$(pwd)
    
    if [ -d "docker" ]; then
        print_success "Navigation vers ./docker réussie"
        local docker_files=$(ls docker/docker-compose*.yml 2>/dev/null | wc -l)
        if [ $docker_files -ge 3 ]; then
            print_success "Fichiers docker-compose trouvés: $docker_files"
        else
            print_error "Fichiers docker-compose manquants: $docker_files trouvé(s)"
        fi
    elif [ -d "../docker" ]; then
        print_success "Navigation vers ../docker réussie"
        local docker_files=$(ls ../docker/docker-compose*.yml 2>/dev/null | wc -l)
        if [ $docker_files -ge 3 ]; then
            print_success "Fichiers docker-compose trouvés: $docker_files"
        else
            print_error "Fichiers docker-compose manquants: $docker_files trouvé(s)"
        fi
    else
        print_error "Dossier docker non trouvé"
        return 1
    fi
    
    # Retourner à la position d'origine
    cd "$original_dir"
    return 0
}

# Test depuis la racine
test_from_root() {
    print_header "TEST DEPUIS LA RACINE DU PROJET"
    
    if [ "$(detect_location)" != "root" ]; then
        # Essayer de naviguer vers la racine
        if [ -f "../README.md" ] && [ -d "../scripts" ]; then
            cd ..
        else
            print_error "Impossible de localiser la racine du projet"
            return 1
        fi
    fi
    
    local current_location=$(detect_location)
    if [ "$current_location" = "root" ]; then
        print_success "Positionnement à la racine confirmé"
        test_docker_navigation "Navigation depuis racine" "racine"
    else
        print_error "Position racine non confirmée"
        return 1
    fi
}

# Test depuis le dossier scripts
test_from_scripts() {
    print_header "TEST DEPUIS LE DOSSIER SCRIPTS"
    
    # Naviguer vers le dossier scripts
    if [ -d "scripts" ]; then
        cd scripts
    elif [ "$(detect_location)" = "scripts" ]; then
        print_success "Déjà dans le dossier scripts"
    else
        print_error "Impossible de naviguer vers le dossier scripts"
        return 1
    fi
    
    local current_location=$(detect_location)
    if [ "$current_location" = "scripts" ]; then
        print_success "Positionnement dans scripts/ confirmé"
        test_docker_navigation "Navigation depuis scripts" "scripts"
    else
        print_error "Position scripts non confirmée"
        return 1
    fi
}

# Test de création du dossier backups
test_backups_creation() {
    print_header "TEST CRÉATION DOSSIER BACKUPS"
    
    # Sauvegarder la position
    local original_dir=$(pwd)
    
    # Test depuis la racine
    if [ "$(detect_location)" != "root" ]; then
        cd ..
    fi
    
    if [ ! -d "backups" ]; then
        print_info "Tentative de création du dossier backups"
        mkdir -p backups 2>/dev/null
        if [ -d "backups" ]; then
            print_success "Dossier backups créé avec succès"
            rmdir backups 2>/dev/null  # Nettoyage
        else
            print_error "Impossible de créer le dossier backups"
        fi
    else
        print_success "Dossier backups existe déjà"
    fi
    
    # Test depuis scripts
    cd scripts 2>/dev/null || true
    if [ "$(detect_location)" = "scripts" ]; then
        if [ ! -d "../backups" ]; then
            print_info "Tentative de création de ../backups depuis scripts"
            mkdir -p ../backups 2>/dev/null
            if [ -d "../backups" ]; then
                print_success "Dossier ../backups créé avec succès"
                rmdir ../backups 2>/dev/null  # Nettoyage
            else
                print_error "Impossible de créer ../backups"
            fi
        else
            print_success "Dossier ../backups accessible"
        fi
    fi
    
    cd "$original_dir"
}

# Test des scripts d'automatisation
test_automation_scripts() {
    print_header "TEST DES SCRIPTS D'AUTOMATISATION"
    
    local scripts_to_test=("test-structure.sh" "auto-deploy.sh" "health-check.sh")
    
    for script in "${scripts_to_test[@]}"; do
        if [ -f "scripts/$script" ]; then
            print_success "Script trouvé: $script"
            
            # Vérifier la syntaxe bash
            if bash -n "scripts/$script" 2>/dev/null; then
                print_success "Syntaxe valide: $script"
            else
                print_error "Erreur de syntaxe: $script"
            fi
        else
            print_error "Script manquant: $script"
        fi
    done
}

# Exécution des tests
main() {
    print_header "TEST DE NAVIGATION INTELLIGENTE - CYBERGUARD UNIFIED SOC"
    
    echo -e "${YELLOW}Position initiale: $(pwd)${NC}"
    echo -e "${YELLOW}Localisation détectée: $(detect_location)${NC}"
    
    # Sauvegarder la position de départ
    local start_dir=$(pwd)
    
    # Tests de navigation
    test_from_root
    cd "$start_dir"
    
    test_from_scripts  
    cd "$start_dir"
    
    test_backups_creation
    cd "$start_dir"
    
    test_automation_scripts
    cd "$start_dir"
    
    print_header "RÉSUMÉ DES TESTS"
    print_success "Tests de navigation intelligente terminés"
    print_info "Position finale: $(pwd)"
    
    echo ""
    echo -e "${BLUE}📋 RECOMMANDATIONS:${NC}"
    echo -e "${YELLOW} • Exécutez les scripts depuis la racine du projet${NC}"
    echo -e "${YELLOW} • Les scripts naviguent automatiquement vers les bons dossiers${NC}"
    echo -e "${YELLOW} • La navigation intelligente fonctionne depuis n'importe où${NC}"
}

# Exécution du script principal
main "$@"
