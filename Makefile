CC=
CTN1=pandoc/latex
CTN2=i13302/printout
TZ=-e TZ=Asia/Tokyo

WORKDIR=work

CSSDIR=css
HTMLDIR=html
MDDIR=markdown
PDFDIR=pdf

setup:
	mkdir -p ${WORKDIR}/${CSSDIR} ${WORKDIR}/${HTMLDIR} ${WORKDIR}/${MDDIR} ${WORKDIR}/${PDFDIR}

build:
	docker build . -t $(CTN2)

run:
	perl run.pl --htmltopdf=$(CTN2) --work=${WORKDIR} --markdown=${MDDIR} --html=${HTMLDIR} --css=${CSSDIR} --pdf=${PDFDIR} --mdtohtml=${CTN1} --htmltopdf=${CTN2} --TZ=${TZ}

clean:
	-rm -f ${WORKDIR}/${HTMLDIR}/*.html ${WORKDIR}/${PDFDIR}/*.pdf
