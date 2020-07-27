#!/usr/bin/env bash

#set -x
set -euo pipefail

usage() {
    cat <<EOF
Usage: $0 -e ENV_NAME -s SUBSCRIPTION_ID [-l]
       -e      Environment Name
       -s      Subscription ID
       -l      Run locally
EOF
}

FAILOVER="false"
LOCAL="false"

parse_args() {
    while getopts ":e:s:l" opt; do
        case "${opt}" in
        e)
            export ENV_NAME=$OPTARG
            ;;
        s)
            export SUBSCRIPTION_ID=$OPTARG
            ;;
        l)
            export LOCAL="true"
            ;;
        *)
            usage
            exit 1
            ;;
        esac
    done
    if [[ -z "${ENV_NAME+x}" ]]; then
        usage >&2
        exit 1
    fi
    if [[ -z "${SUBSCRIPTION_ID+x}" ]]; then
        usage >&2
        exit 1
    fi

}

run_test() {
    if [[ "${LOCAL}" == "false" ]]; then
        az login --identity
    else
       az login
    fi

    az account set --subscription "${SUBSCRIPTION_ID}"

    bats baseinfratest/ntwrk-elements-tests.bats
    bats baseinfratest/jenkins-setup-tests.bats
    bats baseinfratest/security-elements-tests.bats 
}

main() {
    parse_args "${@}"
    run_test
}

main "$@"
