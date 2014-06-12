#!/bin/sh
curl --silent -G 'http://provisioning-plp-db.bhr.kadaster.nl:8080/v3/nodes' --data-urlencode 'query=["and",
["=", ["fact", "werkomgeving"], "fto"],
["=", ["fact", "customer"], "klic"],
["~", ["fact", "application"], "klc-.*"]]'

