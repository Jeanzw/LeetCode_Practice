select
sample_id,
dna_sequence,
species,
case when dna_sequence like 'ATG%' then 1 else 0 end as has_start,
case when dna_sequence like '%TAA' or dna_sequence like '%TAG' or dna_sequence like '%TGA' then 1 else 0 end as has_stop,
case when dna_sequence like '%ATAT%' then 1 else 0 end as has_atat,
case when dna_sequence like '%GGG%' then 1 else 0 end as has_ggg
from Samples
order by 1

----------------------------

-- Python
import pandas as pd
import numpy as np

def analyze_dna_patterns(samples: pd.DataFrame) -> pd.DataFrame:
    samples['has_start'] = np.where(samples['dna_sequence'].str.startswith('ATG'), 1, 0)
    samples['has_stop'] = np.where(samples['dna_sequence'].str.endswith(('TAA','TAG','TGA')), 1, 0)
    samples['has_atat'] = np.where(samples['dna_sequence'].str.contains('ATAT'), 1, 0)
    samples['has_ggg'] = np.where(samples['dna_sequence'].str.contains('GGG'), 1, 0)
    return samples.sort_values('sample_id')