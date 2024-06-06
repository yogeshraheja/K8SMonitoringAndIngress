#!/bin/bash
mkdir /var/tmp/thinknyxosgather
##############
#Node Details#
##############
oc get nodes
oc get nodes > /var/tmp/thinknyxosgather/nodes
oc describe nodes > /var/tmp/thinknyxosgather/nodesdetailed
##################
#Current Projects#
##################
oc projects
oc projects > /var/tmp/thinknyxosgather/projects
oc get namespaces
oc get namespaces > /var/tmp/thinknyxosgather/namespaces
#################
#Machine configs#
#################
oc get mcp
oc get mcp > /var/tmp/thinknyxosgather/mcp
##############
#Operators ###
##############
oc get co
oc get co > /var/tmp/thinknyxosgather/co
#################
#Cluster Version#
#################
oc get clusterversion
oc get clusterversion > /var/tmp/thinknyxosgather/clusterversion
oc describe clusterversion
oc describe clusterversion > /var/tmp/thinknyxosgather/clusterversiondetails
##############
#Operator Ver#
##############
oc get cvo
oc get cvo > /var/tmp/thinknyxosgather/cvo
oc get csv -A
oc get csv -A > /var/tmp/thinknyxosgather/csvall
##############
#Pod Details##
##############
oc get pods -A | egrep -v 'Running|Completed|Terminated|Succeeded'
oc get pods -A
oc get pods -A > /var/tmp/thinknyxosgather/podsall
oc get pods -A -o wide
oc get pods -A -o wide > /var/tmp/thinknyxosgather/podsdetailed
###############
#Storage Class#
###############
oc get sc
oc get sc > /var/tmp/thinknyxosgather/sc
#################
#Version Cluster#
#################
oc version
oc version > /var/tmp/thinknyxosgather/ocversion
#################
#Machine Details#
################
oc get machineconfigs
oc get machineconfigs > /var/tmp/thinknyxosgather/mconfigs
###################
#Disruption Budget#
##################
oc get pdb -A
oc get pdb -A > /var/tmp/thinknyxosgather/pdb
##############
#Cluster Logs#
##############
#oc get clusterlogging -A
#oc get clusterlogging -A > /var/tmp/thinknyxosgather/logs
