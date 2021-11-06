CC=pandoc
CTN1=i13302/pandoc
CTN2=i13302/printout
TZ=-e TZ=Asia/Tokyo

WORKDIR=work

CSSDIR=css
HTMLDIR=html
MDDIR=markdown
PDFDIR=pdf

setup:
	mkdir -p ${WORKDIR}/${CSSDIR} ${WORKDIR}/${HTMLDIR} ${WORKDIR}/${MDDIR} ${WORKDIR}/${PDFDIR}

base:
	-cp ${WORKDIR}/base/*.pdf ${WORKDIR}/pdf/
	
run:
	docker run --rm --volume "$(shell pwd)/${WORKDIR}:/data" $(CTN1) pandoc ${MDDIR} ${HTMLDIR} ${CSSDIR}

	bash .tools/printout.sh ${WORKDIR} ${HTMLDIR} ${PDFDIR} ${CTN2} "${TZ}"

check:
	perl .tools/check.pl --work=${WORKDIR} --markdown=${MDDIR} --pdf=${PDFDIR}

clean:
	-rm -f ${WORKDIR}/${HTMLDIR}/*.html ${WORKDIR}/${PDFDIR}/*.pdf
