# FBU-DTW-for-signature-verification
The code of "Information Divergence-Based Matching Strategy for Online Signature Veriﬁcation"

## Information Divergence-Based Matching Strategy for Online Signature Veriﬁcation
- Paper Link: http://ieeexplore.ieee.org/document/8097414

- Title: Information Divergence-Based Matching Strategy for Online Signature Veriﬁcation
  
- Author: Lei Tang, Wenxiong Kang, Yuxun Fang (from BIP Lab, SCUT, P.R.China)
  
- Date: 2018/01/10
  
- Contact: fangyuxun@mail.scut.edu.cn
  
- COPYRIGHT (C) Lei Tang, Wenxiong Kang, Yuxun Fang 
  
- ALL RIGHTS RESERVED

  When use this code in your paper, please cite this paper.

## Instructions
  Because of the permissions, we can't provide the database. You need to add the susig and mcyt database to the folder.

  Run the "main.m" script in MATLAB.
  
  You can select the initialization parameters in __setting__.
  
## Performance
  __note__: The result is slightly different from the report of the paper, which is mainly because the numerical differences in the process of reproduction. What's more, we find a better paramether of the classifier ID2 and the performance is slightly imporved.

database |  EER TN 5  | EER TN 10 |
---------|  --------  |  -------- |
  mcyt   |    3.11%   |    2.16%  |
 susig   |    2.34%   |    1.60%  |
 
*TN: training sample number
