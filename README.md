# Bellabeat Case Study with R

Welcome to my first data analytics project! This repo dives into the Bellabeat Time wellness watch, exploring how people use smart devices to help Bellabeat improve their marketing and products.

# Acknowledgments

Before diving into the analysis, I would like to extend my gratitude to those whose work has greatly inspired me during this project:

- Zhenxiong Yang, whose detailed case study is available on [Kaggle](https://www.kaggle.com/code/zhenxiongyang/google-data-analytics-bellabeat-case-study).
- Anastasia Chebotina, for her insightful analysis also found on [Kaggle](https://www.kaggle.com/code/chebotinaa/bellabeat-case-study-with-r/notebook).
- Victor Ukegbu, whose thoughtful reflections can be read on [Medium](https://vicukegbu.medium.com/bellabeat-case-study-912c9aa2b0fa).

Their contributions to the field have provided valuable perspectives and guidance that shaped this project.

### Now, let's proceed to delve into the project! 🚀

#### This case study follows the six-step data analysis process, which ensures a thorough and systematic examination of the data. The steps are: 
#### ❓ [Ask](#step-1-ask), defining the questions and objectives;
#### 💻 [Prepare](#step-2-prepare), where we collect and organize the data;
#### 🛠️ [Process](#step-3-process), focusing on data cleaning and verification;
#### 📊 [Analyze](#step-4-analyze), where we deeply explore the data and draw insights;
#### 📋 [Share](#step-5-share), which involves presenting our findings;
#### 🧗🏻‍♀️ [Act](#step-6-share), where we make recommendations based on our analysis.

# Introduction
![Bellabeat Logo](figures/bellabeat-logo.png)

Founded in 2013 by Urška Sršen and Sandro Mur, [Bellabeat]( https://bellabeat.com/) is a high-tech company that focuses on creating beautiful, innovative products designed specifically for women. With a strong emphasis on empowering women to take control of their health and wellness, [Bellabeat]( https://bellabeat.com/) integrates smart technology into everyday items that support overall wellbeing.

[Bellabeat]( https://bellabeat.com/)’s mission is to inspire and empower women to understand their health and wellness better through innovative, technology-driven solutions. The company envisions a world where women are equipped with data and insights gained from their daily activities and health routines, enabling them to make informed decisions and improve their lifestyles.

# Step 1: Ask 

## Business task

Sršen asks you to analyze smart device usage data in order to gain insight into how consumers use non-Bellabeat smart devices. She then wants you to select one Bellabeat product (_Time_ = the wellness watch) to apply these insights to in your presentation. 

## Key stakeholders

1. Urška Sršen (Co-founder and Chief Creative Officer): Interested in leveraging data insights to guide Bellabeat's marketing strategy and unlock new growth opportunities.
2. Sando Mur (Co-founder and key member of the executive team): Concerned with the strategic direction of the company and how data analysis can contribute to achieving business goals.
3. Bellabeat marketing analytics team (including the junior data analyst): Responsible for conducting the analysis and providing actionable recommendations based on the findings.
4. Current and potential customers: Will benefit from improved products and services tailored to their needs and preferences, influenced by the insights derived from the analysis.

## Bellabeat products

- Bellabeat app: The Bellabeat app provides users with health data related to their activity, sleep, stress, menstrual cycle, and mindfulness habits. This data can help users better understand their current habits and make healthy decisions. The Bellabeat app connects to their line of smart wellness products.
- Leaf: Bellabeat’s classic wellness tracker can be worn as a bracelet, necklace, or clip. The Leaf tracker connects to the Bellabeat app to track activity, sleep, and stress.
- Time: This wellness watch combines the timeless look of a classic timepiece with smart technology to track user activity, sleep, and stress. The Time watch connects to the Bellabeat app to provide you with insights into your daily wellness.
- Spring: This is a water bottle that tracks daily water intake using smart technology to ensure that you are appropriately hydrated throughout the day. The Spring bottle connects to the Bellabeat app to track your hydration levels.
- Bellabeat membership: Bellabeat also offers a subscription-based membership program for users. Membership gives users 24/7 access to fully personalized guidance on nutrition, activity, sleep, health and beauty, and mindfulness based on their lifestyle and goals

## Key Questions

1. _What are some trends in smart device usage?_
2. _How could these trends apply to Bellabeat customers?_
3. _How could these trends help influence Bellabeat marketing strategy?_

# Step 2: Prepare

## Data description:

- File type: CSV files (there is a total of 18 datasets)
- Data size: 30 samples
- Data format: Long data
- Data duration: 03.12.2016 - 05.12.2016

## Data source:

FitBit Fitness Tracker Data on [Kaggle]( https://www.kaggle.com/datasets/arashnic/fitbit) in 18 CSV files. The data contains smart health data from personal fitness trackers for thirty fitbit users. The data was collected via a survey of personal tracker data, including minute-level output for physical activity, hear rate, and sleep monitoring, through Amazon Mechanical Turk between March 12, 2016 and May 12, 2016.

## Credibility of the data:

ROCCC (Reliable, Original, Comprehensive, Current & Cited) data test model applied in order to determine the credibility and reliability of the dataset:

- Reliable — LOW — Not reliable as it only has 30 respondents.
- Original — LOW — Third party provider (Amazon Mechanical Turk).
- Comprehensive — MEDIUM —Data is within the parameters required for the Bellabeat’s business task.
- Current — LOW — Data was sourced in 2016 (8 years old) and is not relevant.
- Cited — LOW —The third-party dataset was available by Mobius via Kaggle.

## Loading packages

I'm going to install all the necessary packages and their libraries.

```
install.packages("tidyverse")
library(tidyverse)
library(ggplot2)
library(readr)
```

The Skimr package makes summarizing data really easy.

```
install.packages("skimr")
library(skimr)
```

The Janitor package has functions for cleaning data.
```
install.packages("janitor")
library(janitor)
```

```
install.packages("dplyr")
library(dplyr)
```

The HERE package makes referencing files easier.

```
install.packages("here")
library("here")
```

## Importing the datasets

```
activity <- read.csv("dailyActivity_merged.csv")
calories <- read.csv("dailyCalories_merged.csv")
intensities <- read.csv("dailyIntensities_merged.csv")
steps <- read.csv("dailySteps_merged.csv")
sleep <- read.csv("sleepDay_merged.csv")
weight <- read.csv("weightLogInfo_merged.csv")
```
## Checking the datasets

After importing the datasets, I used the following functions to preview the data and ensure they were imported correctly:
- head()
- str()

```
head(activity)
str(activity)
```

```
head(calories)
str(calories)
```

```
head(intensities)
str(intensities)
```

```
head(steps)
str(steps)
```

```
head(sleep)
str(sleep)
```

```
head(weight)
str(weight)
```

## Findings

- Date values are formatted as chr, which needs to be transformed into the correct date/time format.
- Column names are in inconsistent format, which needs to be renamed to make further analysis easier.

# Step 3: Process

## Converting column names and fixing date formats

### activity

```
activity_new <- activity %>%
  rename_with(tolower) %>% #convert column names to lowercase
  mutate(activitydate = as.Date(activitydate, format="%m/%d/%Y")) #fixing date formats
str(activity_new) #preview the result
```
