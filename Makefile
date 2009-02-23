
#
# libpnd Makefile
#

# tools
CC = gcc
AR = ar
RANLIB = ranlib
RM = rm

# environment
VPATH = lib test apps
CFLAG_SO = -fPIC #-fPIC not always needed, but good to have
CFLAGS = -Wall -I./include -g ${CFLAG_SO}
CXXFLAGS = -Wall -I./include -g ${CFLAG_SO}

# code
LIB = libpnd.a 
SOLIB = libpnd.so.1         # canonicle name
SOLIB1 = libpnd.so.1.0.1    # versioned name
XMLOBJ = lib/tinyxml/tinystr.o lib/tinyxml/tinyxml.o lib/tinyxml/tinyxmlerror.o lib/tinyxml/tinyxmlparser.o
ALLOBJ = pnd_conf.o pnd_container.o pnd_discovery.o pnd_pxml.o pnd_notify.o pnd_locate.o pnd_tinyxml.o pnd_pndfiles.o pnd_apps.o

all: ${SOLIB} ${LIB} conftest discotest notifytest locatetest pndnotifyd

clean:
	${RM} -f ${ALLOBJ} ${XMLOBJ} ${LIB} ${SOLIB1} locatetest.o bin/locatetest conftest.o bin/conftest discotest.o bin/discotest bin/notifytest notifytest.o bin/pndnotifyd pndnotifyd.o ${SOLIB} testdata/dotdesktop/*.desktop testdata/apps/*.pnd
	find . -name "*~*" -exec rm {} \; -print

# component targets
#

libpnd.a:	${ALLOBJ} ${XMLOBJ}
	${AR} r ${LIB} ${ALLOBJ} ${XMLOBJ}
	${RANLIB} ${LIB}

libpnd.so.1:	${ALLOBJ} ${XMLOBJ}
	${CC} -shared -Wl,-soname,${SOLIB} -o ${SOLIB1} ${ALLOBJ} ${XMLOBJ}
	ln -f -s ${SOLIB1} ${SOLIB}

pndnotifyd:	pndnotifyd.o ${SOLIB1}
	${CC} -lstdc++ -o bin/pndnotifyd pndnotifyd.o ${SOLIB1}

# deployment and assembly components
#

pnd:
	# build x86_ls with icon
	cd testdata/pndsample; ../scripts/pnd_make.sh x86_ls.pnd x86_ls/PXML.xml x86_ls
	cd testdata/pndsample; cat x86_ls/zeldaicon.png >> x86_ls.pnd
	# build x86_echo with no icon
	cd testdata/pndsample; ../scripts/pnd_make.sh x86_echo.pnd x86_echo/PXML.xml x86_echo

deploy: 
	# populate deployment directory for copying into image bakes
	# make dirs
	mkdir -p deployment/etc/pandora/conf
	mkdir -p deployment/usr/lib
	mkdir -p deployment/usr/bin
	mkdir -p deployment/usr/pandora/apps
	mkdir -p deployment/usr/pandora/scripts
	# copy in goodies
	cp libpnd* deployment/usr/lib
	cp bin/pndnotifyd deployment/usr/bin
	cp testdata/scripts/* deployment/usr/pandora/scripts
	# copy in freebee .pnd apps to /usr/pandora/apps

# test tool targets
#

conftest:	conftest.o ${LIB}
	${CC} -lstdc++ -o bin/conftest conftest.o libpnd.a

discotest:	discotest.o ${LIB}
	${CC} -lstdc++ -o bin/discotest discotest.o libpnd.a

notifytest:	notifytest.o ${LIB}
	${CC} -lstdc++ -o bin/notifytest notifytest.o libpnd.a

locatetest:	locatetest.o ${SOLIB1}
	${CC} -lstdc++ -o bin/locatetest locatetest.o ${SOLIB1}
