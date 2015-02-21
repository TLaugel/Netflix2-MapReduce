# DonneesMassives
This project is a following of the one that can be found in the repository: http://github.com/TLaugel/Privacy-for-Netflix-contest

The goal of this project is to use the Map Reduce technology to tackle the dimensionnality issue raised by our first attempt at solving the Netflix recommendations problem. We used PIG to compute our recommendations on a Microsoft Azure cluster, and Python (IPython Notebook) to communicate with this machine. 

Despite based on the same data, this project does not focus like the first one on ensuring privacy of the users, but rather on using all data available to find the best movie recommendations. Thus, the computation of the movie/user effects is simplified. Moreover, we also decided not to include the SVD decomposition to focus on the k-NN algorithm.

This project was made in collaboration with Benjamin DONNOT

_________________________
Files description:

Main Files:
- Donnees_Massives.pdf: project report (French)
- compute_effects.pig: PIG script for the computation of the movie and user effects
- compute_pred_small.pig: PIG script for the computation of the movie/movie covariance matrix
- compute_reco.pig: PIG script for computation of the final rating prediction
- compute_reco.ipynb: final code (python connexion to the server + PIG scripts)

Other files:
- uploadData.ipynb: upload data on the server
- convertDate.pig: solving a date format problem
- create_histogram_by_date.pig: PIG script for the temporal density of the data, to split between train and test sets
- create_train_test.pig: PIG script for the train-test splitting
- splitData.ipynb: final code for data splitting (python connexion + PIG scripts)
