process PRETEXT_TO_TPF {
    tag "$meta.id"
    label 'process_single'

    container 'ghcr.io/sanger-tol/agp-tpf-utils:1.0.2'

    input:
    tuple val(meta), path(mappedtpf)
    path(pretextagp)
    val(autosomeprefix)


    output:
    tuple val(meta), path("*agp")  , emit: correctedagp
    path "versions.yml"            , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args    = task.ext.args     ?: ''
    def prefix  = task.ext.prefix   ?: "${meta.id}"

    """
    pretext-to-tpf -a ${mappedtpf} -p ${pretextagp} -c ${autosomeprefix} -o ${prefix}_corrected.agp ${args}
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        agp-tpf-utils: \$(agp-tpf-utils --version | sed 's/agp-tpf-utils //g')
    END_VERSIONS
    """

    stub:
    def prefix  = args.ext.prefix   ?: "${meta.id}"
    """
    touch ${prefix}.agp

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        agp-tpf-utils: \$(agp-tpf-utils --version | sed 's/agp-tpf-utils //g')
    END_VERSIONS
    """
}
