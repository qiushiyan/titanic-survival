# Abstract

This case study showcases the development of a binary logistic model to predict the probability of survival in the loss of Titanic. I demonstrate the overall modeling process, including preprocessing, exploratory analysis,  model fitting, adjustment, bootstrap internal validation and interpretation as well as other relevant techniques such as redundancy analysis and multiple imputation for missing data. The motivation and justification behind critical statistical decisions are explained, touching on key issues such as the choice of a statistical model or a machine learning model, using bootstrap to alleviate selection bias, disadvantages of the holdout sample approach in validation, and more. This analysis is fully reproducible with all source R code and text. 

In addition to modeling, we answer the following practical questions 

- To what degree is the *women and children policy* put into effect, and how it was interwoven with socio-economic status and self interest. 

- What's the crewmembers's surviving situation.  

- Does having companions (e.g., parents, children, siblings and spouse) on the vessel increase or decrease survival probability. 

- Would nationality influence survival. For example, did English subjects gained an advantage in a British-managed ship. 





# Ackownledgement

- Philip hind and [Encyclopedia Titanica](encyclopedia-titanica.org) for being tremendously helpful in providing the most accurate, updated titanic data 

- Dr. Frank Harrell for the inspiring textbook *Regression Modeling Strategies* and similar case study

# Further Study

More graphical methods (e.g., mosaic plot), see Analysis of Categorical Data by Michael Friendly

incorporation cabin class and `vcd::Lifeboats` to study the impact of passenger's location and leaving order of lifeboats 
