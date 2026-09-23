"""Named mechanistic follow-up; the existing native producer reads source fibres."""
import run_mechanism_rna as run

run.OUT=run.ROOT/'build/integrin_rna'
run.OUT.mkdir(exist_ok=True)
run.PAIRS=['GFI1_MED24','HDAC3_KDM1A','EP300_KDM1A','SMARCA5_SMARCD1']
run.GENES=[
    # Receptors, assembly and actin-coupled signaling.
    'ITGAM','ITGAX','ITGAL','ITGB2','ITGB1','TLN1','FERMT3','APBB1IP',
    'VASP','VCL','PXN','RAP1A','RAP1B','SRF','MRTFA','FHL2',
    # Endosomal/lysosomal organization and transport.
    'RAB5A','RAB7A','RAB11A','RAB11B','RAB27A','RAB27B',
    'LAMP1','LAMP2','CD63','CTSS','CTSB','CTSD','TFEB','TFE3',
    # Lineage regulators and markers, retained individually.
    'SPI1','CEBPA','CEBPB','IRF8','MAFB','EGR2','CSF1R','LYZ','S100A4',
    'S100A8','S100A9','AZU1','ELANE','MPO','PRTN3','CD14','FCER1G','TYROBP',
    # Perturbed targets and growth/iron-receptor observations.
    'GFI1','MED24','HDAC3','KDM1A','EP300','SMARCA5','SMARCD1',
    'MKI67','TOP2A','MYC','TFRC','CDKN1A']

if __name__=='__main__':run.main()
