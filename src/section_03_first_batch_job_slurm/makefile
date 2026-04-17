CC     ?= cc
CFLAGS ?= -O3 -mcpu=neoverse-v2 -std=c11 -Wall -Wextra

.DEFAULT_GOAL = all

.PHONY: all clean help

all: matmul_dgemm matmul_sgemm  ## build both the double- and single-precision BLAS matmul binaries

matmul_dgemm: matmul.c  ## build the cblas_dgemm (double precision) binary
	$(CC) $(CFLAGS) -o $@ $<

matmul_sgemm: matmul.c  ## build the cblas_sgemm (single precision) binary
	$(CC) $(CFLAGS) -DUSE_SGEMM -o $@ $<

clean:  ## remove built binaries
	rm -f matmul_dgemm matmul_sgemm

help:  ## print this help message
	@awk 'BEGIN{w=0;n=0}{while(match($$0,/\\$$/)){sub(/\\$$/,"");getline nextLine;$$0=$$0 nextLine}if(/^[[:alnum:]_-]+:.*##.*$$/){n++;split($$0,parts,":.*##");targets[n]=parts[1];helps[n]=parts[2];l=length(targets[n]);if(w<l)w=l}}END{for(i=1;i<=n;i++)printf"\033[1m\033[93m%-*s\033[0m%s\n",w+1,targets[i]":",helps[i]}' $(MAKEFILE_LIST)
