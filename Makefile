.DEFAULT: run
DRIT=docker run -it --rm
IMG=dnat4/long-read
RUN=$(DRIT) -v $(CURDIR)/course_data:/mnt $(IMG)
DATA_DIR=/mnt/practicals
PRE_DATA_DIR=/mnt/precompiled
OUT_DIR=/mnt/results

.PHONY: run
run:
	$(RUN)

.PHONY: clean
clean:
	rm -rf $(OUT_DIR)

.PHONY: test-basecall
test-basecall:
	$(RUN) guppy_basecaller --compress_fastq \
		-i $(DATA_DIR)/basecalling_practical/fast5 \
		-s $(OUT_DIR)/guppy_out \
		-c dna_r9.4.1_450bps_hac.cfg \
		--num_callers 5 --cpu_threads_per_caller 14
	cat $(OUT_DIR)/guppy_out/*.fastq > $(OUT_DIR)/all_guppy.fastq		

.PHONY: test-qc-picoqc
test-qc-picoqc:
	$(RUN) pycoQC -f $(DATA_DIR)/qc_practical/summaries/run_1/sequencing_summary.txt -o $(OUT_DIR)/run_1.html
	$(RUN) pycoQC -f $(DATA_DIR)/qc_practical/summaries/run_2/sequencing_summary.txt -o $(OUT_DIR)/run_2.html
	$(RUN) pycoQC -f $(DATA_DIR)/qc_practical/summaries/run_3/sequencing_summary.txt -o $(OUT_DIR)/run_3.html

.PHONY: test-qc-minionqc
test-qc-minionqc:
	$(RUN) MinIONQC.R -i $(DATA_DIR)/qc_practical/summaries -o $(OUT_DIR)/minion_qc_result
	
test-porechop: 
	$(RUN) /bin/bash -c "mkdir -p $(OUT_DIR)/trimming_practical/porechop/ && \
		porechop -i $(PRE_DATA_DIR)/all_guppy.fastq \
		-o $(OUT_DIR)/trimming_practical/porechop/porechopped.fastq \
		--discard_middle"

test-nanofilt: 
	$(RUN) /bin/bash -c "mkdir -p $(OUT_DIR)/trimming_practical/nanofilt/ && \
		NanoFilt -l 500 --headcrop 10 < $(OUT_DIR)/trimming_practical/porechop/porechopped.fastq \
			> $(OUT_DIR)/trimming_practical/nanofilt/nanofilt_trimmed.fastq"

test-minimap-miniasm:
	$(RUN) [ ! -d $(OUT_DIR)/assembler_practical/minimap_minasm ]] &&  \
		echo "DIR EXISTS"
		# mkdir -p $(OUT_DIR)/assembler_practical/minimap_minasm 
	# $(RUN) minimap2 -x ava-ont \
	# 	$(OUT_DIR)/trimming_practical/nanofilt/nanofilt_trimmed.fastq \
	# 	$(OUT_DIR)/trimming_practical/nanofilt/nanofilt_trimmed.fastq \
	# 	| gzip -1 > $(OUT_DIR)/assembler_practical/minimap_minasm/minimap.paf.gz
	# $(RUN) miniasm -f $(OUT_DIR)/trimming_practical/nanofilt/nanofilt_trimmed.fastq \
	# 	$(OUT_DIR)/assembler_practical/minimap_minasm/minimap.paf.gz > \
	# 	$(OUT_DIR)/assembler_practical/minimap_minasm/miniasm.gfa && \
	# $(RUN) awk '/^S/{print ">"$2"\n"$3}' miniasm.gfa \
	# 	$(OUT_DIR)/assembler_practical/minimap_minasm/miniasm.gfa > \
	# 	$(OUT_DIR)/assembler_practical/minimap_minasm/miniasm.fasta
