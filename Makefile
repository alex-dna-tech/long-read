.DEFAULT: run
DRIT=docker run -it --rm
IMG=dnat4/long-read
RUN=$(DRIT) -v $(CURDIR)/course_data:/mnt $(IMG)
DATA_DIR=/mnt/practicals
OUT_DIR=$(DATA_DIR)/results

.PHONY: run
run:
	$(RUN)

.PHONY: test-basecall
test-basecall:
	$(RUN) guppy_basecaller --compress_fastq \
		-i $(DATA_DIR)/basecalling_practical/fast5 \
		-s $(OUT_DIR)/guppy_out \
		-c dna_r9.4.1_450bps_hac.cfg \
		--num_callers 5 --cpu_threads_per_caller 14

.PHONY: test-qc-picoqc
test-qc-picoqc:
	$(RUN) pycoQC -f $(DATA_DIR)/qc_practical/summaries/run_1/sequencing_summary.txt -o $(OUT_DIR)/run_1.html
	$(RUN) pycoQC -f $(DATA_DIR)/qc_practical/summaries/run_2/sequencing_summary.txt -o $(OUT_DIR)/run_2.html
	$(RUN) pycoQC -f $(DATA_DIR)/qc_practical/summaries/run_3/sequencing_summary.txt -o $(OUT_DIR)/run_3.html

.PHONY: test-qc-minionqc
test-qc-minionqc:
	$(RUN) MinIONQC.R -i $(DATA_DIR)/qc_practical/summaries -o $(OUT_DIR)/minion_qc_result
	

.PHONY: test-filter
test-filter:
	$(RUN) porechop -i $(DATA_DIR)/qc_practical/summaries -o $(OUT_DIR)/minion_qc_result

.PHONY: clean
clean:
	rm -rf $(OUT_DIR)
