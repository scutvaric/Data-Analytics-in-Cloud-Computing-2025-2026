# EX_5 — Azure Machine Learning Lab 

In this exercise you explore machine learning workflows in **Azure Machine Learning Studio** using **AutoML**, **Designer**, and **Jupyter notebooks**.

You will:
- Create an Azure resource group  
- Create an Azure Machine Learning workspace  
- Provision a compute instance and compute cluster  
- Train a classification model with **AutoML**  
- Build a regression pipeline with **Designer**  
- Run notebook examples for **linear regression** and **logistic regression**  

> Full instructions are in `EX_5_instructions.docx`

---

## Azure ML Resources

In this lab you create and use the following Azure resources:

- Resource group  
- Azure Machine Learning workspace  
- Compute instance  
- Compute cluster  

Suggested naming conventions are provided in the lab instructions.

---

## AutoML Output

Create an AutoML classification experiment using the `bankmarketing_train.csv` dataset.

Goal:
- Predict the `y` column  
- Use **Classification** task type  
- Compare multiple models automatically  
- Review model metrics and child jobs  

---

## Designer Output

Create a classic prebuilt Designer pipeline for regression.

Pipeline:
- `Automobile price data (Raw)` sample dataset  
- `Select Columns in Dataset`  
- `Clean Missing Data`  
- `Split Data`  
- `Linear Regression`  
- `Train Model`  
- `Score Model`  
- `Evaluate Model`  

Goal:
- Predict the `price` column  
- Review scored results and evaluation metrics  

---

## Notebooks

Use the **provisioned compute instance** to open Jupyter notebooks in Azure ML Studio.

From the cloned course repository, follow and run these notebooks:

- `EX_5-Simple_Linear_Regression.ipynb`
- `EX_5-Multiple_Linear_Regression.ipynb`
- `EX_5-Logistic_Regression_1.ipynb`
- `EX_5-Logistic_Regression_2.ipynb`
- `EX_5-Logistic_Regression_3.ipynb`

Notes:
- Run notebooks on the **compute instance**
- Clone the course repository from within Azure ML Studio to access the notebooks
- Although notebooks can submit training jobs to a **compute cluster**, in this lab you will run them directly on the compute instance for simplicity

---

## Expected Learning Outcomes

By the end of this lab, you should be able to:

- Explain the difference between **AutoML**, **Designer**, and **notebook-based** workflows  
- Provision and manage compute resources in Azure ML  
- Train a no-code classification model with AutoML  
- Build a no-code regression pipeline in Designer  
- Run and understand notebook examples for linear and logistic regression  

---

## Files in this folder

- `EX_5_instructions.docx`
- `bankmarketing_train.csv`
- `EX_5-Simple_Linear_Regression.ipynb`
- `EX_5-Multiple_Linear_Regression.ipynb`
- `EX_5-Logistic_Regression_1.ipynb`
- `EX_5-Logistic_Regression_2.ipynb`
- `EX_5-Logistic_Regression_3.ipynb`
