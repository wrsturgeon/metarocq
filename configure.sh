#!/usr/bin/env bash

# Removes all generated makefiles
make -f Makefile mrproper

# Dependencies for local or global builds.
# When building the packages separately, dependencies are not set as everything
# should already be available in $(COQMF_LIB)/user-contrib/MetaCoq/*
# For local builds, we set specific dependencies of each subproject in */metacoq-config

# CWD=`pwd`

if command -v coqc >/dev/null 2>&1
then
    COQLIB=` coqc -where | tr -d '\r' | tr '\\\\' '/'`

    if [[ "$1" = "local" ]] || [[ "$1" = "--enable-local" ]] || [[ "$1" = "--enable-quick" ]]
    then
        echo "Building MetaCoq locally"
        COMMON_DEPS="-R ../utils/theories MetaCoq.Utils"
        TEMPLATE_COQ_DEPS="-R ../common/theories MetaCoq.Common"
        PCUIC_DEPS="-R ../common/theories MetaCoq.Common"
        SAFECHECKER_DEPS="-R ../pcuic/theories MetaCoq.PCUIC"
        TEMPLATE_PCUIC_DEPS="-R ../safechecker/theories MetaCoq.SafeChecker -R ../template-coq/theories MetaCoq.Template -I ../template-coq"
        ERASURE_DEPS="-R ../template-pcuic/theories MetaCoq.TemplatePCUIC -I ../template-coq"
        TRANSLATIONS_DEPS="-R ../template-coq/theories MetaCoq.Template -I ../template-coq"
        EXAMPLES_DEPS="-R ../erasure/theories MetaCoq.Erasure"
        TEST_SUITE_DEPS="-R ../erasure/theories MetaCoq.Erasure"
        PLUGIN_DEMO_DEPS="-R ../../template-coq/theories MetaCoq.Template -I ../../template-coq/"
        echo "METACOQ_CONFIG = local" > Makefile.conf
    else
        echo "Building MetaCoq globally (default)"
        COMMON_DEPS=""
        TEMPLATE_COQ_DEPS=""
        PCUIC_DEPS=""
        SAFECHECKER_DEPS=""
        TEMPLATE_PCUIC_DEPS=""
        ERASURE_DEPS=""
        TRANSLATIONS_DEPS=""
        EXAMPLES_DEPS=""
        TEST_SUITE_DEPS=""
        PLUGIN_DEMO_DEPS=""
        echo "METACOQ_CONFIG = global" > Makefile.conf
    fi

    echo "# DO NOT EDIT THIS FILE: autogenerated from ./configure.sh" > template-coq/metacoq-config
    echo "# DO NOT EDIT THIS FILE: autogenerated from ./configure.sh" > pcuic/metacoq-config
    echo "# DO NOT EDIT THIS FILE: autogenerated from ./configure.sh" > safechecker/metacoq-config
    echo "# DO NOT EDIT THIS FILE: autogenerated from ./configure.sh" > erasure/metacoq-config
    echo "# DO NOT EDIT THIS FILE: autogenerated from ./configure.sh" > translations/metacoq-config
    echo "# DO NOT EDIT THIS FILE: autogenerated from ./configure.sh" > examples/metacoq-config
    echo "# DO NOT EDIT THIS FILE: autogenerated from ./configure.sh" > test-suite/metacoq-config
    echo "# DO NOT EDIT THIS FILE: autogenerated from ./configure.sh" > test-suite/plugin-demo/metacoq-config

    echo ${COMMON_DEPS} >> common/metacoq-config
    echo ${COMMON_DEPS} ${TEMPLATE_COQ_DEPS} >> template-coq/metacoq-config
    echo ${COMMON_DEPS} ${PCUIC_DEPS} >> pcuic/metacoq-config
    echo ${COMMON_DEPS} ${TEMPLATE_COQ_DEPS} ${PCUIC_DEPS} ${SAFECHECKER_DEPS} >> safechecker/metacoq-config
    echo ${COMMON_DEPS} ${TEMPLATE_COQ_DEPS} ${PCUIC_DEPS} ${SAFECHECKER_DEPS} ${TEMPLATE_PCUIC_DEPS} >> template-pcuic/metacoq-config
    echo ${COMMON_DEPS} ${TEMPLATE_COQ_DEPS} ${PCUIC_DEPS} ${SAFECHECKER_DEPS} ${TEMPLATE_PCUIC_DEPS} ${ERASURE_DEPS} >> erasure/metacoq-config
    echo ${COMMON_DEPS} ${TEMPLATE_COQ_DEPS} ${PCUIC_DEPS} ${TRANSLATIONS_DEPS} >> translations/metacoq-config
    echo ${COMMON_DEPS} ${TEMPLATE_COQ_DEPS} ${PCUIC_DEPS} ${SAFECHECKER_DEPS} ${TEMPLATE_PCUIC_DEPS} ${ERASURE_DEPS} ${TRANSLATIONS_DEPS} ${EXAMPLES_DEPS} >> examples/metacoq-config
    echo ${COMMON_DEPS} ${TEMPLATE_COQ_DEPS} ${PCUIC_DEPS} ${SAFECHECKER_DEPS} ${TEMPLATE_PCUIC_DEPS} ${ERASURE_DEPS} ${TRANSLATIONS_DEPS} ${TEST_SUITE_DEPS} >> test-suite/metacoq-config
    echo ${PLUGIN_DEMO_DEPS} >> test-suite/plugin-demo/metacoq-config

else
    echo "Error: coqc not found in path"
fi
