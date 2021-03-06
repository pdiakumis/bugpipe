version 1.0

task eval {
  input {
    File vcf1
    File vcf2
    File vcf1_tbi = vcf1 + ".tbi"
    File vcf2_tbi = vcf2 + ".tbi"
    String outdir # woof/final/<sample>/sv_eval/<flabel>
    String sample
    String flabel # e.g. manta_bc
    }

  command {
      #conda activate woof

      R --vanilla <<CODE
      library(woofr)
      library(dplyr)
      mi <- manta_isec('~{vcf1}', '~{vcf2}', '~{sample}', '~{flabel}')
      mi_stats <- manta_isec_stats(mi, '~{sample}', '~{flabel}')
      get_circos(mi, '~{sample}', '~{outdir}')
      fpfn <- dplyr::bind_rows(mi[c("fp", "fn")], .id = "FP_or_FN")
      utils::write.table(mi_stats, file = file.path('~{outdir}', "eval_metrics.tsv"), quote = FALSE, sep = "\t", row.names = FALSE, col.names = TRUE)
      utils::write.table(fpfn, file = file.path('~{outdir}', "fpfn.tsv"), quote = FALSE, sep = "\t", row.names = FALSE, col.names = TRUE)
      CODE
  }

  output {
    File isec_stats = "~{outdir}/eval_metrics.tsv"
    File fpfn = "~{outdir}/fpfn.tsv"
    File circos = "~{outdir}/circos_~{sample}.png"
  }
}

#workflow sv {
#
#call eval {
#  input:
#    vcf1 = "/Users/pdiakumis/Desktop/projects/umccr/woof/nogit/data/umccrise_0.15.12/p25/final/2016_249_18_WH_P025-sv-prioritize-manta.vcf.gz",
#    vcf2 = "/Users/pdiakumis/Desktop/projects/umccr/woof/nogit/data/umccrise_0.15.6/p25/umccrised/p25/2016_249_18_WH_P025__CCR180149_VPT-WH025-E-manta.vcf.gz",
#    sample = "P025",
#    flab = "manta-um-bc",
#    outputdir = "/Users/pdiakumis/Desktop/projects/umccr/woofr/nogit/circos"
#
#  }
#
#}
#
