
# JBoss, Home of Professional Open Source
# Copyright 2016, Red Hat, Inc., and others contributors as indicated
# by the @authors tag. All rights reserved.
# See the copyright.txt in the distribution for a
# full listing of individual contributors.
# This copyrighted material is made available to anyone wishing to use,
# modify, copy, or redistribute it subject to the terms and conditions
# of the GNU Lesser General Public License, v. 2.1.
# This program is distributed in the hope that it will be useful, but WITHOUT A
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more details.
# You should have received a copy of the GNU Lesser General Public License,
# v.2.1 along with this distribution; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA  02110-1301, USA.

# ALLOW JOBS TO BE BACKGROUNDED
set -m

echo "Running Mapped Service Names"

generate_server -Dservice.names=ONE,TWO -Dserver.output.file=hiprio  -Dserver.includes=BarService.c -Dserver.name=hiprio
if [ "$?" != "0" ]; then
	exit -1
fi
generate_server -Dservice.names=THREE,FOUR -Dserver.output.file=loprio  -Dserver.includes=BarService.c -Dserver.name=loprio
if [ "$?" != "0" ]; then
	exit -1
fi

export BLACKTIE_CONFIGURATION=linux
btadmin startup
if [ "$?" != "0" ]; then
	exit -1
fi
unset BLACKTIE_CONFIGURATION

generate_client -Dclient.includes=client.c
./client
if [ "$?" != "0" ]; then
	killall -9 hiprio
	killall -9 loprio
	exit -1
fi

export BLACKTIE_CONFIGURATION=linux
btadmin shutdown
if [ "$?" != "0" ]; then
	exit -1
fi
unset BLACKTIE_CONFIGURATION
