## HERVH Locus Analysis

Motivation is to synthesize several different analyses into a cohesive picture
of HERVH locus functions and how each is interweaved across naive and primed hESCs.

### 1. Creating HERVH annotation
- follow `create_bigHERVH_key.sh` in `HERVH_annotation/` dir

Based on hg38 Repeatmasker annotations obtained from UCSC Table Browser. This file contains
the merged HERVH-int and LTR7[YABC] elements that overlap in a stranded manner with 9kb, the 
traditional full-length of HERVH elements.

After merging the elements from rmsk, I classify them according to 4 categories:

- solo LTRS (1+ LTR elements within 9kb, no HERVH-ints)
  - 1,290 elements
- solo HERVH-ints (1+ HERVH-int with 9kb, no LTRs)
  - 29 elements
- flanking LTRs (HERVH-ints flanked on 5' and 3' by LTR elements)
  - 1,048 elements
- nonflanking LTRs (HERVH-ints flanked only on one side by LTR elements)
  - 253 elements
  - further classified as 5' or 3' flanking based on strand (one exception has LTR7 in middle)

The labels for such element are as follows:

```<solo|flanked|nonflanked>:<element(s)_name>:<id_number>[:5prime|3prime|middle]```

A few examples:
```
solo:LTR7Y_LTR7A:630  
solo:HERVH-int:1302  
nonflanked:LTR7B_HERVH-int:2611:5prime  
flanked:LTR7B_LTR7_HERVH-int:1729  
```


### Future Figures

1. Upset Plot: (goal: comparisons among studies)
- enhancers
- expression
- CHIP

2. Data Summary:
- include data about which LTR7[ABCY] is most abundant in which category (solo, flanked, nonflanked)
- LTR position (5' to 3')
- strandedness bias?

