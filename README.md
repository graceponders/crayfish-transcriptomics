Transcriptomic analysis of gill and hepatopancreas tissue from Cherax robustus and Cherax quadricarinatus. Methodology for RNA extraction, amplification, sequencing and bioinformatics is derived from Smith et al., 2023.  
CLC Genomics Workbench used to clean and assemble RNA-Seq libraries. To account for interspecific differences in transcriptome assembly and annotation, orthologous transcripts were identified using a reciprocal BLAST search in Galaxy Australia. 
Predicted transcript sequences from each tissue-specific assembly of one species were compared against the corresponding tissue assembly of the other species using BLASTp. For each query, the top-scoring hit was retained, and reciprocal best hits between species were identified. 
Only transcript pairs for which both species agreed on each other as the best match were retained, resulting in a putative 6179 orthologues. 

First part of the script filters differential expression based on a log2 fold change > 1, Bonferroni p value < 0.05, and FDR p value <0.05, yielding a total of 6 downregulated transcripts and 38 upregulated transcripts across both tissues. 

The 44 DEGs were characterised using BlastP on NCBI. Expression of annotated DEGs was visualised with heatmaps in the second part of this script. 
