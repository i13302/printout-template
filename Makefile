CC=pandoc
CTN1=i13302/pandoc
CTN2=i13302/printout
TZ=-e TZ=Asia/Tokyo

WORKDIR=work
TESTDIR=test

CSSDIR=css
HTMLDIR=html
MDDIR=markdown
PDFDIR=pdf

setup:
	mkdir -p ${WORKDIR}/${CSSDIR} ${WORKDIR}/${HTMLDIR} ${WORKDIR}/${MDDIR} ${WORKDIR}/${PDFDIR}

build:
	cd pandoc   ; docker build . -t $(CTN1)
	cd printout ; docker build . -t $(CTN2)

base:
	-cp ${WORKDIR}/base/*.pdf ${WORKDIR}/pdf/
	
run:
	docker run --rm --volume "$(shell pwd)/${WORKDIR}:/data" $(CTN1) pandoc ${MDDIR} ${HTMLDIR} ${CSSDIR}

	bash printout.sh ${WORKDIR} ${HTMLDIR} ${PDFDIR} ${CTN2} "${TZ}"

check:
	perl check.pl --work=${WORKDIR} --markdown=${MDDIR} --pdf=${PDFDIR}

clean:
	-rm -f ${WORKDIR}/${HTMLDIR}/*.html ${WORKDIR}/${PDFDIR}/*.pdf

test_base:
	-cp ${TESTDIR}/base/*.pdf ${TESTDIR}/pdf/
	
test_run:
	docker run --rm --volume "$(shell pwd)/${TESTDIR}:/data" $(CTN1) pandoc ${MDDIR} ${HTMLDIR} ${CSSDIR}
	bash printout.sh ${TESTDIR} ${HTMLDIR} ${PDFDIR} ${CTN2} "${TZ}"

test_check:
	perl check.pl --work=${TESTDIR} --markdown=${MDDIR} --pdf=${PDFDIR}

test_clean:
	-rm -f ${TESTDIR}/${HTMLDIR}/*.html ${TESTDIR}/${PDFDIR}/*.pdf
