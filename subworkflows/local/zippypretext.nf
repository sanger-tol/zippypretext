#!/usr/bin/env nextflow

//
// MODULE IMPORT BLOCK
//
include { RAPID_SPLIT     } from '../../modules/local/rapid_split'
include { PRETEXT_TO_TPF  } from '../../modules/local/pretext_to_tpf'
include { JUICERC         } from '../../modules/local/juicerc'
include { MAKE_PAIRS      } from '../../modules/local/make_pairs'
workflow ZIPPYPRETEXT {
take:
    fasta // channel: fasta file to produce the mapped bam --input
    pretextagp
    autosome
    hicmap
    idxfile

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
        pretextagp,
        autosome
    )
    ch_correctedagp = PRETEXT_TO_TPF.out.correctedagp
    ch_versions = ch_versions.mix(PRETEXT_TO_TPF.out.versions.first())
    
    PRETEXT_TO_TPF.out.correctedagp.map{ agpid, agp -> agp}.set{agp}
    
    JUICERC (
    	hicmap,
    	agp,
    	idxfile
    )
	ch_alignment = JUICERC.out.alignment
    ch_outlog    = JUICERC.out.outlog
    ch_versions  = ch_versions.mix(JUICERC.out.versions.first())

    MAKE_PAIRS (
        ch_alignment,
        ch_outlog
    )
    ch_pairs = MAKE_PAIRS.out.pairs
    ch_versions  = ch_versions.mix(MAKE_PAIRS.out.versions.first())

    emit:
    tpf            = ch_tpf
    correctedagp   = ch_correctedagp
    alignment      = ch_alignment
    pair           = ch_pairs
    versions       = ch_versions                 // channel: [ path(versions.yml) ]
}