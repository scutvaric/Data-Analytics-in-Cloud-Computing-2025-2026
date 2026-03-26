-- Snowflake + Superset Lab
-- Name: Employee Retention Risk 
-- Notes:
-- 1) You can use Snowsight's "Load data" UI to create and populate the raw tables.
-- 2) If you use the UI, make sure your final table names match the names below.
-- 3) After the raw tables are loaded, run the rest of this script to create the analysis views.

CREATE OR REPLACE WAREHOUSE HR_LAB_WH
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE;

CREATE OR REPLACE DATABASE HR_LAB_DB;
CREATE OR REPLACE SCHEMA HR_LAB_DB.RETENTION_LAB;

USE WAREHOUSE HR_LAB_WH;
USE DATABASE HR_LAB_DB;
USE SCHEMA RETENTION_LAB;

-- Optional DDL (only needed if you want to create empty tables before loading files)
CREATE OR REPLACE TABLE employee_history (
    employee_id NUMBER,
    first_name STRING,
    last_name STRING,
    gender STRING,
    age NUMBER,
    department STRING,
    job_role STRING,
    job_level NUMBER,
    business_unit STRING,
    office_code STRING,
    hire_date DATE,
    monthly_income_usd NUMBER,
    remote_type STRING,
    travel_frequency STRING,
    overtime_flag STRING,
    performance_rating NUMBER,
    promotion_last_24m STRING,
    attrition STRING,
    exit_date DATE
);

CREATE OR REPLACE TABLE pulse_survey (
    employee_id NUMBER,
    survey_month DATE,
    engagement_score NUMBER,
    manager_support NUMBER,
    career_growth NUMBER,
    work_life_balance NUMBER,
    stress_score NUMBER
);

CREATE OR REPLACE TABLE hr_activity (
    employee_id NUMBER,
    training_hours_ytd NUMBER,
    absence_days_ytd NUMBER,
    projects_supported NUMBER,
    recognition_events_ytd NUMBER
);

CREATE OR REPLACE TABLE office_lookup (
    office_code STRING,
    office_city STRING,
    country STRING,
    region STRING,
    timezone STRING
);

CREATE OR REPLACE TABLE current_workforce (
    employee_id NUMBER,
    first_name STRING,
    last_name STRING,
    gender STRING,
    age NUMBER,
    department STRING,
    job_role STRING,
    job_level NUMBER,
    business_unit STRING,
    office_code STRING,
    hire_date DATE,
    monthly_income_usd NUMBER,
    remote_type STRING,
    travel_frequency STRING,
    overtime_flag STRING,
    performance_rating NUMBER,
    promotion_last_24m STRING,
    engagement_score NUMBER,
    manager_support NUMBER,
    career_growth NUMBER,
    work_life_balance NUMBER,
    stress_score NUMBER,
    training_hours_ytd NUMBER,
    absence_days_ytd NUMBER,
    projects_supported NUMBER,
    recognition_events_ytd NUMBER
);

-- Main analysis view
CREATE OR REPLACE VIEW employee_retention_lab_vw AS
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    e.first_name || ' ' || e.last_name AS full_name,
    e.gender,
    e.age,
    e.department,
    e.job_role,
    e.job_level,
    e.business_unit,
    e.office_code,
    o.office_city,
    o.country,
    o.region,
    o.timezone,
    e.hire_date,
    e.exit_date,
    ROUND(DATEDIFF('day', e.hire_date, COALESCE(e.exit_date, CURRENT_DATE())) / 365.25, 1) AS tenure_years,
    e.monthly_income_usd,
    CASE
        WHEN e.monthly_income_usd < 5000 THEN 'Under 5k'
        WHEN e.monthly_income_usd < 8000 THEN '5k-8k'
        WHEN e.monthly_income_usd < 11000 THEN '8k-11k'
        ELSE '11k+'
    END AS income_band,
    e.remote_type,
    e.travel_frequency,
    e.overtime_flag,
    e.performance_rating,
    e.promotion_last_24m,
    e.attrition,
    CASE WHEN e.attrition = 'Yes' THEN 1 ELSE 0 END AS attrition_flag,
    s.survey_month,
    s.engagement_score,
    s.manager_support,
    s.career_growth,
    s.work_life_balance,
    s.stress_score,
    a.training_hours_ytd,
    a.absence_days_ytd,
    a.projects_supported,
    a.recognition_events_ytd
FROM employee_history e
LEFT JOIN pulse_survey s
    ON e.employee_id = s.employee_id
LEFT JOIN hr_activity a
    ON e.employee_id = a.employee_id
LEFT JOIN office_lookup o
    ON e.office_code = o.office_code;

-- Helpful segment view for table charts in Preset
CREATE OR REPLACE VIEW employee_attrition_segments_vw AS
SELECT
    department,
    region,
    overtime_flag,
    travel_frequency,
    work_life_balance,
    stress_score,
    COUNT(*) AS employees,
    SUM(attrition_flag) AS leavers,
    ROUND(100.0 * SUM(attrition_flag) / NULLIF(COUNT(*), 0), 1) AS attrition_rate_pct
FROM employee_retention_lab_vw
GROUP BY 1,2,3,4,5,6;

-- Bonus: current-workforce risk scoring view
CREATE OR REPLACE VIEW current_workforce_risk_vw AS
SELECT
    c.*,
    o.office_city,
    o.country,
    o.region,
    ROUND(DATEDIFF('day', c.hire_date, CURRENT_DATE()) / 365.25, 1) AS tenure_years,
    (
        CASE WHEN c.overtime_flag = 'Yes' THEN 20 ELSE 0 END +
        CASE WHEN c.travel_frequency = 'Frequently' THEN 15
             WHEN c.travel_frequency = 'Sometimes' THEN 8 ELSE 0 END +
        CASE WHEN c.work_life_balance <= 2 THEN 18
             WHEN c.work_life_balance = 3 THEN 6 ELSE 0 END +
        CASE WHEN c.stress_score >= 4 THEN 15
             WHEN c.stress_score = 3 THEN 5 ELSE 0 END +
        CASE WHEN c.manager_support <= 2 THEN 12 ELSE 0 END +
        CASE WHEN c.career_growth <= 2 THEN 10 ELSE 0 END +
        CASE WHEN c.promotion_last_24m = 'No' THEN 6 ELSE 0 END +
        CASE WHEN c.engagement_score < 60 THEN 10
             WHEN c.engagement_score < 70 THEN 5 ELSE 0 END +
        CASE WHEN c.absence_days_ytd >= 10 THEN 6 ELSE 0 END
    ) AS risk_score,
    CASE
        WHEN (
            CASE WHEN c.overtime_flag = 'Yes' THEN 20 ELSE 0 END +
            CASE WHEN c.travel_frequency = 'Frequently' THEN 15
                 WHEN c.travel_frequency = 'Sometimes' THEN 8 ELSE 0 END +
            CASE WHEN c.work_life_balance <= 2 THEN 18
                 WHEN c.work_life_balance = 3 THEN 6 ELSE 0 END +
            CASE WHEN c.stress_score >= 4 THEN 15
                 WHEN c.stress_score = 3 THEN 5 ELSE 0 END +
            CASE WHEN c.manager_support <= 2 THEN 12 ELSE 0 END +
            CASE WHEN c.career_growth <= 2 THEN 10 ELSE 0 END +
            CASE WHEN c.promotion_last_24m = 'No' THEN 6 ELSE 0 END +
            CASE WHEN c.engagement_score < 60 THEN 10
                 WHEN c.engagement_score < 70 THEN 5 ELSE 0 END +
            CASE WHEN c.absence_days_ytd >= 10 THEN 6 ELSE 0 END
        ) >= 60 THEN 'High'
        WHEN (
            CASE WHEN c.overtime_flag = 'Yes' THEN 20 ELSE 0 END +
            CASE WHEN c.travel_frequency = 'Frequently' THEN 15
                 WHEN c.travel_frequency = 'Sometimes' THEN 8 ELSE 0 END +
            CASE WHEN c.work_life_balance <= 2 THEN 18
                 WHEN c.work_life_balance = 3 THEN 6 ELSE 0 END +
            CASE WHEN c.stress_score >= 4 THEN 15
                 WHEN c.stress_score = 3 THEN 5 ELSE 0 END +
            CASE WHEN c.manager_support <= 2 THEN 12 ELSE 0 END +
            CASE WHEN c.career_growth <= 2 THEN 10 ELSE 0 END +
            CASE WHEN c.promotion_last_24m = 'No' THEN 6 ELSE 0 END +
            CASE WHEN c.engagement_score < 60 THEN 10
                 WHEN c.engagement_score < 70 THEN 5 ELSE 0 END +
            CASE WHEN c.absence_days_ytd >= 10 THEN 6 ELSE 0 END
        ) >= 35 THEN 'Medium'
        ELSE 'Low'
    END AS risk_band
FROM current_workforce c
LEFT JOIN office_lookup o
    ON c.office_code = o.office_code;



SELECT CONCAT(first_name,' ',last_name) as full_name, department, region, risk_score, risk_band
FROM current_workforce_risk_vw
ORDER BY risk_score DESC
LIMIT 20;

-- Quick validation queries
SELECT COUNT(*) AS employee_rows FROM employee_history;
SELECT COUNT(*) AS survey_rows FROM pulse_survey;
SELECT COUNT(*) AS activity_rows FROM hr_activity;
SELECT COUNT(*) AS office_rows FROM office_lookup;
SELECT COUNT(*) AS current_rows FROM current_workforce;

SELECT
    ROUND(100.0 * SUM(attrition_flag) / COUNT(*), 1) AS attrition_rate_pct
FROM employee_retention_lab_vw;

SELECT
    department,
    ROUND(100.0 * SUM(attrition_flag) / COUNT(*), 1) AS attrition_rate_pct
FROM employee_retention_lab_vw
GROUP BY 1
ORDER BY 2 DESC;
