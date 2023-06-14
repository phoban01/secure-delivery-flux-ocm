#!/usr/bin/env bash

. ../demo-magic.sh

DEMO_PROMPT="${GREEN}➜ ${CYAN}\W ${COLOR_RESET}"

VERSION=v1.0.0
COMPONENT_NAME=ocm.software/demos/podinfo:${VERSION}
OUTPUT_DIR=.out
KEYNAME=ocm-signing
TARGET_REGISTRY=gitea.ocm.dev/software-provider

make clean

clear

# BUILD
pe "ocm add componentversions --create --file ${OUTPUT_DIR} --version ${VERSION} --scheme v3alpha1 componentfile.yaml"

# SIGN
pe "ocm sign component --lookup gitea.ocm.dev/software-provider --signature ${KEYNAME} --private-key ../00-setup-demo/signing-keys/${KEYNAME}.rsa.key ${OUTPUT_DIR}"

# TRANSFER
pe "ocm transfer component -f ${OUTPUT_DIR} ${TARGET_REGISTRY}"

# VERIFY
pe "ocm verify component --signature ${KEYNAME} --public-key ../00-setup-demo/signing-keys/${KEYNAME}.rsa.pub ${TARGET_REGISTRY}//${COMPONENT_NAME}"

p ""
