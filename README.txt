+++++++++++++++++++++ ABOUT ++++++++++++++++++++++++++++++++++
==============================================================
This folder contains the implementation of the paper titled:
"Correlated Cascades: Compete or Cooperate", 
by, Ali Zarezade, Ali Khodadadi, Mehrdad Farajtabar, Hamid R. Rabiee,
Hongyuan Zha, and Le Song. 
For more information please see: http://ml.dml.ir/research/4c

© 2015 Ali Khodadadi, Ali Zarezade All Rights Reserved.
++++++++++++++++++++++ Folders +++++++++++++++++++++++++++++++
==============================================================
The main folders are as the followings:
1. Data:
	This folder contains the synthetic and real data sets we 
	used in our experiments.
2. Simulation:
	This folder contains the files that are necessary to simulate 
	the CC model. 
3. Inference:
	This folder contains the files which are necessary to infer the
	parameters of CC method and other competitive methods. 
	The inferred parameters will be saved in "Results" folder.
4. Evaluation:
	This folder contains the files which do the evaluation of methods
	on both synthetic and real data sets.
	The results of evaluations will be saved in "Results" folder.
5. Plot:
	This folder contains some functions to plot some results of different
	methods. 
6. Results:
	This folder contains the learned parameters of different methods and
	final results of evaluating different methods. 
	
The details of implementations are provided in each file.

++++++++++++++++++++++++ RUN +++++++++++++++++++++++++++++++++
==============================================================
To execute the experiments please run the following files:
1. Synth_runBatch.m:
	This file executes the experiments on synthetic data,
	and saves the results in "Results" folder.
2. Real_runBatch.m:
	This file executes the experiments on real data,
	and saves the results in "Results" folder.

+++++++++++++++++++++++++ Disclaimer +++++++++++++++++++++++++ 
==============================================================
If you find a bug, please send the bug report to "khodadadi@ce.sharif.edu",
including if necessary the input file and the parameters that caused the bug.
You can also send me any question, comment or suggestion about the code.