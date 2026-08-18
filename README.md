# Data Warehouse and Analytics Project

A data warehousing and analytics solution demonstrating end-to-end data processing using modern data engineering practices. The project ingests raw source data, executes ETL transformations using a Medallion Architecture, models the transformed data into a star schema, and delivers analytical reports.

---

## Project Overview

This repository demonstrates the following core capabilities:
* **Architecture Design**: Implementation of Bronze, Silver, and Gold data layers.
* **ETL Pipeline Development**: Automated extraction, cleansing, transformation, and loading of ERP and CRM datasets into SQL Server.
* **Data Modeling**: Fact and dimension table construction formatted for analytical query performance.
* **Analytics & Reporting**: SQL-driven data analysis focused on core business metrics.

---

## Data Architecture

The implementation uses a three-tier Medallion Architecture:

| Layer | Description |
| :--- | :--- |
| **Bronze** | Ingests raw source data as-is from CSV files directly into SQL Server tables. |
| **Silver** | Executes data cleansing, standardization, null handling, and structural normalization. |
| **Gold** | Contains business-ready dimensional models (Star Schema) tailored for reporting and BI tools. |

---

## Project Specifications

### Data Engineering Requirements
* **Ingestion**: Process multi-source data across ERP and CRM systems.
* **Data Quality**: Correct duplicates, missing attributes, and inconsistent domain values prior to modeling.
* **Schema Design**: Single star schema optimized for sales analytics using the latest state of data (non-historical/SCD Type 0).
* **Documentation**: Data definitions cataloged within repo documentation.

### Data Analysis Requirements
Delivers SQL queries and analytical metrics for:
* Customer behavior and demographic segmentation
* Product performance and category trends
* Sales channel revenue patterns

---

## Repository Structure

```text
data-warehouse-project/
│
├── datasets/                 # Source data files (ERP and CRM)
│
├── docs/                     # Project documentation and schema diagrams
│   ├── etl.drawio
│   ├── data_architecture.drawio
│   ├── data_catalog.md
│   ├── data_flow.drawio
│   ├── data_models.drawio
│   └── naming-conventions.md
│
├── scripts/                  # SQL transformation logic
│   ├── bronze/               # Raw data extraction scripts
│   ├── silver/               # Data cleansing and transformation scripts
│   └── gold/                 # Star schema data modeling scripts
│
├── tests/                    # Data quality check scripts
│
├── .gitignore
├── LICENSE
├── README.md
└── requirements.txt
