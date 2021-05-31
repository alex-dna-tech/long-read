.DEFAULT: run
DRIT=docker run -it --rm
IMG=dnat4/long-read
RUN=${DRIT} -v $(CURDIR)/course_data:/mnt ${IMG}
OUT_DIR=out

.PHONY: run
run:
	${RUN}

test: test-*

test-basecall:
	${RUN} guppy_basecaller -compress_fastq \
		-i /mnt/practicals/basecalling_practical/fast5 \
		-s /mnt/practicals/basecalling_practical/guppy_out \
		-c dna_r9.4.1_450bps_hac.cfg \
		-num_callers 5 -cpu_threads_per_caller 14

test-qc-picoqc:
	${RUN} pycoQC -f /mnt/practicals/qc_practical/summaries/run_1/sequencing_summary.txt -o run_1.html
	${RUN} pycoQC -f /mnt/practicals/qc_practical/summaries/run_2/sequencing_summary.txt -o run_2.html
	${RUN} pycoQC -f /mnt/practicals/qc_practical/summaries/run_3/sequencing_summary.txt -o run_3.html

test-qc-minionqc:
	MinIONQC.R -i /mnt/practicals/qc_practical/summaries -o minion_qc_result
	
