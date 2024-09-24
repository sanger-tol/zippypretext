#!/usr/bin/env nextflow

//
// MODULE IMPORT BLOCK
//
include { RAPID_SPLIT  } from '../../modules/local/rapid_split'

workflow ZIPPYPRETEXT {
take:
    fasta // channel: fasta file to produce the mapped bam --input

    main:

    ch_versions = Channel.empty()
    ch_multiqc_files = Channel.empty()

    //
    // MODULE: Run RAPID_SPLIT
    //
    RAPID_SPLIT (
        fasta
    )
    ch_tpf = RAPID_SPLIT.out.tpf
    ch_versions = ch_versions.mix(FASTQC.out.versions.first())

    emit:
    tpf            = ch_tpf
    versions       = ch_versions                 // channel: [ path(versions.yml) ]
}