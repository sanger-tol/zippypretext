#!/usr/bin/env nextflow

//
// MODULE IMPORT BLOCK
//
include { RAPID_SPLIT     } from '../../modules/local/rapid_split'
include { PRETEXT_TO_TPF  } from '../../modules/local/pretext_to_tpf'

workflow ZIPPYPRETEXT {
take:
    fasta // channel: fasta file to produce the mapped bam --input
    agp
    autosome

    main:

    ch_versions = Channel.empty()

    //
    // MODULE: Run RAPID_SPLIT
    //
    RAPID_SPLIT (
        fasta
    )
    ch_tpf = RAPID_SPLIT.out.tpf
    ch_versions = ch_versions.mix(RAPID_SPLIT.out.versions.first())

    PRETEXT_TO_TPF (
        ch_tpf,
        agp,
        autosome
    )
    ch_correctedagp = PRETEXT_TO_TPF.out.correctedagp
    ch_versions = ch_versions.mix(PRETEXT_TO_TPF.out.versions.first())

    emit:
    tpf            = ch_tpf
    correctedagp   = ch_correctedagp
    versions       = ch_versions                 // channel: [ path(versions.yml) ]
}