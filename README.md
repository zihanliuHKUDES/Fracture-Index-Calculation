# A computational algorithm for calculating fracture index of core runs
Fracture Index (FI) represents the count of fractures over an arbitrary length of a core with similar intensity of fracturing, which provides insight into the fracture state of rock masses supplement to Rock Quality Designation, Total Core Recovery, and Solid Core Recovery. Manual interpretation of core is not only time-consuming but also prone to human error. To address these challenges, this study develops a computational algorithm that automatically calculates the FI of core runs based on fracture spacing data. The variance of fracture spacing values is selected as the key evaluating indicator. The algorithm automatically groups fractures appearing in core imagery based on the uniformity of fracture spacing. Upon counting the number of fractures in each group over a certain length of core run obtained from the optimal grouping scheme, the algorithm outputs the FIs automatically. The algorithm’s performance has been effectively demonstrated on synthetic data and three real-world core datasets. Algorithm results show good agreement with those produced by logging geologists and listed in standard human-generated reports. The occasional discrepancies are attributed to the inherent subjective nature associated with manual logging.
## Reference:
Wong L. N. Y., Liu Z., Tse K. K. C., Cheung S. H., Yu L. (2023) A computational algorithm for calculating fracture index of core runs. Rock Mech Rock Eng. DOI: 10.1007/s00603-023-03422-z
## Requirement:
The methods are realized using MATLAB R2022a. The precondition of using this program is that the fracture spacing data of joints and Non-Intact segments on the core run are identified by an AI-based computer vision method or other methods.
## Instructions:
The algorithm is implemented in our self-coded MATLAB program for its high efficiency in matrix calculation and powerful data visualization. Besides, MATLAB codes are easy to be understood and adapted. Some comments follow the codes in lines can be helpful for getting familiar with this program.

You need to provide the fracture spacing as an array to the codes. As examples show in the head of the codes, the input fracture spacing array should be included in the array “si”. Then, you need to set up some parameters which will highly affect the results of outputs. “cv” is the critical spacing (cm) in the codes. “cn” is the critical number. “minG” is the minimum group member number. As for the detailed introduction of these parameters, you can refer to the Reference. After determining the parameters, just run the codes. Then, it will show the fracture grouping result and fracture index of the core runs.

We have provided three synthetic data in the head of the codes, Case 1—regular spacings, Case 2—regular spacings with an HF segment, and Case 3—random non-identical spacings with an HF segment, as follows:

S<sub>I</sub> = {50, 50, 50, 50, 50, 50, 30, 30, 30, 30, 30, 10, 10, 10, 10, 10, 10, 40, 40, 40, 40, 40, 15, 15, 15, 15, 15, 15, 15} (unit: cm).
![This is an image](https://github.com/zihanliuHKUDES/Fracture-Index-Calculation/blob/main/regular.svg)
S<sub>II</sub> = {50, 50, 50, 50, 50, 50, 30, 30, 30, 30, 30, 10, 10, 10, 10, 10, 10, 40, 5, 5, 5, 5, 15, 15, 15, 15, 15, 15, 15} (unit: cm).
![This is an image](https://github.com/zihanliuHKUDES/Fracture-Index-Calculation/blob/main/regular%20with%20NI.svg)
S<sub>III</sub> = {50, 45, 65, 55, 40, 53, 31, 35, 38, 39, 28, 11, 15, 10, 16, 17, 14, 42, 5, 4.9, 4, 1, 12, 13, 14, 15, 11, 13, 18} (unit: cm).

![This is an image](https://github.com/zihanliuHKUDES/Fracture-Index-Calculation/blob/main/random.svg)

You can get familiar with the codes with these synthetic data, and then you can process your own data by using the codes. Also, you can further adapt the codes for your own situation. Enjoy it!
