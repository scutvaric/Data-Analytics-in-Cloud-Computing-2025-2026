# EX_3 — Snowflake & Superset Employee Retention Lab

In this exercise you build a cloud analytics workflow using **Snowflake** and **Apache Superset (Preset)** to analyze employee attrition risk.

You will:
- Load HR datasets into Snowflake  
- Create an analysis view  
- Connect Superset to Snowflake  
- Build an Employee Retention dashboard  
- Answer business questions  

> Full instructions are in `EX_3_instructions.pdf`

---

## Dataset

The lab uses the following CSV files:

- `employee_history.csv`
- `pulse_survey.csv`
- `hr_activity.csv`
- `office_lookup.csv`
- `current_workforce.csv`

These are combined in Snowflake into a single analysis view.

---

## Snowflake Output

Create the view:
EMPLOYEE_RETENTION_LAB_VW

This view joins employee history, survey data, HR activity, and office lookup
to produce the dataset used in Superset.

---

## Superset Dashboard

Create dashboard:
Employee Retention Risk Dashboard

- KPI: total employees  
- KPI: attrition rate  
- Attrition by department  
- Attrition vs overtime  
- Attrition vs travel frequency  
- Stress vs work-life balance heatmap  
- Attrition breakdown table  

Filters:

- department  
- region  
- remote_type  

---

## Expected Findings

- Overall attrition ≈ 16–17%  
- Customer Support and Operations highest attrition  
- Overtime increases attrition  
- Frequent travel increases attrition  
- High stress + low work-life balance = highest risk  

---

## Files in this folder

- `EX_3_instructions.pdf`
- `snowflake_setup.sql`
- `employee_history.csv`
- `pulse_survey.csv`
- `hr_activity.csv`
- `office_lookup.csv`
- `current_workforce.csv`